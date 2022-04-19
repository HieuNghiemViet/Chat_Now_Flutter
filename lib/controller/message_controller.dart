import 'package:chat_now/constant/string_constant.dart';
import 'package:chat_now/controller/share_prefer.dart';
import 'package:chat_now/model/message.dart';
import 'package:chat_now/model/room.dart';
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

  var list = <Message>[].obs;
  var listRoom = <Room>[].obs;

  var myEmail = "";

  MessageController() {
    readMessage();
    readRoom();
     //subscribe();
     //filterMessageByRoomId();
  }

  Future<void> getMyEmail() async {
    myEmail =
        await SharePreferencesHelper.getSharePreferences(StringConstant.email) ?? "";
    print("email $myEmail");
  }

  void readMessage() async {
    final querySnapShot =
        await fireStore.collection(StringConstant.message).get();
    final messages = querySnapShot.docs
        .map((e) => Message.fromJson(e.data(), e.id))
        .toList();

    messages.sort((e1, e2) =>
        e2.createTime?.compareTo(e1.createTime ?? Timestamp.now()) ?? 0);

    list.assignAll(messages);
  }

  void readRoom() async {
    await getMyEmail();
    print("myemail $myEmail");
    final roomCollection = fireStore.collection(StringConstant.room);
    final querySnapShot = await roomCollection
        .where('user', arrayContains: myEmail)
        .get();
    final room = querySnapShot.docs.map((e) => Room.fromJson(e.data(), e.id)).toList();
    listRoom.assignAll(room);
  }

  void filterMessageByRoomId(String roomId) async {
    list.clear();
    final noticeCollection = fireStore.collection(StringConstant.message);
    final querySnapShot = await noticeCollection
        .where('room_id', isEqualTo: roomId)
        .get();
    print('roomId $roomId');
    final messages = querySnapShot.docs
        .map((e) => Message.fromJson(e.data(), e.id))
        .toList();
    messages.sort((e1, e2) => e2.createTime?.compareTo(e1.createTime ?? Timestamp.now()) ?? 0);

    list.assignAll(messages);
  }

  void writeMessage(String roomId, String receiver) async {
    if (messageController.text.isEmpty) {
      return;
    }
    final sender =
        await SharePreferencesHelper.getSharePreferences(StringConstant.email);

    fireStore.collection(StringConstant.message).add({
      StringConstant.content: messageController.text,
      StringConstant.createTime: DateTime.now(),
      StringConstant.receiver: receiver,
      StringConstant.sender: sender,
      StringConstant.roomId: roomId
    }).then((value) {});

    messageController.clear();
  }

  void subscribe(String roomId) {
    final stream = fireStore.collection(StringConstant.message).snapshots();
    stream.listen((event) {
      final messageEvent =
          event.docs.map((e) => Message.fromJson(e.data(), e.id)).toList();
      messageEvent
          .removeWhere((element) => element.roomID != roomId);
      messageEvent.sort((e1, e2) =>
          e2.createTime?.compareTo(e1.createTime ?? Timestamp.now()) ?? 0);

      list.assignAll(messageEvent);
    });
  }



  void deleteMessage(String id) {
    fireStore
        .collection(StringConstant.message)
        .doc(id)
        .delete()
        .then((value) {});
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

  String getFriendName(Room room)  {
    // final name =  (room.user1 != myEmail ? room.user1 : room.user2);
    // print("name $name");

    return (room.user1 != myEmail ? room.user1 : room.user2) ?? "";
  }

}
