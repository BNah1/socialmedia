import 'package:flutter/material.dart';

import '../../../../model/message.dart';
import '../../../post/presentation/widget/post_image_video_view.dart';
import '/core/constants/app_colors.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSentMessage ? AppColors.whiteColor : AppColors.blackColor,
        ),
      );
    } else {
      return PostImageVideoView(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}