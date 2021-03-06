import 'package:chat_now/controller/home_controller.dart';
import 'package:chat_now/controller/share_prefer.dart';
import 'package:chat_now/model/room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/string_constant.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          TextButton(
            onPressed: () {
              SharePreferencesHelper.removeSharePreferences(
                  StringConstant.email);
              Get.offNamed(StringConstant.signInScreen);
            },
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: listRoom(),
    );
  }

  Widget listRoom() {
    return Obx(
      () => ListView.builder(
        itemCount: homeController.listRoom.length,
        itemBuilder: (context, index) {
          final room = homeController.listRoom[index];
          return _itemRoom(room);
        },
      ),
    );
  }

  Widget _itemRoom(Room room) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(top: 10, bottom: 2, left: 10, right: 10),
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(homeController.getFriendName(room)),
        onTap: () {
          Get.toNamed(StringConstant.messageScreen, arguments: room);
        },
      ),
    );
  }
}
