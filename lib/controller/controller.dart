import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController {
  final auth = FirebaseAuth.instance;

  var isPasswordHidden = true.obs;
  var isPasswordConfirmHidden = true.obs;
  var isSuccess = true.obs;

  var email = ''.obs;
  var password = ''.obs;
  var passwordConfirm = ''.obs;

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
      setSharePreferences('email', email.value);
      return true;
    }
  }

  Future<bool> signUp() async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    } else {
      print(passwordConfirm);
      if(password == passwordConfirm) {
        try {
         final result = await auth.createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());

         if(result.user == null) {
           return false;
         }
          return true;
        } catch (_) {
          return false;
        }
      }
      return false;
    }
  }


  void setSharePreferences(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getSharePreferences(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void removeSharePreferences(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    prefs.clear();
  }
}
