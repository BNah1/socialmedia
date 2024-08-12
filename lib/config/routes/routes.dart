import 'package:bona/feature/post/presentation/screen/comments_screen.dart';
import 'package:bona/feature/post/presentation/screen/create_post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/screens/home_screen.dart';
import '../../core/screens/profile_screen.dart';
import '../../core/screens/search_screen.dart';
import '../../feature/auth/presentation/screen/create_account_screen.dart';
import '../../feature/chat/presentation/screen/chat_screen.dart';
import '../../feature/chat/presentation/screen/chats_screen.dart';
import '../../feature/story/presentation/screen/create_story_screen.dart';
import '../../feature/story/presentation/screen/story_view_screen.dart';
import '../../model/story.dart';

class Routes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CreateAccountScreen.routeName:
        return _cupertinoRoute(
          const CreateAccountScreen(),
        );
      case HomeScreen.routeName:
        return _cupertinoRoute(
          const HomeScreen(),
        );
      case CreatePostScreen.routeName:
        return _cupertinoRoute(
          const CreatePostScreen(),
        );
      case SearchScreen.routeName:
        return _cupertinoRoute(
          const SearchScreen(),
        );
      case CommentsScreen.routeName:
        final postId = settings.arguments as String;
        return _cupertinoRoute(
          CommentsScreen(postId: postId),
        );
      case CreateStoryScreen.routeName:
        return _cupertinoRoute(
          CreateStoryScreen(),
        );
      case ProfileScreen.routeName:
        final userId = settings.arguments as String;
        return _cupertinoRoute(
          ProfileScreen(userId: userId),
        );
      case StoryViewScreen.routeName:
        final stories = settings.arguments as List<Story>;
        return _cupertinoRoute(
          StoryViewScreen(
            stories: stories,
          ),
        );
      case ChatScreen.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final userId = arguments['userId'] as String;
        return _cupertinoRoute(
          ChatScreen(
            userId: userId,
          ),
        );
      case ChatsScreen.routeName:
        return _cupertinoRoute(
          const ChatsScreen(),
        );
      default:
        return _cupertinoRoute(Scaffold(
          body: Center(
            child: Text(
              'Wrong Route provided ${settings.name}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
    }
  }

  static Route _cupertinoRoute(Widget view) => CupertinoPageRoute(
        builder: (_) => view,
      );

  Routes._();
}
