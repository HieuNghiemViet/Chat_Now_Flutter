import 'package:chat_now/constant/string_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String? content;
  Timestamp? createTime;
  String? sender;
  String? receiver;
  String? roomID;

  Message(
      {required this.id,
      this.content,
      this.createTime,
      this.sender,
      this.receiver,
      this.roomID});

  Map<String, dynamic> toJson() => {
        "content": content,
        "createTime": createTime,
        "sender": sender,
        "receiver": receiver,
        "room_id": roomID
      };

  factory Message.fromJson(Map<dynamic, dynamic> json, String id) => Message(
      id: id,
      content: json[StringConstant.content],
      createTime: json[StringConstant.createTime],
      sender: json[StringConstant.sender],
      receiver: json[StringConstant.receiver],
      roomID: json[StringConstant.roomId]);
}
