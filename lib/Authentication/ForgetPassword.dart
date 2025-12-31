
import 'package:flutter/material.dart';
import 'package:textile_exporter_admin/Library/MyNavigator.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Library/ApiData.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  forgotPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      var data = {};
      data['uemail'] = emailController.text.trim();
      var res = await ApiData().postData('reset_password', data);
      if (res['st'] == 'success') {
        Utils().showSnack(context: context, msg: res["msg"] ?? "", snackType: SnackType.success);
        MyNavigator().goToDashBoard(context);
      } else {
        if (!mounted) return;
        Utils().showSnack(context: context, msg: res["msg"] ?? "", snackType: SnackType.error);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('ERROR :- $e');
      Utils().showSnack(context: context, msg: "Internal Catch Error", snackType: SnackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0,),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Image.asset('assets/images/pw_change.png',height: Get.height*0.5),
              ),
            ),
            // const SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Reset Password",style: AppTextStyle.headlineVeryVeryLarge.copyWith(fontSize: 20),),
            ),
            const SizedBox(height: 20.0,),
            Form(
              key: forgotFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Email",style: AppTextStyle.labelLarge),

                    TextFormField(
                      style: AppTextStyle.displayMedium,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val){
                        String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        if(val.toString().trim().isEmpty){
                          return 'Please enter email';
                        }else if(!RegExp(p).hasMatch((val??""))){
                          return "Please enter valid email.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: AppTextStyle.inputText,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.white_90,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            // color: Get.theme.primaryColor,
                              color: AppColors.white_90,
                              width: 1.8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.white_90,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: AppColors.white_90,
                        filled: true,

                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.email),
                            const SizedBox(
                              height: 45.0,
                              child: VerticalDivider(
                                color: AppColors.black,
                                indent: 10,
                                endIndent: 10,
                                thickness: 1,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Utils().primaryButton(
                        btnColor: AppColors.primaryColor,
                        context: context,
                        buttonType: ButtonType.large,
                        width: MediaQuery.of(context).size.width*0.9,
                        btnText: "Submit",
                        isLoading: isLoading,
                        onPress: () {
                          final form = forgotFormKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            forgotPassword();
                          }
                        }
                    ),
                    const SizedBox(height: 100),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
