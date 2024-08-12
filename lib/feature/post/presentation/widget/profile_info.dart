import 'package:bona/core/widget/loading.dart';
import 'package:bona/feature/auth/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.read(authProvider).getUserInfo(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Loader();
          }
          if(snapshot.hasData){
            final user = snapshot.data;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user!.profilePicUrl),
                ),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user.fullName,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                    Text('Public',style: TextStyle(fontSize: 12,color: Colors.grey)),
                  ],
                )
              ],
            );
          }
          return Loader();
        });
  }
}
