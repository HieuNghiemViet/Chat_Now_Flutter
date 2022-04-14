import 'package:chat_now/constant/string_constant.dart';
import 'package:chat_now/controller/sharePrefer.dart';
import 'package:chat_now/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  final auth = FirebaseAuth.instance;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();

  var isPasswordHidden = true.obs;
  var isPasswordConfirmHidden = true.obs;
  var isSuccess = true.obs;

  var email = ''.obs;
  var password = ''.obs;
  var passwordConfirm = ''.obs;

  var content = ''.obs;
  var sender = ''.obs;
  var receiver = ''.obs;
  var createTime = ''.obs;

  var list = <Message>[].obs;

  MessageController() {
    readMessage();
   subscribe();
  }

  void readMessage() async {
    final querySnapShot =
        await fireStore.collection(StringConstant.message).get();
    final messages =
        querySnapShot.docs.map((e) => Message.fromJson(e.data(), e.id)).toList();
    messages.sort((e1, e2) =>
        e2.createTime?.compareTo(e1.createTime ?? Timestamp.now()) ?? 0);

    list.assignAll(messages);
    // list.reversed;
    print(list);



    for (var e in list) {
      // print("content ${e.createTime?.toDate().toString()}");
      // print("content con ${e.content}");
    }
  }

  void subscribe() {
    final stream = fireStore.collection(StringConstant.message).snapshots();
    stream.listen((event) {
      final messageEvent = event.docs.map((e) => Message.fromJson(e.data(), e.id)).toList();
      print("count ${event.docs.length}");
      messageEvent.sort((e1, e2) =>
      e2.createTime?.compareTo(e1.createTime ?? Timestamp.now()) ?? 0);

      list.assignAll(messageEvent);
      // list.add()
      // list.reversed;
    });
  }

  void writeMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }

    final sender = await SharePreferencesHelper.getSharePreferences('email');

    fireStore.collection(StringConstant.message).add({
      StringConstant.content: messageController.text,
      StringConstant.createTime: DateTime.now(),
      StringConstant.receiver: 'HungTD',
      StringConstant.sender: sender,
    }).then((value) {
      print('HieunV: ${value.id}');
    });

    messageController.clear();
  }

  void deleteMessage(String id) {
    fireStore.collection(StringConstant.message).doc(id)
        .delete()
        .then((value){
    });
  }

  void updateMessageInDocument() {}
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
      SharePreferencesHelper.setSharePreferences('email', email.value);
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
}
