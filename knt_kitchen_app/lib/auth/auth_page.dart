 import 'package:flutter/material.dart';
import 'package:knt_kitchen_app/paginas/login.dart';
import 'package:knt_kitchen_app/paginas/registro_usuario.dart';



 class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  
  
  // intially, show the login page
  bool showLoginPage = true;

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });

  }
  @override
  Widget build(BuildContext context) {

if (showLoginPage) {
  return Login(showRegisterPage: toggleScreens);
}else{
  return  RegistroUsuario(showLoginPage: toggleScreens);
}


  }
}
