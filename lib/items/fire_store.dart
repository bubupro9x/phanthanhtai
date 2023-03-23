import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/tasks_model.dart';
import '../model/user.dart';
import '../new_ui/constants.dart';

class FireStore {
  static final FireStore _singleton = FireStore._internal();

  factory FireStore() {
    return _singleton;
  }

  late SharedPreferences prefs;

  FireStore._internal();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final taskStream = BehaviorSubject<List<Tasks>>();

  StreamSubscription? _subLevel;
  StreamSubscription? _subUsers;

  var userStream = BehaviorSubject<User>();

  var leaderBoardStream = BehaviorSubject<List<User>>();

  User _user = User();

  init() async {
    prefs = await SharedPreferences.getInstance();

    userStream = BehaviorSubject<User>();

    leaderBoardStream = BehaviorSubject<List<User>>();

    if (getUid != null) {
      _subLevel = firestore.collection('tasks').snapshots().listen((event) {
        getTasks();
      });

      final result = await firestore.collection('users').doc(getUid).get();
      _user = User.fromJson(result.data() ?? User().toJson());
      userStream.add(_user);

      _subUsers =
          firestore.collection('users').doc(getUid).snapshots().listen((event) {
        _user = User.fromJson(event.data()!);
        userStream.add(_user);
      });
    }
    if (isAdmin) {
      getAllUsers();
    }
  }

  String? get getUid => prefs.getString('uid');

  List<Tasks> listTask = [];

  Future<void> getTasks() async {
    listTask.clear();
    final tasks = await firestore.collection('tasks').get();
    for (var e in tasks.docs) {
      Tasks t = Tasks.fromJson(e.data());
      t.level = int.parse(e.id);
      listTask.add(t);
    }
    taskStream.add(listTask);
  }

  Future<void> openNewTask({required int level}) async {
    listTask[level - 1]
      ..lock = false
      ..duration = DateTime.now().add(timeSolve);

    firestore
        .collection('tasks')
        .doc(level.toString())
        .set(listTask[level - 1].toJson());
  }

  void logout() {
    prefs.remove('uid');
    _subLevel?.cancel();
    _subUsers?.cancel();
    userStream.close();
    leaderBoardStream.close();
  }

  Future<void> closeCurrentTask({required int level}) async {
    listTask[level - 1].lock = true;

    firestore
        .collection('tasks')
        .doc(level.toString())
        .set(listTask[level - 1].toJson());
  }

  void sendPassSuccess({required String level, required bool isCorrect}) async {
    await firestore.collection(level).doc(getUid).set(_user.toJson()
      ..addAll({
        'level': int.parse(level),
        'duration': DateTime.now(),
        'correct': isCorrect
      }));
    _user.currentLevel = int.parse(level);
    await firestore.collection('users').doc(getUid).set(_user.toJson());
  }

  void getHint({required int level, required int tokensNeed}) async {
    if (level == 1) {
      if (_user.currentHintLevel1 == 3) return;

      _user.currentHintLevel1++;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
      _user.tokens -= tokensNeed;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
    }

    if (level == 2) {
      if (_user.currentHintLevel2 == 3) return;

      _user.currentHintLevel2++;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
      _user.tokens -= tokensNeed;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
    }

    if (level == 3) {
      if (_user.currentHintLevel3 == 3) return;

      _user.currentHintLevel3++;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
      _user.tokens -= tokensNeed;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
    }

    if (level == 4) {
      if (_user.currentHintLevel4 == 3) return;

      _user.currentHintLevel4++;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
      _user.tokens -= tokensNeed;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
    }

    if (level == 5) {
      if (_user.currentHintLevel5 == 3) return;

      _user.currentHintLevel5++;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
      _user.tokens -= tokensNeed;
      await firestore.collection('users').doc(getUid).set(_user.toJson());
    }
  }

  Future<void> getAllUsers() async {
    List<User> users = [];
    final result = await firestore
        .collection('users')
        .orderBy('coins', descending: true)
        .get();
    for (var element in result.docs) {
      final temp = User.fromJson(element.data());
      users.add(temp);
    }
    leaderBoardStream.add(users);
  }

  Future<void> updateUser({required User user}) async {
    await firestore.collection('users').doc(user.name).set(user.toJson());
  }

  Future<void> createUser({required String code}) async {
    await firestore.collection('users').doc(code).set(User().toJson());
  }

  Future<void> leaderBoard({required int level}) async {
    List<User> users = [];
    final result = await firestore
        .collection((level).toString())
        .orderBy('duration')
        .get();
    for (var element in result.docs) {
      final temp = User.fromJson(element.data());
      users.add(temp);
    }
    leaderBoardStream.add(users);
  }

  Future<void> scanQRCode(
      {required int tokens, required int coins, required id}) async {
    final result = await firestore.collection('users').doc(id).get();
    final temp = User.fromJson(result.data()!);
    temp.coins = temp.coins + coins;
    temp.tokens = temp.tokens + tokens;
    await firestore.collection('users').doc(id).set(temp.toJson());
  }
}
