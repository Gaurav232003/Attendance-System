import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'landnig.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  return runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xff171d49),
      appBarTheme: AppBarTheme(
        color: Color(0xff171d49),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Attendance System'),
      ),
      body: AuthGate(),
    ),
  ));
}

class Home extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? email = FirebaseAuth.instance.currentUser!.email;

  final String name = 'Gaurav';
  final String id = 'RA2111029010002';
  final String phone = '8017767683';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 100.0,
          ),
          Text(
            'Click on mark attendance to mark yourself present',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 50.0,
          ),
          Text(
            'Click on View to see previous attendance',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 50.0,
          ),
          Text(
            'Email: $email',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            height: 60.0,
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Mark Attendance?"),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 100.0,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff171d49))),
                                ),
                                Container(
                                  width: 100.0,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Attendance();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text('Attendance Marked!'),
                                                content: Container(
                                                  width: 100.0,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        FlutterFireUIAuth
                                                            .signOut(
                                                          context: context,
                                                          auth: auth,
                                                        );
                                                      },
                                                      child: Text('Ok'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xff171d49))),
                                                ),
                                              );
                                            });
                                      },
                                      child: Text('Yes'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff171d49))),
                                ),
                              ],
                            ));
                      });
                },
                child: Text(
                  'Mark Attendance',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff171d49))),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            height: 60.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddData(
                            email: email.toString(),
                          )),
                );
              },
              child: Text('View'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xff171d49)),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(height: 60.0, child: const SignOutButton()),
        ],
      ),
    );
  }
}

void Attendance() {
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime today = DateTime.now();
  String dateStr = "${today.year}-${today.month}-${today.day}";
  String timeStr = "${today.hour}:${today.minute}:${today.second}";
  String? email = FirebaseAuth.instance.currentUser!.email;
  String? ss = dateStr + "     " + timeStr;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference gd = FirebaseFirestore.instance.collection('Notes');
  _firestore.collection(email.toString()).add({'text': ss});
}

class AddData extends StatelessWidget {
  final String? email;
  AddData({required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff171d49),
        title: Text("$email"),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date                Time',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10.0,
            ),
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('$email')
                    .orderBy("text", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(),
                        child: Text(
                          document['text'],
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w700),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
