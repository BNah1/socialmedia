import 'dart:io';

import 'package:bona/model/chatroom.dart';
import 'package:bona/model/firebase_collection.dart';
import 'package:bona/model/firebase_fieldname.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../model/message.dart';

class ChatRepository {
  final _myUid = FirebaseAuth.instance.currentUser!.uid;
  final _storage = FirebaseStorage.instance;

  Future<String> createChatRoom({
    required String userId,
  }) async {
    try {
      CollectionReference chatRooms = FirebaseFirestore.instance.collection(
          FirebaseCollectionNames.chatrooms);
      // sort member
      final softedMembers = [_myUid, userId]..sort((a, b) => a.compareTo(b));
      //existing chatroom
      QuerySnapshot existingChatRooms = await chatRooms.where(
          FirebaseFieldNames.members, isEqualTo: softedMembers).get();

      if (existingChatRooms.docs.isNotEmpty) {
        return existingChatRooms.docs.first.id;
      } else {
        final chatRoomId = const Uuid().v1();
        final now = DateTime.now();

        Chatroom chatroom = Chatroom(
            chatroomId: chatRoomId,
            lastMessage: '',
            lastMessageTs: now,
            members: softedMembers,
            createdAt: now);

        await FirebaseFirestore.instance.collection(FirebaseCollectionNames.chatrooms)
        .doc(chatRoomId)
        .set(chatroom.toMap());

        return chatRoomId;
      }
    } catch (e) {
      return e.toString();
    }
  }
  // Send message
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: _myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: 'text',
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: message,
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Send file in message
  Future<String?> sendFileMessage({
    required File file,
    required String chatroomId,
    required String receiverId,
    required String messageType,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      // Save to storage
      Reference ref = _storage.ref(messageType).child(messageId);
      TaskSnapshot snapshot = await ref.putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Message newMessage = Message(
        message: downloadUrl,
        messageId: messageId,
        senderId: _myUid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: 'send a $messageType',
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId)
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .update({
        FirebaseFieldNames.seen: true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}