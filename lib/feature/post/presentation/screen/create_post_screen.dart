import 'dart:io';

import 'package:bona/core/utils/utils.dart';
import 'package:bona/core/widget/loading.dart';
import 'package:bona/core/widget/round_button.dart';
import 'package:bona/feature/post/presentation/widget/image_video_view.dart';
import 'package:bona/feature/post/presentation/widget/profile_info.dart';
import 'package:bona/feature/post/provider/post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constant.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  static const routeName = '/create-post';

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late final TextEditingController _postController;
  File? file;
  String fileType = 'image';
  bool isLoading = false;

  @override
  void initState() {
    _postController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueColor,
        actions: [TextButton(onPressed: makePost, child: Text('Post'))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Constants.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo(),
              TextField(
                controller: _postController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write something ...',
                  hintStyle: TextStyle(
                    fontSize: 19,
                    color: AppColors.greyColor,
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
              ),
              SizedBox(
                height: 20,
              ),
              file != null
                  ? ImageVideoView(
                      file: file!,
                      fileType: fileType,
                    )
                  : PickFileWidget(pickImage: () async {
                      fileType = 'image';
                      file = await pickImage();
                      setState(() {});
                    }, pickVideo: () async {
                      fileType = 'video';
                      file = await pickVideo();
                      setState(() {});
                    }),
              SizedBox(
                height: 15,
              ),
              isLoading
                  ? Loader()
                  : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RoundButton(onPressed: makePost, label: 'Post'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePost() async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(postsProvider)
        .makePost(
            content: _postController.text, file: file, postType: fileType)
        .then((value) {
      Navigator.of(context).pop();
    }).catchError((_) {
      setState(() => isLoading = false);
    });
      setState(() => isLoading = false);
  }
}

class PickFileWidget extends StatelessWidget {
  const PickFileWidget(
      {super.key, required this.pickImage, required this.pickVideo});

  final VoidCallback pickImage;
  final VoidCallback pickVideo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
            onPressed: pickImage,
            child: Icon(
              Icons.picture_in_picture_rounded,
              size: 30,
            )),
        SizedBox(
          width: 10,
        ),
        OutlinedButton(
            onPressed: pickVideo,
            child: Icon(Icons.video_collection, size: 30)),
      ],
    );
  }
}
