import 'dart:io';
import 'package:bona/core/constants/constant.dart';
import 'package:bona/core/widget/pick_image.dart';
import 'package:bona/core/widget/round_text_field.dart';
import 'package:bona/feature/auth/presentation/widget/birthday_picker.dart';
import 'package:bona/feature/auth/presentation/widget/gender_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widget/round_button.dart';
import '../../provider/auth_provider.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  static const routeName = '/create';

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

final _formkey = GlobalKey<FormState>();

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  File? image;
  DateTime? birthday;
  String gender = 'male';
  bool isLoading = false;
  //Controller
  late  TextEditingController _fNameController;
  late  TextEditingController _lnameController;
  late  TextEditingController _emailController;
  late  TextEditingController _passwordController;

  @override
  void initState() {
    _fNameController = TextEditingController();
    _lnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
    void dispose() {
    _fNameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    }

    Future<void> createAccount() async {
      if(_formkey.currentState!.validate()){
        _formkey.currentState!.save();

        setState(() {
          isLoading = true;
        });

        await ref
            .read(authProvider)
            .createAccount(
          fullName: '${_fNameController.text} ${_lnameController.text}',
          birthday: birthday ?? DateTime.now(),
          gender: gender,
          email: _emailController.text,
          password: _passwordController.text,
          image: image,
        )
            .then((credential) {
          if (!credential!.user!.emailVerified) {
            Navigator.pop(context);
          }
        }).catchError((_) {
          setState(() => isLoading = false);
        });
        setState(() => isLoading = false);
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: Constants.defaultPadding,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                InkWell(
                    onTap: () async {
                      image = await pickImage();
                      setState(() {});
                    },
                    child: PickImageWidget(image: image)),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Expanded(
                    child: RoundTextField(
                      controller: _fNameController,
                      hintText: 'First name',
                      textInputAction: TextInputAction.next,
                      validator: validateName,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: RoundTextField(
                      controller: _lnameController,
                      hintText: 'Last name',
                      textInputAction: TextInputAction.next,
                      validator: validateName,
                    ),
                  )
                ]),
                SizedBox(height: 20,),
                BirthdayPicker(dateTime: birthday ?? DateTime.now(), onPressed: () async{
                  birthday = await pickSimpleDate(context: context, date: birthday);
                  setState(() {
                  });
                }),
                SizedBox(height: 20,),
                GenderPicker(gender: gender, onChanged: (value){
                  gender = value ?? 'male';
                  setState(() {
                  });
                }),
                // Phone number / email text field
                RoundTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                const SizedBox(height: 20),
                // Password Text Field
                RoundTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  validator: validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                isLoading ? Center(child: CircularProgressIndicator(),) :
                RoundButton(
                  onPressed: (){
                    createAccount();
                  },
                  label: 'Create Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
