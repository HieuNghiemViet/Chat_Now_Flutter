import 'package:chat_now/constant/string_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/sign_in_up_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  SignInUpController controllerSignIn = Get.put(SignInUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN IN'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            editTextField(),
            SizedBox(height: 20),
            btnSignIn(context),
            SizedBox(height: 10),
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
          onChanged: (id) {
            controllerSignIn.email = id.trim().obs;
          },
          decoration: InputDecoration(
              hintText: StringConstant.userName,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 20),
        Obx(
          () => TextField(
            onChanged: (pass) {
              controllerSignIn.password = pass.trim().obs;
            },
            obscureText: controllerSignIn.isPasswordHidden.value,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(controllerSignIn.isPasswordHidden.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      controllerSignIn.isPasswordHidden.value =
                          !controllerSignIn.isPasswordHidden.value;
                    }),
                hintText: StringConstant.passWord,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
      ],
    );
  }

  Widget btnSignIn(context) {
    Size size = Get.size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          onPressed: () async {
            final login = await controllerSignIn.signIn();
            if (login) {
              Get.offAllNamed(StringConstant.homeScreen);
            } else {
              Get.snackbar('Error', 'Nhap lai tai khoan voi mat khau');
            }
          },
          child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
          color: Colors.deepPurpleAccent,
        ),
      ),
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
              Get.toNamed(StringConstant.signUpScreen);
            },
            child: Text('SIGN UP',
                style: TextStyle(color: Colors.deepPurpleAccent)),
            color: Colors.tealAccent),
      ),
    );
  }
}
