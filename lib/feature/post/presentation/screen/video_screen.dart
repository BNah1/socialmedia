import 'package:bona/core/widget/loading.dart';
import 'package:bona/feature/post/provider/get_all_videos_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../widget/post_tile.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(getAllVideosProvider);
    return posts.when(data: (postList) {
      return ListView.separated(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            final post = postList.elementAt(index);
            return PostTile(post: post);
          }, separatorBuilder: (context, index) {
        return SizedBox(
          height: 8,
        );
      });
    }, error: (error, stackTrace) {
      return ErrorScreen(error: error.toString());
    }, loading: () {
      return Loader();
    });
  }
}
