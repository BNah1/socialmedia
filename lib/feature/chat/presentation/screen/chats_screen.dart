
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/widget/round_icon_button.dart';
import '../../../story/presentation/screen/create_story_screen.dart';
import '../widget/chat_list.dart';
import '../widget/profile_avater.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const routeName = '/chats-screen';

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 27.0,
      ),
      backgroundColor: AppColors.realWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: Constants.defaultPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // build chats app bar
                _buildChatsAppBar(),

                const SizedBox(height: 20),

                // Search widget
                _buildChatsSearchWidget(),

                const SizedBox(height: 30),

                // Chats List
                const SizedBox(
                  height: 600,
                  child: ChatsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatsAppBar() => Row(
    children: [
      const MyProfilePic(),
      const SizedBox(width: 5),
      const Text(
        'Chats',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Spacer(),
      RoundIconButton(
        icon: FontAwesomeIcons.camera,
        onPressed: () {
          Navigator.of(context).pushNamed(CreateStoryScreen.routeName);
        },
      )
    ],
  );

  Widget _buildChatsSearchWidget() => Container(
    decoration: BoxDecoration(
      color: AppColors.greyColor.withOpacity(.5),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 15),
        const Icon(Icons.search),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(),
            ),
          ),
        ),
      ],
    ),
  );
}