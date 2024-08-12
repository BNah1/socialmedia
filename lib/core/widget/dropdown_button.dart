import 'package:bona/feature/post/provider/post_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconMenuButton extends ConsumerWidget {
  const IconMenuButton({super.key, required this.postId , required this.posterId});

  final String postId;
  final String posterId;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () {
        _showBottomSheet(context, ref);
      },
    );
  }

  void _showBottomSheet(BuildContext context, WidgetRef ref) {
    final _myId = FirebaseAuth.instance.currentUser!.uid;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(posterId == _myId)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.blue),
                title: Text('Delete'),
                onTap: () {
                  ref.read(postsProvider).deletePost(postId);
                  Navigator.pop(context, 'Delete');
                },
              ),
            ListTile(
              leading: Icon(Icons.close, color: Colors.green),
              title: Text('Close'),
              onTap: () {
                Navigator.pop(context, 'Close');
              },
            ),
          ],
        );
      },
    );
  }
}