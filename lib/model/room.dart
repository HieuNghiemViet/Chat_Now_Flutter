import 'package:chat_now/model/user.dart';

class Room {
  String? id;
  String? user1;
  String? user2;

  List<Users>? list;

  Room({this.list, this.id, this.user1, this.user2});

  factory Room.fromJson(Map<dynamic, dynamic> json, String id) => Room(
      user1: json['user'][0],
      user2: json['user'][1],
      id: id);

  Map<String, dynamic> toJson() => {
    "room_id": id,
    'user' : list
  };

}
