import 'package:chat_now/constant/string_constant.dart';
import 'package:chat_now/controller/share_prefer.dart';
import 'package:chat_now/ui/home_screen.dart';
import 'package:chat_now/ui/message_screen.dart';
import 'package:chat_now/ui/sign_in_screen.dart';
import 'package:chat_now/ui/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var email = await SharePreferencesHelper.getSharePreferences(StringConstant.email);
  print(email);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: email == null ? StringConstant.signInScreen : StringConstant.homeScreen,
      getPages: [
        GetPage(name: StringConstant.signInScreen, page: () => SignInScreen()),
        GetPage(name: StringConstant.signUpScreen, page: () => SignUpScreen()),
        GetPage(name: StringConstant.homeScreen, page: () => HomeScreen()),
        GetPage(name: StringConstant.messageScreen, page: () => MessageScreen()),
      ],
    ),
  );
}
