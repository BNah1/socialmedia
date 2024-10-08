import 'package:bona/feature/auth/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Center(
      child:
      TextButton(onPressed: (){
        ref.read(authProvider).signOut();
      }, child: Text('log out'))
      ,
    );
  }
}
