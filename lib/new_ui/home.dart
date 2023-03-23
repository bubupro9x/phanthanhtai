import 'package:cipher/items/fire_store.dart';
import 'package:cipher/model/user.dart';
import 'package:cipher/new_ui/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../login.dart';
import '../model/tasks_model.dart';
import '../qr_page.dart';
import 'detail.dart';
import 'leader_board_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Palette.bg,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                StreamBuilder<User>(
                    stream: FireStore().userStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                "assets/profile.jpg",
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              snapshot.data?.coins.toString() ?? '-',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont('Roboto',
                                  color: Colors.yellow.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/d/d6/Gold_coin_icon.png',
                              width: 20,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 1,
                              height: 10,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data?.tokens.toString() ?? '-',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont('Roboto',
                                  color: Colors.blueAccent.shade400,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/10/Ethereum-Logo-PNG-HD-Image.png',
                              height: 25,
                            ),
                            const Expanded(child: SizedBox()),
                            if (kDebugMode)
                              GestureDetector(
                                onTap: () {
                                  FireStore().logout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()),
                                  );
                                },
                                child: const Icon(
                                  Icons.exit_to_app_rounded,
                                  color: Colors.black54,
                                  size: 40,
                                ),
                              ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Chào người chơi, ${FireStore().getUid}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Roboto',
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    "Chào mừng \nđến với thử thách của Alpha!",
                    style: GoogleFonts.getFont('Roboto',
                        color: Palette.extra,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    'Nhiệm vụ',
                    style: GoogleFonts.getFont('Roboto',
                        color: Palette.extra,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<List<Tasks>>(
                    stream: FireStore().taskStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SizedBox(
                        height: 290,
                        width: size.width,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Tasks task = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                if (isAdmin) {
                                  showOpenTaskPopup(task: task);
                                } else {
                                  if (task.lock == false) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Detail(
                                                task: task,
                                              )),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  image: DecorationImage(
                                    image: NetworkImage(task.poster),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: task.level > task.level
                                        ? Colors.black.withOpacity(0.9)
                                        : task.lock
                                            ? Colors.black.withOpacity(0.6)
                                            : Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.name,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.getFont('Roboto',
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        task.lock
                                            ? 'Chưa mở khóa'
                                            : 'Đã mở khóa',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.getFont('Roboto',
                                            color: Palette.caption,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                const SizedBox(
                  height: 40,
                ),
                if (isAdmin == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(
                      "Mã người chơi",
                      style: GoogleFonts.getFont('Roboto',
                          color: Palette.extra,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                if (isAdmin == false)
                  Center(
                    child: QrImage(
                      data: FireStore().getUid!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                if (isAdmin)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(
                      "QrCode",
                      style: GoogleFonts.getFont('Roboto',
                          color: Palette.extra,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                if (isAdmin)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 16,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanQrCodeView()));
                              if (result != null) {
                                FireStore().scanQRCode(
                                    id: result, tokens: 0, coins: 200);
                              }
                            },
                            child: const Text('Nhất mật thư')),
                        ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanQrCodeView()));
                              if (result != null) {
                                FireStore().scanQRCode(
                                    id: result, tokens: 0, coins: 160);
                              }
                            },
                            child: const Text('Nhì mật thư')),
                        ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanQrCodeView()));
                              if (result != null) {
                                FireStore().scanQRCode(
                                    id: result, tokens: 0, coins: 140);
                              }
                            },
                            child: const Text('Ba mật thư')),
                        ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanQrCodeView()));
                              if (result != null) {
                                FireStore().scanQRCode(
                                    id: result, tokens: 0, coins: 120);
                              }
                            },
                            child: const Text('Tư mật thư')),
                        ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanQrCodeView()));
                              if (result != null) {
                                FireStore().scanQRCode(
                                    id: result, tokens: 0, coins: 80);
                              }
                            },
                            child: const Text('Còn lại mật thư')),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore().scanQRCode(
                                  id: result, tokens: 0, coins: 100);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Nhất truyền tin'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore()
                                  .scanQRCode(id: result, tokens: 0, coins: 80);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Nhì truyền tin'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore()
                                  .scanQRCode(id: result, tokens: 0, coins: 70);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Ba truyền tin'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore()
                                  .scanQRCode(id: result, tokens: 0, coins: 60);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Tư truyền tin'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore()
                                  .scanQRCode(id: result, tokens: 0, coins: 40);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Còn lại truyền tin'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore().scanQRCode(
                                  id: result, tokens: 10, coins: 0);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Thắng TCN'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScanQrCodeView()));
                            if (result != null) {
                              FireStore().scanQRCode(
                                  id: result, tokens: 7, coins: 0);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.transparent,
                              )),
                          child: const Text('Thua TCN'),
                        ),
                      ],
                    ),
                  ),
                if (isAdmin == true) const LeaderBoardPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showOpenTaskPopup({required Tasks task}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.lock == true ? 'Mở nhiệm vụ' : 'Đóng nhiệm vụ'),
          content: Text(
            'Bạn có muốn ${task.lock == true ? 'Mở nhiệm vụ' : 'Đóng nhiệm vụ'} ${task.level} không?',
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (task.lock) {
                  await FireStore().openNewTask(level: task.level);
                } else {
                  await FireStore().closeCurrentTask(level: task.level);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );
  }
}
