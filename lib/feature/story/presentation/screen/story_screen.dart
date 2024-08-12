import 'package:bona/feature/story/presentation/screen/story_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/screens/error_screen.dart';
import '../../../../core/widget/loading.dart';
import '../../../auth/provider/get_user_info_provider.dart';
import '../../provider/get_all_story_provider.dart';
import '../widget/add_story_tile.dart';
import '../widget/story_tile.dart';

class StoriesView extends ConsumerWidget {
  const StoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyData = ref.watch(getAllStoriesProvider);
    return storyData.when(
      data: (stories) {
        return SliverToBoxAdapter(
          child: Container(
            height: 200,
            color: AppColors.realWhiteColor,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const AddStoryTile();
                  }

                  final story = stories.elementAt(index - 1);
                  final user =
                      ref.watch(getUserInfoByIdProvider(story.authorId));
                  return user.when(data: (user) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          StoryViewScreen.routeName,
                          arguments: stories.toList(),
                        );
                      },
                      child: StoryTile(
                        imageUrl: story.imageUrl,
                        userPic: user.profilePicUrl,
                        userName: user.fullName,
                      ),
                    );
                  }, error: (error, stackTrace) {
                    return ErrorScreen(error: error.toString());
                  }, loading: () {
                    return const Loader();
                  });
                }),
          ),
        );
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Loader(),
        );
      },
    );
  }
}
