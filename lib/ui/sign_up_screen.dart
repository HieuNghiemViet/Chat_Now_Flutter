import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN UP'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            editTextField(),
            SizedBox(height: 20),
            btnSignUp(context),
          ],
        ),
      ),
    );
  }

  Widget editTextField() {
    return Column(
      children: [
        TextField(
          onChanged: (value) {},
          decoration: InputDecoration(
              hintText: 'User name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
      ],
    );
  }

  Widget btnSignUp(context) {
    Size size = Get.size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          onPressed: () {
            Get.toNamed('/sign_up');
          },
          child: Text('SIGN UP', style: TextStyle(color: Colors.deepPurpleAccent)),
          color: Colors.tealAccent,
        ),
      ),
    );
  }
}
