import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  int currentLevel;
  int currentHintLevel1;
  int tokens;
  int coins;
  String? name;
  DateTime? duration;

  User(
      {this.currentLevel = 0,
      this.currentHintLevel1 = 0,
      this.coins = 0,
      this.tokens = 0,
      this.name,
      this.duration});

  factory User.fromJson(Map<String, dynamic> json) => User(
      currentLevel: json["current_level"] ?? 0,
      currentHintLevel1: json['current_hint_level_1'] ?? 0,
      tokens: json['tokens'] ?? 0,
      coins: json['coins'] ?? 0,
      name: json['name'],
      duration: json['duration'] != null
          ? (json['duration'] as Timestamp).toDate()
          : null);

  Map<String, dynamic> toJson() {
    return {
      'current_level': currentLevel,
      'current_hint_level_1': currentHintLevel1,
      'coins': coins,
      'tokens': tokens,
      'name': name
    };
  }
}
