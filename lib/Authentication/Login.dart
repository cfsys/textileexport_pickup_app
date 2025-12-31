
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Library/ApiData.dart';
import '../Library/AppStorage.dart';
import '../Library/AppTextStyle.dart';
import '../Library/MyNavigator.dart';
import '../Library/Utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.isCompany});

  final bool? isCompany;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> loginFromKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isHiddenPassword = true;

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  getAccessCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      var data = {};
      data["userid"] = userName.text;
      data["upassword"] = password.text;
      final res = await ApiData().postData('get_login',data);
      if (res['st'] == 'success') {
        print(res);
        Navigator.pop(context);
        AppStorage.setData("token",(res['user']['ucode']??"").toString());
        AppStorage.setData("aaid",(res['user']['utoken']??"").toString());
        AppStorage.setData("ucode",(res['user']['ucode']??"").toString());
        AppStorage.setData("uid",(res['user']['id']??"").toString());
        AppStorage.setData("is_verify",(res['user']['is_verify']??"").toString());
        MyNavigator().goToDashBoard(context);
      } else {
        Utils().showSnack(
          context: context,
          msg: res['msg'] ?? "Something went wrong!",
          snackType: SnackType.error,
        );
      }
    } catch (e) {
      print('print error: $e');
      Utils().showSnack(
        context: context,
        msg: "Catch Error!",
        snackType: SnackType.error,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body:  SingleChildScrollView(
            child: Form(
              key: loginFromKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: Get.height * 0.4,
                      ),
                    ),
                    Row(
                      children: [
                        Text("Login",style: AppTextStyle.headlineVeryVeryLarge),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: userName,
                      style: AppTextStyle.inputText,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return 'Please enter user name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        userName.text = value.toString();
                      },
                      decoration: Utils().inputFormDecoration('User Name'),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: password,
                      style: AppTextStyle.inputText,
                      obscureText: isHiddenPassword,
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) {},
                      decoration: Utils().inputFormDecoration("Password").copyWith(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHiddenPassword = !isHiddenPassword;
                            });
                          },
                          child: Icon(isHiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password ';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30.0),
                    Utils().primaryButton(
                        width: Get.width / 1.4,
                        context: context,
                        isLoading: isLoading,
                        buttonType: ButtonType.large,
                        btnText: 'Login',
                        onPress: (){
                          final form = loginFromKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            getAccessCode();
                          }
                        }
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
