
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../../../../core/widget/loading.dart';
import '../../provider/chat_provider.dart';
import '../../provider/get_all_messgae.dart';
import 'message_received.dart';
import 'message_sent.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({
    super.key,
    required this.chatroomId,
  });

  final String chatroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesList = ref.watch(getAllMessagesProvider(chatroomId));
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return messagesList.when(
      data: (messages) {
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages.elementAt(index);
            final isMyMessage = message.senderId == myUid;

            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                chatroomId: chatroomId,
                messageId: message.messageId,
              );
            }

            if (isMyMessage) {
              return SentMessage(message: message);
            } else {
              return ReceivedMessage(message: message);
            }
          },
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