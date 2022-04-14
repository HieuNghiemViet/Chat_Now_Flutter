import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/controller.dart';
import '../model/message.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({Key? key}) : super(key: key);

  final controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {

    // for (var e in controller.list.reversed) {
    //   print("content ${e.content}");
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: chatMessage(),
    );
  }

  Widget chatMessage() {
    return Column(
      children: [
        Expanded(
            child: Obx(() => ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(8),
                  itemCount: controller.list.length,
                  itemBuilder: (context, index) {
                  final mess = controller.list[index];
                    return GestureDetector(
                      child: (mess.sender == 'hieunv@gmail.com') ? _itemChatSender(mess) : _itemChatReceiver(mess),
                      onLongPress: () {
                        controller.deleteMessage(mess.id);
                      },
                    );
                  }
              ),
            )
        ),
        Divider(),
        _buildComposer()],
    );
  }

  Widget _itemChatSender(Message message) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: Colors.grey[200],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
          child: Text(message.content.toString(), style: TextStyle(fontSize: 18, color: Color(0xff203152))),
    ));
  }

  Widget _itemChatReceiver(Message message) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: Color(0xff203152),
      ),
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(message.content.toString(), style: TextStyle(fontSize: 18, color: Colors.white))),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller.messageController,
              focusNode: controller.messageFocusNode,
              decoration: InputDecoration.collapsed(
                hintText: 'Your message here...',
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.writeMessage();
            },
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
