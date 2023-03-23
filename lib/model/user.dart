import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  int currentLevel;
  int currentHintLevel1;
  int currentHintLevel2;
  int currentHintLevel3;
  int currentHintLevel4;
  int currentHintLevel5;

  int tokens;
  int coins;
  String? name;
  DateTime? duration;

  User(
      {this.currentLevel = 0,
      this.currentHintLevel1 = 0,
      this.currentHintLevel2 = 0,
      this.currentHintLevel3 = 0,
      this.currentHintLevel4 = 0,
      this.currentHintLevel5 = 0,
      this.coins = 0,
      this.tokens = 0,
      this.name,
      this.duration});

  factory User.fromJson(Map<String, dynamic> json) => User(
      currentLevel: json["current_level"] ?? 0,
      currentHintLevel1: json['current_hint_level_1'] ?? 0,
      currentHintLevel2: json['current_hint_level_2'] ?? 0,
      currentHintLevel3: json['current_hint_level_3'] ?? 0,
      currentHintLevel4: json['current_hint_level_4'] ?? 0,
      currentHintLevel5: json['current_hint_level_5'] ?? 0,
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
      'current_hint_level_2': currentHintLevel2,
      'current_hint_level_3': currentHintLevel3,
      'current_hint_level_4': currentHintLevel4,
      'current_hint_level_5': currentHintLevel5,
      'coins': coins,
      'tokens': tokens,
      'name': name
    };
  }
}
