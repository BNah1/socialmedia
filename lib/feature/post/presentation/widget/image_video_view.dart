import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../../core/widget/video_view.dart';

class ImageVideoView extends StatelessWidget {
  const ImageVideoView({super.key, required this.fileType , required this.file});

  final String fileType;
  final File file;
  @override
  Widget build(BuildContext context) {
    if(fileType == 'image'){
      return Image.file(file);
    } else {
      return VideoView(video: file,);
    }
  }
}
