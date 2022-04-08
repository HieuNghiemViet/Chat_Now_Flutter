import 'package:chat_now/ui/sign_in_screen.dart';
import 'package:chat_now/ui/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SignInScreen()),
        GetPage(name: '/sign_up', page: () => SignUpScreen())
      ],
  ));
}
