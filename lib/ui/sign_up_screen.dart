import 'package:chat_now/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  MessageController controllerSignUp = Get.put(MessageController());

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
          keyboardType: TextInputType.emailAddress,
          onChanged: (username) {
            controllerSignUp.email = username.obs;
          },
          decoration: InputDecoration(
              hintText: 'User name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 20),
        Obx(() => TextField(
            obscureText: controllerSignUp.isPasswordHidden.value,
            onChanged: (pass) {
              controllerSignUp.password = pass.obs;
            },
            decoration: InputDecoration(
                suffixIcon: customSuffixIcon(),
                hintText: 'Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          ),
        ),
        SizedBox(height: 20),
        Obx(() => TextField(
            obscureText: controllerSignUp.isPasswordConfirmHidden.value,
            onChanged: (passConfirm) {
              controllerSignUp.passwordConfirm = passConfirm.obs;
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(controllerSignUp.isPasswordConfirmHidden.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      controllerSignUp.isPasswordConfirmHidden.value = !controllerSignUp.isPasswordConfirmHidden.value;
                    }),
                hintText: 'Confirm Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          ),
        ),
      ],
    );
  }

  Widget customSuffixIcon() {
    return IconButton(
        icon: Icon(controllerSignUp.isPasswordHidden.value
            ? Icons.visibility
            : Icons.visibility_off),
        onPressed: () {
          controllerSignUp.isPasswordHidden.value =
              !controllerSignUp.isPasswordHidden.value;
        });
  }

  Widget btnSignUp(context) {
    Size size = Get.size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          onPressed: () async {
            final signUp = await controllerSignUp.signUp();
            if(signUp) {
              Get.offAllNamed('/home');
            } else {
              Get.snackbar('...', 'Nhap tai khoan voi mat khau de dang ki');
            }
          },
          child:
              Text('SIGN UP', style: TextStyle(color: Colors.deepPurpleAccent)),
          color: Colors.tealAccent,
        ),
      ),
    );
  }
}
