import 'package:bona/core/constants/app_colors.dart';
import 'package:bona/core/constants/constant.dart';
import 'package:bona/core/widget/round_like_icon.dart';
import 'package:bona/feature/auth/provider/get_user_info_provider.dart';
import 'package:bona/feature/post/presentation/widget/round_profile_tile.dart';
import 'package:bona/feature/post/provider/post_provider.dart';
import 'package:bona/model/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../../../../core/widget/loading.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),
      child:Column(
        children: [
          //Comment header
          CommentHeader(comment: comment),
          //Comment footer
          CommentFooter(comment: comment),
        ],
      ),

    );
  }
}


class CommentHeader extends ConsumerWidget {
  const CommentHeader({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(comment.authorId));

    return userInfo.when(
      data: (user) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundProfileTile(url: user.profilePicUrl),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(comment.text),
                  ],
                ),
              ),
            )
          ],
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return const Loader();
      },
    );
  }
}

class CommentFooter extends ConsumerWidget {
  const CommentFooter({super.key, required this.comment});

  final Comment comment;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = comment.likes.contains(FirebaseAuth.instance.currentUser!.uid);
    return Consumer(builder: (context, ref, child){
      return Row(
        children: [
          Text(comment.createdAt.fromNow()),
          TextButton(onPressed: () async{
             await ref.read(postsProvider).likeDislikeComment(commentId: comment.commentId, likes: comment.likes);
          }, child: Text('Like',
          style: TextStyle(color: isLiked ? AppColors.blackColor : AppColors.greyColor),
          )),
          SizedBox(width: 20,),
          RoundLikeIcon(),
          SizedBox(width: 3,),
          Text(comment.likes.length.toString())
        ],
      );
    });
  }
}

