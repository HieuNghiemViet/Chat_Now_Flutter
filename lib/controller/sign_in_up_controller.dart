import 'package:chat_now/controller/share_prefer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../constant/string_constant.dart';

class SignInUpController extends GetxController {
  final auth = FirebaseAuth.instance;

  var email = ''.obs;
  var password = ''.obs;
  var passwordConfirm = ''.obs;

  var isPasswordHidden = true.obs;
  var isPasswordConfirmHidden = true.obs;
  var isSuccess = true.obs;


  Future<bool> signIn() async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    } else {
      try {
        final userCred = await auth.signInWithEmailAndPassword(
            email: email.toString(), password: password.toString());

        if (userCred.user == null) {
          return false;
        }
      } catch (_) {
        return false;
      }
      SharePreferencesHelper.setSharePreferences(
          StringConstant.email, email.value);
      return true;
    }
  }

  Future<bool> signUp() async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    } else {
      if (password == passwordConfirm) {
        try {
          final result = await auth.createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());

          if (result.user == null) {
            return false;
          }
          SharePreferencesHelper.setSharePreferences(
              StringConstant.email, email.value);
          return true;
        } catch (_) {
          return false;
        }
      }
      return false;
    }
  }
}