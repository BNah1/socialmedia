import 'package:bona/core/widget/round_text_field.dart';
import 'package:bona/feature/auth/presentation/screen/create_account_screen.dart';
import 'package:bona/feature/auth/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}
  final _formkey = GlobalKey<FormState>();
  late  TextEditingController _emailController;
  late  TextEditingController _passwordController;

  bool isLoading = false;

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async{
    if(_formkey.currentState!.validate()){
      _formkey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await ref.read(authProvider).signIn(email: _emailController.text, password: _passwordController.text);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.apple,
                      size: 150,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // hi again
                    Text(
                      'Hi, again',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Welcome back , you\'ve been missed !!',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                
                    //Email textfield
                    RoundTextField(
                      controller: _emailController,
                      hintText: 'Input your email...',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 15),
                
                    // Password textfield
                    RoundTextField(
                      controller: _passwordController,
                      hintText: 'Input your password...',
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                      validator: validatePassword,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Register
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: (){ login();},
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlueAccent),
                          child: Center(
                            child: Text('Sign in'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member ? ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pushNamed(CreateAccountScreen.routeName);
                          },
                          child: Text(
                            'Register now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
