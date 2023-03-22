import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'items/fire_store.dart';
import 'new_ui/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
            image: NetworkImage(
                'https://media.discordapp.net/attachments/1008571191935639652/1086550580631179284/duymai_storehouse_with_number_12_5b448ff4-8217-4152-aa12-ffdbae6c582a.png?width=1498&height=1498')),
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.pink],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 100),
          const Text(
            'Welcome Back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 50),
          TextFormField(
            keyboardType: TextInputType.text,
            onFieldSubmitted: (value) async {
              if (uidValid.contains(value)) {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('uid', value);
                await FireStore().init();

                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MyApp()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sai mã code'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Code',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    ));
  }
}

List<String> uidValid = ['PTT01X', 'duymai', 'PTT02X'];
