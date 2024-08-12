import 'dart:io';

import 'package:bona/core/utils/utils.dart';
import 'package:bona/core/widget/loading.dart';
import 'package:bona/core/widget/round_button.dart';
import 'package:bona/feature/story/provider/story_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  static const routeName = '/create-story';

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  Future<File?>? imageFutre;
  bool isLoading = false;

  @override
  void initState() {
    imageFutre = pickImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: imageFutre,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          if (snapshot.data != null) {
            return Scaffold(
              body: Stack(
                children: [
                  Center(
                    child: Image.file(snapshot.data!),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 50,
                    right: 50,
                    child: isLoading
                        ? Loader()
                        : RoundButton(
                            onPressed: () async {
                              setState(() => isLoading = true);
                              await ref
                                  .read(storyProvider)
                                  .postStory(image: snapshot.data!)
                                  .then((value) {
                                setState(() => isLoading = false);
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                setState(() => isLoading = false);
                              });
                            },
                            label: 'Post Story',
                          ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
              body: const ErrorScreen(error: 'Image Not Found'));

        });
  }
}
