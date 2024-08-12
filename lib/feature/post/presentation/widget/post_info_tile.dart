import 'package:bona/core/constants/constant.dart';
import 'package:bona/core/screens/error_screen.dart';
import 'package:bona/core/screens/profile_screen.dart';
import 'package:bona/core/widget/loading.dart';
import 'package:bona/feature/auth/provider/get_user_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostInfoTile extends ConsumerWidget {
  const PostInfoTile(
      {Key? key, required this.datePublished, required this.userId})
      : super(key: key);

  final DateTime datePublished;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));
    return userInfo.when(data: (user) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(ProfileScreen.routeName, arguments: userId);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicUrl),
                  ),
                  SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(datePublished.fromNow().toString(),style: TextStyle(fontSize: 12,color: Colors.blueGrey),)
                    ],),
                ],
              ),
            ),
          ],
        ),
      );
    }, error: (error, stackTrace) {
      return ErrorScreen(
        error: error.toString(),
      );
    }, loading: () {
      return Loader();
    });
  }
}
