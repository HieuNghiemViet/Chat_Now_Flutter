import 'package:chat_now/controller/controller.dart';
import 'package:chat_now/controller/sharePrefer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          actions: [
            TextButton(
              onPressed: () {
                SharePreferencesHelper.removeSharePreferences('email');
                Get.offNamed('/');
                print('logout');
              },
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        body: listChatNow());
  }

  Widget listChatNow() {
    return ListView.builder(
      itemCount: 40,
      itemBuilder: (context, index) {
        return _itemChatNow();
      },
    );
  }

  Widget _itemChatNow() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(top: 10, bottom: 2, left: 10, right: 10),
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text('HieuNV'),
        subtitle: Text('Hello Dart & Flutter'),
        onTap: () => {print('click')},
      ),
    );
  }
}
