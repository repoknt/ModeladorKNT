import 'package:flutter/material.dart';
import 'package:knt_kitchen_app/auth/main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToMainPage();
  }

  void navigateToMainPage() async {
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          // Carga y muestra tu imagen personalizada
          child: Image.asset('assets/img/knt_Inicio.png',),
        ),
      ),
    );
  }
}
