import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knt_kitchen_app/paginas/modelador_royal.dart';
import 'package:knt_kitchen_app/paginas/modelador_vitrex.dart';

//final FirebaseAuth auth = FirebaseAuth.instance;
//User? users = auth.currentUser;

class PaginaInicio extends StatefulWidget {
  //final VoidCallback showModeladorRoyal;
  const PaginaInicio({Key? key}) : super(key: key);

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  final user = FirebaseAuth.instance.currentUser!;

//String? nombre = users?.displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 10,
          title: Center(
              child: Text(
            user.email!,
          )),
          leading: Image.asset(
            'assets/img/knt.png',
            width: 200.0,
            height: 200.0,
          ),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Hola otra vez
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Bienvenido ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Selecciona al proveedor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                SizedBox(
                  height: 50,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModeladorRoyal()));
                  },
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(110.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/royal.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModeladorVitrex()));
                  },
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(110.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/vitrex.png',
                        width: 200.0,
                        height: 200.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
