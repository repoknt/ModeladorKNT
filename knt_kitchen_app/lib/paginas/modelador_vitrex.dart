import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 final user = FirebaseAuth.instance.currentUser!;
//final FirebaseAuth auth = FirebaseAuth.instance;
//User? users = auth.currentUser;
class ModeladorVitrex extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(

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
                  'Modelador Vitrex ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
               
              ],
            ),
          ),
        )






  ); 
    
}






//String? nombre = users?.displayName;

