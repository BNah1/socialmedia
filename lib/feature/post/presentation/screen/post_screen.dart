import 'package:bona/core/widget/loading.dart';
import 'package:bona/feature/post/presentation/widget/create_post_widget.dart';
import 'package:bona/feature/post/provider/get_all_posts_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../../../story/presentation/screen/story_screen.dart';
import '../widget/post_tile.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        FeedMakePostWidget(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 1,
          ),
        ),
        // story
        StoriesView(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 8,
          ),
        ),
        // show posts
        PostList(),
      ],
    );
  }
}

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(getAllPostsProvider);
    return posts.when(data: (postList) {
      return SliverList.separated(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            final post = postList.elementAt(index);
            return PostTile(post: post);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 8,
            );
          });
    }, error: (error, stackTrace) {
      return SliverToBoxAdapter(
        child: ErrorScreen(error: error.toString()),
      );
    }, loading: () {
      return SliverToBoxAdapter(
        child: Loader(),
      );
    });
  }
}


