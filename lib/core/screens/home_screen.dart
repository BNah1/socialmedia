
import 'package:bona/core/screens/profile_screen.dart';
import 'package:bona/core/screens/search_screen.dart';
import 'package:bona/core/screens/setting_screen.dart';
import 'package:bona/feature/chat/presentation/screen/chats_screen.dart';
import 'package:bona/feature/friends/presentation/screen/friends_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../feature/post/presentation/screen/post_screen.dart';
import '../../feature/post/presentation/screen/video_screen.dart';
import '../constants/app_colors.dart';
import '../constants/constant.dart';
import '../widget/round_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.greyColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: _buildFacebookText(),
          actions: [
            _buildSearchWidget(),
            _buildMessengerWidget(),
          ],
          bottom: TabBar(
            tabs: Constants.getHomeScreenTabs(_tabController.index),
            controller: _tabController,
            onTap: (index) {
              setState(() {});
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PostScreen(),
            FriendsScreen(),
            VideoScreen(),
            ProfileScreen(userId: FirebaseAuth.instance.currentUser!.uid,),
            SettingScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookText() => const Text(
    'Zola App',
    style: TextStyle(
      color: AppColors.blueColor,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildSearchWidget() =>  RoundIconButton(
    onPressed: (){
      Navigator.of(context).pushNamed(SearchScreen.routeName);
    },
    icon: FontAwesomeIcons.magnifyingGlass,
  );

  Widget _buildMessengerWidget() => InkWell(
    onTap: () {
      Navigator.of(context).pushNamed(ChatsScreen.routeName);
    },
    child: const RoundIconButton(
      icon: FontAwesomeIcons.facebookMessenger,
    ),
  );
}