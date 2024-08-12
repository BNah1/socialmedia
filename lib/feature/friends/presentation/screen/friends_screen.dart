import 'package:bona/core/constants/app_colors.dart';
import 'package:bona/core/constants/constant.dart';
import 'package:bona/feature/friends/presentation/widget/friend_list.dart';
import 'package:bona/feature/friends/presentation/widget/request_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30.0,
      ),
      backgroundColor: AppColors.whiteColor,
      body: Padding(padding: Constants.defaultPadding,
      child: CustomScrollView(
        slivers: [
          //Request List
          SliverToBoxAdapter(
            child: Text('Request', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10,),
          ),
          RequestList(),
          SliverToBoxAdapter(child: Divider(height: 50, thickness: 1, color: AppColors.blackColor,)),
          //Friend List
          SliverToBoxAdapter(
            child: Text('Friend', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
          ),
          FriendList(),
        ],
      ),
      ),
    );
  }
}
