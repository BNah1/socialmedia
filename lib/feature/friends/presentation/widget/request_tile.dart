import 'package:bona/core/screens/profile_screen.dart';
import 'package:bona/core/widget/round_button.dart';
import 'package:bona/feature/auth/provider/get_user_info_provider.dart';
import 'package:bona/feature/friends/provider/friend_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/screens/error_screen.dart';
import '../../../../core/widget/loading.dart';

class RequestTile extends ConsumerWidget {
  const RequestTile({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(getUserInfoAsStreamByIdProvider(userId));
    return userData.when(
      data: (user) {
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed(ProfileScreen.routeName, arguments: userId);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicUrl),
                    radius: 40,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 15,),
                    Row(children: [
                      Expanded(child: RoundButton(onPressed: (){
                        ref.read(friendProvider).acceptFriendRequest(userId: userId);
                      }, label: 'Accept',height: 30,)),
                      SizedBox(width: 10,),
                      Expanded(child: RoundButton(onPressed: (){
                        ref.read(friendProvider).removeFriendRequest(userId: userId);
                      }, label: 'Reject',height: 30,)),
                    ],)
                  ],
                ))
          ],
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
