import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Tasks tasksFromJson(String str) => Tasks.fromJson(json.decode(str));

String tasksToJson(Tasks data) => json.encode(data.toJson());

class Tasks {
  Tasks(
      {required this.hint3,
      required this.pass,
      required this.hint1,
      required this.hint2,
      required this.bv,
      required this.poster,
      required this.ott,
      required this.name,
      this.lock = true,
      this.level = -1,
      this.duration});

  String hint3;
  String pass;
  String hint1;
  String hint2;
  String bv;
  String poster;
  String ott;
  String name;
  bool lock;
  int level;
  DateTime? duration;

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
      hint3: json["hint_3"],
      pass: json["pass"],
      hint1: json["hint_1"],
      hint2: json["hint_2"],
      bv: json["BV"],
      poster: json["poster"],
      ott: json["OTT"],
      name: json["name"],
      lock: json['lock'],
      duration: json['duration'] != null
          ? (json['duration'] as Timestamp).toDate()
          : null);

  Map<String, dynamic> toJson() => {
        "hint_3": hint3,
        "pass": pass,
        "hint_1": hint1,
        "hint_2": hint2,
        "BV": bv,
        "poster": poster,
        "OTT": ott,
        "name": name,
        "lock": lock,
        "duration": Timestamp.fromDate(duration!)
      };
}
