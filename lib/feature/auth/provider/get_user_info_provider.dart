
 import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/firebase_collection.dart';
import '../../../model/firebase_fieldname.dart';
import '../../../model/user.dart';

 final getUserInfoProvider = FutureProvider.autoDispose<UserModel>((ref) {
   return FirebaseFirestore.instance
       .collection(FirebaseCollectionNames.users)
       .doc(FirebaseAuth.instance.currentUser!.uid)
       .get()
       .then((userData) {
     return UserModel.fromMap(userData.data()!);
   });
 });

 final getUserInfoByIdProvider =
 FutureProvider.autoDispose.family<UserModel, String>((ref, userId) {
   return FirebaseFirestore.instance
       .collection(FirebaseCollectionNames.users)
       .doc(userId)
       .get()
       .then((userData) {
     return UserModel.fromMap(userData.data()!);
   });
 });


 final getUserInfoAsStreamProvider =
 StreamProvider.autoDispose<UserModel>((ref) {
   final controller = StreamController<UserModel>();

   final sub = FirebaseFirestore.instance
       .collection(FirebaseCollectionNames.users)
       .where(FirebaseFieldNames.uid,
       isEqualTo: FirebaseAuth.instance.currentUser!.uid)
       .limit(1)
       .snapshots()
       .listen((snapshot) {
     final userData = snapshot.docs.first;
     final user = UserModel.fromMap(userData.data());
     controller.sink.add(user);
   });

   ref.onDispose(() {
     controller.close();
     sub.cancel();
   });

   return controller.stream;
 });

 final getUserInfoAsStreamByIdProvider =
 StreamProvider.autoDispose.family<UserModel, String>((ref, String userId) {
   final controller = StreamController<UserModel>();

   final sub = FirebaseFirestore.instance
       .collection(FirebaseCollectionNames.users)
       .where(FirebaseFieldNames.uid, isEqualTo: userId)
       .limit(1)
       .snapshots()
       .listen((snapshot) {
     final userData = snapshot.docs.first;
     final user = UserModel.fromMap(userData.data());
     controller.sink.add(user);
   });

   ref.onDispose(() {
     controller.close();
     sub.cancel();
   });

   return controller.stream;
 });