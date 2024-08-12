import 'package:bona/feature/post/presentation/widget/comment_text_field.dart';
import 'package:bona/feature/post/presentation/widget/comments_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.postId});

  final String postId;
  static const routeName = '/comments';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Comment'),
      ),
      body: Column(
        children: [
          //Comments List
          CommentsList(postId: postId),
          //Comment Text field
          CommentTextField(postId: postId)
        ],
      ),
    );
  }
}
