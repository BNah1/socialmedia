import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/firebase_collection.dart';
import '../../../model/firebase_fieldname.dart';
import '../../../model/post.dart';

final getPostFromFriendProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) async*{
  final controller = StreamController<Iterable<Post>>();

  // get list friends id
  final friends = await FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((doc) => List<String>.from(doc.data()![FirebaseFieldNames.friends]));

  final sub = FirebaseFirestore.instance
  .collection(FirebaseCollectionNames.posts)
  .orderBy(FirebaseFieldNames.datePublished, descending: true)
  .where(FirebaseFieldNames.posterId, whereIn: friends)
  .snapshots()
  .listen((snapshot) {
    final posts = snapshot.docs.map(
        (postData) => Post.fromMap(postData.data())
    );
    controller.sink.add(posts);
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  yield* controller.stream;
});