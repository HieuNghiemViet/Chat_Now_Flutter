import 'dart:io';
import 'package:chat_now/controller/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/message_controller.dart';
import '../model/message.dart';
import '../model/room.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  late MessageController messageController;
  Room _room = Get.arguments;
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    messageController = Get.put(MessageController(_room));
    messageController.subscribe(_room.id.toString());
    messageController.filterMessageByRoomId(_room.id.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homeController.getFriendName(_room)),
      ),
      body: chatMessage(),
    );
  }

  Widget chatMessage() {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8),
              itemCount: messageController.list.length,
              itemBuilder: (context, index) {
                final mess = messageController.list[index];
                return GestureDetector(
                  child: (mess.sender != homeController.getFriendName(_room)) ? _itemChatSender(mess) : _itemChatReceiver(mess),
                  onLongPress: () {
                    messageController.deleteMessage(mess.id);
                  },
                );
              },
            ),
          ),
        ),
        Divider(),
        _buildComposer()
      ],
    );
  }

  Widget _itemChatSender(Message message) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(message.content.toString(),
                  style: TextStyle(fontSize: 18, color: Color(0xff203152))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChatReceiver(Message message) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xff203152),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(message.content.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white))),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: ()  {
              messageController.pickAnImage();
            },
            icon: Icon(Icons.image, color: Colors.blue),
          ),
          Expanded(
            child: TextField(
              controller: messageController.textFieldMessageController,
              focusNode: messageController.messageFocusNode,
              decoration: InputDecoration.collapsed(
                hintText: 'Your message here...',
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              messageController.writeMessage(content: messageController.textFieldMessageController.text);
            },
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
