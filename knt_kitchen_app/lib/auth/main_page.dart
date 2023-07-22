import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knt_kitchen_app/auth/auth_page.dart';
import 'package:knt_kitchen_app/paginas/pagina_inicio.dart';
import '../paginas/login.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
     if(snapshot.hasData){
        return PaginaInicio();
     }else{
      return AuthPage();
     }
        },
      ),
    );
  }
}
