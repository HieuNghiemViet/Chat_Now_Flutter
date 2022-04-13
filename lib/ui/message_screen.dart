import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/controller.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({Key? key}) : super(key: key);

  final controller = Get.put(Controller());
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.receiver.value),
      ),
      body: chatMessage(),
    );
  }

  Widget chatMessage() {
    return Column(
      children: [

        Expanded(
          child: Container(
          )),
        Divider(),
        _buildComposer()],
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration.collapsed(
                hintText: 'Your message here...',
              ),
              onChanged: (value) {
                //_isComposing = value.isNotEmpty;
              },
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
