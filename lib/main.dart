import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in.dart';
import 'first_screen.dart';
import 'Inicio.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MyApp());
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(size: 150),
                SizedBox(height: 50,),
                _signinButton(),
              ],
            ),
          )
      ),
    );
  }

  _signinButton(){
    return OutlinedButton(
      onPressed: () {
        signWithGoogle().then((user){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return inicio();
          }));
        });
      },
      style: OutlinedButton.styleFrom(
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 0,
        side: BorderSide(width: 1, color: Colors.grey),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/google_logo.png'), height: 35.0,),
          Padding(padding: const EdgeInsets.only(left: 10),
            child: Text("Sign in with Google",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,

                )),)
        ],
      ),
    );
  }
  /*
  _signinButton2() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/google_logo.png'), height: 35.0,),
          Padding(padding: const EdgeInsets.only(left: 10),
            child: Text("Sign in with Google",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,

                )),)
        ],
      ),
    );
  }*/
}