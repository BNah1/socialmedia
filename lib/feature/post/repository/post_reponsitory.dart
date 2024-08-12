import 'dart:io';

import 'package:bona/model/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

import '../../../model/firebase_fieldname.dart';
import '../../../model/post.dart';
import '../../../model/comment.dart';

@immutable
class PostRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Create Post in newfeed
  Future<String?> makePost({
    required String content,
    File? file,
    required String postType,
  }) async {
    try {
      final postId = const Uuid().v1();
      final posterId = _auth.currentUser!.uid;
      final now = DateTime.now();
      String? downloadUrl;

      if (file != null) {
        final fileUid = const Uuid().v1();
        final path = _storage.ref(postType).child(fileUid);
        final taskSnapshot = await path.putFile(file);
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
      } else {
        downloadUrl = '';
      }

      // Create post
      Post post = Post(
          postId: postId,
          posterId: posterId,
          content: content,
          postType: postType,
          fileUrl: downloadUrl,
          createdAt: now,
          likes: []);

      // Post to firestore
      _firestore
          .collection(FirebaseCollectionNames.posts)
          .doc(postId)
          .set(post.toMap());

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // like post
  Future<String?> likeDislikePost({
    required String postId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;
      if (likes.contains(authorId)) {
        // liked already
        _firestore
            .collection(FirebaseCollectionNames.posts)
            .doc(postId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayRemove([authorId])
        });
      } else {
        // not like yet
        _firestore
            .collection(FirebaseCollectionNames.posts)
            .doc(postId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayUnion([authorId])
        });
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  // Create comment in post
  Future<String?> makeComment({
    required String text,
    required String postId,
  }) async {
    try {
      final commentId = const Uuid().v1();
      final authorId = _auth.currentUser!.uid;
      final now = DateTime.now();


      // Create post
      Comment comment = Comment(commentId: commentId,
          authorId: authorId,
          postId: postId,
          text: text,
          createdAt: now,
          likes: const []);

      // Post to firestore
      _firestore
          .collection(FirebaseCollectionNames.comments)
          .doc(commentId)
          .set(comment.toMap());

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // like post
  Future<String?> likeDislikeComment({
    required String commentId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;
      if (likes.contains(authorId)) {
        // liked already
        _firestore
            .collection(FirebaseCollectionNames.comments)
            .doc(commentId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayRemove([authorId])
        });
      } else {
        // not like yet
        _firestore
            .collection(FirebaseCollectionNames.comments)
            .doc(commentId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayUnion([authorId])
        });
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  //Delete post
  Future<String?> deletePost(String postId) async {
    try {
      await _firestore
          .collection(FirebaseCollectionNames.posts)
          .doc(postId)
          .delete();

      // Xóa tệp đính kèm từ Firebase Storage nếu có
      // Lấy tài liệu bài viết để kiểm tra URL tệp đính kèm
      final docSnapshot = await _firestore
          .collection(FirebaseCollectionNames.posts)
          .doc(postId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final fileUrl = data?[FirebaseFieldNames.fileUrl] as String?;

        if (fileUrl != null && fileUrl.isNotEmpty) {
          final fileRef = _storage.refFromURL(fileUrl);
          await fileRef.delete();
        }
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
