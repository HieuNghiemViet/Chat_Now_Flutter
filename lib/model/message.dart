import 'package:chat_now/constant/string_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? content;
  Timestamp? createTime;
  String? sender;
  String? receiver;
  String id;

  Message({required this.id, this.content, this.createTime, this.sender, this.receiver});


  Map<String, dynamic> toJson() => {
  "content": content,
  "createTime": createTime,
  "sender": sender,
  "receiver": receiver,
  };

  factory Message.fromJson(Map<dynamic, dynamic> json, String id) => Message(
    content: json[StringConstant.content],
    createTime: json[StringConstant.createTime],
    sender: json[StringConstant.sender],
    receiver: json[StringConstant.receiver],
    id: id
  );


}
