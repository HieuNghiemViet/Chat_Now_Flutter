import 'package:chat_now/ui/home_screen.dart';
import 'package:chat_now/ui/message_screen.dart';
import 'package:chat_now/ui/sign_in_screen.dart';
import 'package:chat_now/ui/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/controller.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  final controller = Get.put(Controller());
  var email = await controller.getSharePreferences('email');
  print(email);

  //Test Function
   controller.readMessage();
   //controller.writeMessage();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: email == null ? '/' : '/message',
      getPages: [
        GetPage(name: '/', page: () => SignInScreen()),
        GetPage(name: '/sign_up', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/message', page: () => MessageScreen()),
      ],
    ),
  );
}
