import 'package:chat_now/constant/string_constant.dart';
import 'package:chat_now/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController {
  final auth = FirebaseAuth.instance;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  var isPasswordHidden = true.obs;
  var isPasswordConfirmHidden = true.obs;
  var isSuccess = true.obs;

  var email = ''.obs;
  var password = ''.obs;
  var passwordConfirm = ''.obs;

  var content = ''.obs;
  var sender = ''.obs;
  var receiver = ''.obs;

  final message = Get.put(Message());

  void readMessage() {
    fireStore.collection(StringConstant.message).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        final data = result.data();
        print(data);
      });
    });
  }

  void writeMessage() {
    fireStore.collection(StringConstant.message).add({
      StringConstant.content: content,
      StringConstant.createTime: DateTime.now(),
      StringConstant.receiver: receiver,
      StringConstant.sender: sender,
    }).then((value) {
      print(value.id);
    });
  }

  void deleteMessage() {
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    fireStore.collection(StringConstant.message).doc(firebaseUser?.uid).delete().then((_) {
      print("success!");
    });
  }

  void updateMessageInDocument() {
  }

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
      if (password == passwordConfirm) {
        try {
          final result = await auth.createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());

          if (result.user == null) {
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
