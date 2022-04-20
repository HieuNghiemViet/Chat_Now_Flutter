import 'package:chat_now/controller/share_prefer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constant/string_constant.dart';
import '../model/room.dart';

class HomeController extends GetxController {

  HomeController() {
    readRoom();
  }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var listRoom = <Room>[].obs;
  var myEmail = "";

  void readRoom() async {
    await getMyEmail();
    print("myemail $myEmail");
    final roomCollection = fireStore.collection(StringConstant.room);
    final querySnapShot = await roomCollection.where('user', arrayContains: myEmail).get();
    final room = querySnapShot.docs.map((e) => Room.fromJson(e.data(), e.id)).toList();
    listRoom.assignAll(room);
  }

  Future<void> getMyEmail() async {
    myEmail = await SharePreferencesHelper.getSharePreferences(StringConstant.email) ?? "";
    print("email $myEmail");
  }

  String getFriendName(Room room)  {
    return (room.user1 != myEmail ? room.user1 : room.user2) ?? "";
  }
}