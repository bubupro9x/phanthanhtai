import 'package:cipher/items/fire_store.dart';
import 'package:cipher/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  int currentLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            children: [
              Text(
                "Bảng xếp hạng",
                style: GoogleFonts.getFont('Roboto',
                    color: Palette.extra,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(child: SizedBox()),
              IconButton(onPressed: (){
                if (currentLevel == 0) {
                  FireStore().getAllUsers();
                } else {
                  FireStore().leaderBoard(level: currentLevel);
                }
                setState(() {});
              }, icon: const Icon(Icons.refresh)),

              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Edit user'),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (value) {},
                                    controller: _codeCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Code',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Đóng'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await FireStore()
                                      .createUser(code: _codeCtrl.text.trim());
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Oke'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 55,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return index != currentLevel
                  ? ElevatedButton(
                      onPressed: () {
                        currentLevel = index;
                        if (index == 0) {
                          FireStore().getAllUsers();
                        } else {
                          FireStore().leaderBoard(level: index);
                        }
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.transparent,
                          )),
                      child: Text(
                        index == 0 ? 'AlL' : index.toString(),
                        style: TextStyle(
                          color: index == 0 ? Palette.accent : Colors.grey,
                        ),
                      ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              currentLevel = index;
                              if (index == 0) {
                                FireStore().getAllUsers();
                              } else {
                                FireStore().leaderBoard(level: index);
                              }
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Colors.transparent,
                                )),
                            child: Text(
                              index == 0 ? 'AlL' : index.toString(),
                              style: TextStyle(
                                color:
                                    index == 0 ? Palette.accent : Colors.grey,
                              ),
                            )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Container(
                              width: 5,
                              height: 5,
                              color: Palette.extra,
                            ))
                      ],
                    );
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        StreamBuilder<List<User>>(
            stream: FireStore().leaderBoardStream,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Container();
              }
              final List<User> users = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      users[index].name ?? '-',
                      style: GoogleFonts.getFont('Roboto',
                          color: Palette.extra,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      currentLevel == 0
                          ? 'Coins: ${users[index].coins} | Tokens: ${users[index].tokens} | Level: ${users[index].currentLevel}'
                          : 'Duration: ${users[index].duration}',
                      style: GoogleFonts.getFont('Roboto',
                          color: Palette.extra,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              _coinCtrl.text = users[index].coins.toString();
                              _tokenCtrl.text = users[index].tokens.toString();
                              _levelCtrl.text =
                                  users[index].currentLevel.toString();

                              return AlertDialog(
                                title: const Text('Edit user'),
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      TextField(
                                        onChanged: (value) {},
                                        controller: _coinCtrl,
                                        decoration: const InputDecoration(
                                          labelText: 'Coin',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {},
                                        controller: _tokenCtrl,
                                        decoration: const InputDecoration(
                                          labelText: 'Token',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {},
                                        controller: _levelCtrl,
                                        decoration: const InputDecoration(
                                          labelText: 'Level',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Đóng'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final _temp = users[index];
                                      _temp.currentLevel =
                                          int.parse(_levelCtrl.text);
                                      _temp.coins = int.parse(_coinCtrl.text);
                                      _temp.tokens = int.parse(_tokenCtrl.text);

                                      await FireStore().updateUser(user: _temp);
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Oke'),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  );
                },
                itemCount: users.length,
              );
            }),
        const SizedBox(height: 100,)
      ],
    );
  }

  final TextEditingController _coinCtrl = TextEditingController();
  final TextEditingController _tokenCtrl = TextEditingController();
  final TextEditingController _levelCtrl = TextEditingController();
  final TextEditingController _codeCtrl = TextEditingController();
}
