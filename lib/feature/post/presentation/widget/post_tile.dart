import 'package:bona/core/constants/app_colors.dart';
import 'package:bona/core/widget/round_like_icon.dart';
import 'package:bona/feature/post/presentation/screen/comments_screen.dart';
import 'package:bona/feature/post/presentation/widget/post_image_video_view.dart';
import 'package:bona/feature/post/presentation/widget/post_info_tile.dart';
import 'package:bona/feature/post/provider/post_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widget/dropdown_button.dart';
import '../../../../core/widget/text_button_icon.dart';
import '../../../../model/post.dart';

class PostTile extends ConsumerWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // post profile
          Row(children: [
            PostInfoTile(datePublished: post.createdAt, userId: post.posterId),
            Spacer(),
            IconMenuButton(postId: post.postId, posterId: post.posterId),
          ]),

          // Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Text(post.content),
          ),

          //Picture/video
          post.fileUrl != ''
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: PostImageVideoView(
                      fileType: post.postType, fileUrl: post.fileUrl))
              : SizedBox(),
          //Status
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: PostStats(likes: post.likes)),
          SizedBox(
            height: 10,
          ),

          //Status button
          PostButtons(post: post),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class PostStats extends StatelessWidget {
  const PostStats({super.key, required this.likes});

  final List<String> likes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RoundLikeIcon(),
        SizedBox(
          width: 3,
        ),
        Text('${likes.length}'),
      ],
    );
  }
}

class PostButtons extends ConsumerWidget {
  const PostButtons({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = post.likes.contains(FirebaseAuth.instance.currentUser!.uid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconTextButton(
          icon: isLiked
              ? FontAwesomeIcons.solidThumbsUp
              : FontAwesomeIcons.thumbsUp,
          label: 'Like',
          color: isLiked ? AppColors.blueColor : AppColors.blackColor,
          onPressed: () {
            ref
                .read(postsProvider)
                .likeDislikePost(postId: post.postId, likes: post.likes);
          },
        ),
        IconTextButton(
          icon: FontAwesomeIcons.solidMap,
          label: 'Comment',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CommentsScreen.routeName, arguments: post.postId);
          },
        ),
        IconTextButton(icon: FontAwesomeIcons.share, label: 'Share'),
      ],
    );
  }

}


