import 'package:bona/core/screens/home_screen.dart';
import 'package:bona/core/widget/round_button.dart';
import 'package:bona/feature/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/utils/utils.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(onPressed: () async{
             await ref.read(authProvider).verifyEmail().then((value) => {
               if(value == null){
                 showToastMessage(text: 'Email verification is sent !!')
               }
             });
            }, label: 'Verify Email'),
            SizedBox(height: 10,),
            RoundButton( onPressed: () async {
              await FirebaseAuth.instance.currentUser!.reload();
              final emailVerified =
                  FirebaseAuth.instance.currentUser?.emailVerified;
              if (emailVerified == true) {
                // Fix this later
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              }
              print('xxxx');
            }, label: 'Refresh'),
            SizedBox(height: 10,),
            RoundButton(onPressed: (){
              ref.read(authProvider).signOut();
            }, label: 'Change Email'),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
