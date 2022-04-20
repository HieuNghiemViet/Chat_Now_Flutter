import 'dart:io';
import 'dart:math';
import 'package:chat_now/constant/string_constant.dart';
import 'package:chat_now/controller/home_controller.dart';
import 'package:chat_now/controller/share_prefer.dart';
import 'package:chat_now/model/message.dart';
import 'package:chat_now/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MessageController extends GetxController {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();
  late File _image;

  final textFieldMessageController = TextEditingController();
  final messageFocusNode = FocusNode();

  var list = <Message>[].obs;

  late Room _room;

  MessageController(Room room) {
    _room = room;
    //readMessage();
  }

  Future<void> pickAnImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    _image = File(image?.path ?? '');
    printInfo(info: _image.toString());
    final path = uploadFile();
    print('HieuNV: $path');
    writeMessage(file: _image);
  }


  Future<String?> uploadFile() async {
    if(_image != null) {
      print("image File ${_image.path}");
      Reference reference = _storage.ref(getRandom(10));
      try {
        await reference.putFile(_image);
        return await reference.getDownloadURL();
      } catch(e) {
        print(e);
      }
    }
    return null;
  }

  Future<XFile?> pickAnVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    return video;
  }

  Future<List<XFile>?> pickMultipleImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    return images;
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


  void writeMessage({String? content, File? file}) async {
    var mesContent = "";
    var contentType = 0; //0: text - 1: image

    if(content != null) {
      mesContent = content;
    }

    if(file != null) {
      final resultUpFile = await uploadFile();
      mesContent = resultUpFile ?? "";
      contentType = 1;
    }

    var receiver = HomeController().getFriendName(_room);
    final sender =
        await SharePreferencesHelper.getSharePreferences(StringConstant.email);

    fireStore.collection(StringConstant.message).add({
      StringConstant.content: mesContent,
      StringConstant.contentType: contentType,
      StringConstant.createTime: DateTime.now(),
      StringConstant.receiver: receiver,
      StringConstant.sender: sender,
      StringConstant.roomId: _room.id,
    }).then((value) {});
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

  String getRandom(int length){
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random r = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }
}
