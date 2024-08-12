
import 'package:bona/model/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../../model/firebase_fieldname.dart';

@immutable
class FriendRepository {
  final _myUid = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;

  // Send request
  Future<String?> sendFriendRequest({
    required String userId,
  }) async {
    try {
      // add my uid to other to request
      _firestore.collection(FirebaseCollectionNames.users).doc(userId).update({
        FirebaseFieldNames.receivedRequests: FieldValue.arrayUnion([_myUid])
      });

      // add other uid to my list
      _firestore.collection(FirebaseCollectionNames.users).doc(_myUid).update({
        FirebaseFieldNames.sentRequests: FieldValue.arrayUnion([userId])
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // remove request
  Future<String?> removeFriendRequest({
    required String userId,
  }) async {
    try {
      // remove my uid to other to request
      _firestore.collection(FirebaseCollectionNames.users).doc(userId).update({
        FirebaseFieldNames.receivedRequests: FieldValue.arrayRemove([_myUid]),
        FirebaseFieldNames.sentRequests: FieldValue.arrayRemove([_myUid]),
      });

      // remove other uid to my list
      _firestore.collection(FirebaseCollectionNames.users).doc(_myUid).update({
        FirebaseFieldNames.sentRequests: FieldValue.arrayRemove([userId]),
        FirebaseFieldNames.receivedRequests: FieldValue.arrayRemove([userId]),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // accept
  Future<String?> acceptFriendRequest({
    required String userId,
  }) async {
    try {
      // add uid to other
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(userId)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayUnion([_myUid])
      });

      // add other 's id to me
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(_myUid)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayUnion([userId])
      });

      removeFriendRequest(userId: userId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // unfriend
  Future<String?> removeFriend({
    required String userId,
  }) async {
    try {
      // remove uid to other
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(userId)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayRemove([_myUid])
      });

      // remove other 's id to me
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(_myUid)
          .update({
        FirebaseFieldNames.friends: FieldValue.arrayRemove([userId])
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
