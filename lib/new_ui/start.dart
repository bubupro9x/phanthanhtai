import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'home.dart';

class Start extends StatelessWidget {
  const Start({super. key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.main,
      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://media.discordapp.net/attachments/1008571191935639652/1086550580631179284/duymai_storehouse_with_number_12_5b448ff4-8217-4152-aa12-ffdbae6c582a.png?width=1498&height=1498')),

        ),
         child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Image.asset(
                  "assets/controller.png",
                  width: 250,
                  height: 250,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Become better at video\n games in a second!",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Roboto',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Center(
                  child: Text(
                    "Become a way better player with our mobile app! Never lose a game after our coaching from the best players in the world!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Roboto',
                        color: Palette.caption,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const Home())),
                  child: Image.asset(
                    'assets/custom-button.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  "10 million gamers rock with us!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Roboto',
                      color: Palette.caption,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
