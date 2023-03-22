import 'package:cipher/items/fire_store.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../model/tasks_model.dart';
import '../model/user.dart';
import 'constants.dart';

class Detail extends StatefulWidget {
  final Tasks task;

  const Detail({super.key, required this.task});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            StreamBuilder<User>(
                stream: FireStore().userStream,
                builder: (context, user) {
                  if (user.hasData &&
                      user.data!.currentLevel >= widget.task.level) {
                    return const SizedBox();
                  }
                  return Row(
                    children: [
                      Text(
                        user.data?.tokens.toString() ?? '-',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont('Roboto',
                            color: Colors.blueAccent.shade400,
                            fontSize: 24,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/10/Ethereum-Logo-PNG-HD-Image.png',
                        height: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 1,
                        height: 10,
                        color: Colors.grey.shade300,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                int tokensNeed =
                                    user.data?.currentHintLevel1 == 0
                                        ? 5
                                        : user.data?.currentHintLevel1 == 1
                                            ? 10
                                            : user.data?.currentHintLevel1 == 2
                                                ? 15
                                                : 9999;
                                return AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: Text(
                                    tokensNeed > user.data!.tokens
                                        ? "Token của bạn không đủ!"
                                        : 'Bạn có muốn đổi $tokensNeed token lấy gợi ý không?',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Đóng'),
                                    ),
                                    if (tokensNeed <= user.data!.tokens)
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (user.data!.tokens >= tokensNeed) {
                                            FireStore().getHint(
                                                level: widget.task.level,
                                                tokensNeed: tokensNeed);
                                          }

                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Có'),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.lightbulb_outline_sharp,
                            color: Colors.yellow.shade800,
                            size: 36,
                          )),
                    ],
                  );
                }),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<User>(
                  stream: FireStore().userStream,
                  builder: (context, user) {
                    if (user.hasData &&
                        user.data!.currentLevel >= widget.task.level) {
                      return const SizedBox();
                    }
                    return SlideCountdown(
                      onDone: () async {
                        await done();
                        FireStore().sendPassSuccess(
                            level: widget.task.level.toString(),
                            isCorrect: false);
                      },
                      duration: Duration(milliseconds: times),
                      decoration: const BoxDecoration(color: Colors.black),
                    );
                  }),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: DecorationImage(
                      image: NetworkImage(widget.task.poster),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
              Text(
                widget.task.ott,
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Roboto',
                    color: Palette.extra,
                    fontSize: 27,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                widget.task.bv,
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Montserrat',
                    color: Colors.grey,
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 40,
              ),
              times < 0
                  ? const SizedBox()
                  : StreamBuilder<User>(
                      stream: FireStore().userStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.currentLevel >= widget.task.level) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: _pass,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Palette.extra,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                            decoration: const InputDecoration(
                              hintText: "Password",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Palette.accent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Palette.accent),
                              ),
                            ),
                          ),
                        );
                      }),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 20,
              ),
              if (times >= 0)
                StreamBuilder<User>(
                    stream: FireStore().userStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data!.currentLevel >= widget.task.level) {
                        return Text(
                          'Nhiệm vụ hoàn thành',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.green.shade600,
                              fontSize: 28,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          if (widget.task.pass
                                  .replaceAll(' ', '')
                                  .toUpperCase()
                                  .trim() ==
                              _pass.text
                                  .toUpperCase()
                                  .replaceAll(' ', '')
                                  .trim()) {
                            FireStore().sendPassSuccess(
                                level: widget.task.level.toString(),
                                isCorrect: true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mật khẩu đúng'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mật khẩu sai'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: size.width * 0.70,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Palette.accent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Text(
                            'Submit',
                            style: GoogleFonts.getFont('Roboto',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      );
                    }),
              StreamBuilder<User>(
                  stream: FireStore().userStream!,
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) {
                      return const SizedBox();
                    }

                    return Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Gợi ý',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont('Montserrat',
                              color: Colors.red,
                              fontSize: 20,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              if (snapshot.data!.currentHintLevel1 <= index) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  index == 0
                                      ? 'Gợi ý 1: ${widget.task.hint1}'
                                      : index == 1
                                          ? 'Gợi ý 2: ${widget.task.hint2}'
                                          : 'Gợi ý 3: ${widget.task.hint3}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: Colors.grey,
                                      fontSize: 16,
                                      letterSpacing: 1.4,
                                      height: 2,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                            itemCount: 3,
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                        )
                      ],
                    );
                  })
            ],
          ),
        ));
  }

  int get times => widget.task.duration!
      .subtract(Duration(milliseconds: DateTime.now().millisecondsSinceEpoch))
      .millisecondsSinceEpoch;

  final TextEditingController _pass = TextEditingController();

  Future<void> done() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text(
            'Đã hết thời gian làm nhiệm vụ.',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Oke'),
            ),
          ],
        );
      },
    );
  }
}
