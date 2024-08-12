import 'package:bona/core/constants/app_colors.dart';
import 'package:bona/core/constants/constant.dart';
import 'package:bona/core/screens/error_screen.dart';
import 'package:bona/core/widget/loading.dart';
import 'package:bona/core/widget/round_button.dart';
import 'package:bona/feature/auth/provider/get_user_info_provider.dart';
import 'package:bona/feature/story/presentation/screen/create_story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/chat/presentation/screen/chat_screen.dart';
import '../../feature/friends/presentation/widget/add_friend_button.dart';
import '../../feature/post/presentation/widget/create_post_widget.dart';
import '../../feature/post/presentation/widget/post_tile.dart';
import '../../feature/post/provider/get_all_post_byid_provider.dart';
import '../widget/text_button_icon.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.userId});

  final String? userId;
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final uid = userId ?? myUid;
    final userInfo = ref.watch(getUserInfoAsStreamByIdProvider(uid));
    return userInfo.when(
      data: (user) {
        String gender = user.gender;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 30.0,
            ),
            backgroundColor: AppColors.whiteColor,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.profilePicUrl),
                      ),
                      Text(
                        user.fullName,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),

                      // button
                      userId == myUid ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: RoundButton(onPressed: () {
                            Navigator.of(context).pushNamed(CreateStoryScreen.routeName);
                          }, label: 'Add Story')) : AddFriendButton(user: user,),

                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: RoundButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              ChatScreen.routeName,
                              arguments: {
                                'userId': userId,
                              },
                            );
                          },
                          label: 'Send Message',
                          color: Colors.transparent,
                        ),
                      ),
                      // Infomation
                      SizedBox(height: 10),
                      IconTextButton(
                        icon: gender == 'male' ? Icons.male : Icons.female,
                        label: gender,
                      ),
                      const SizedBox(height: 10),
                      IconTextButton(
                        icon: Icons.cake,
                        label: user.birthDay.yMMMEd(),
                      ),
                      const SizedBox(height: 10),
                      IconTextButton(
                        icon: Icons.email,
                        label: user.email,
                      ),
                      SizedBox(height: 10),
                      Container(height: 2,color: AppColors.greyColor,),
                    ],
                  ),
                ),
                 if (uid == myUid ) FeedMakePostWidget(),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(height: 2,color: AppColors.greyColor,),
                      PostList(userId: userId!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return Loader();
      },
    );
  }

  _StoryButton() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: RoundButton(onPressed: () {}, label: 'Add Story'));
  }
}

class PostList extends ConsumerWidget {
  const PostList({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(getAllPostsByIdProvider(userId));
    return posts.when(
      data: (postList) {
        if (postList.isEmpty) {
          return Center(child: Text('No posts available.'));
        }
        return Column(
          children: postList.map((post) {
            return Column(
              children: [
                PostTile(post: post),
                Container(height: 8,color: AppColors.greyColor,),
              ],
            );
          }).toList(),
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return Loader();
      },
    );
  }
}
