import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_study/services/notification_logic.dart';
import 'package:firebase_study/utils/app_colors.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/add_reminder.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/delete_reminder.dart';
import 'package:firebase_study/presentation/home_screen.dart/widgets/switcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  User? user;
  bool on = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
    listenNotifications();
  }

  void listenNotifications() {
    NotificationLogic.onNotifications.listen((value) {});
  }

  void onClickNotifications(String? payload) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen1()));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: AppColors.WhiteColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Reminder App",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(100)),
          onPressed: () async {
            addReminder(context, user!.uid);
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: AppColors.primaryG,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 2))
                ]),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(user!.uid)
                .collection('reminder')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4FABC5)),
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("Nothing to show"),
                );
              }
              final data = snapshot.data;
             return ListView.builder(
  itemCount: data?.docs.length ?? 0,
  itemBuilder: (context, index) {
    var doc = data?.docs[index];
    if (doc == null) return SizedBox.shrink();

    Timestamp t = doc.get('time');
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
    String formattedTime = DateFormat.jm().format(dateTime);
    bool on = doc.get('onOff');

    // Set up the notification if 'on' is true
    if (on) {
      NotificationLogic.showNotifications(
        dateTime: dateTime,
        id: index,  // Use index as unique ID for notifications
        title: "Reminder Title",
        body: "Don't forget to drink water",
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              child: ListTile(
                title: Text(
                  formattedTime,
                  style: TextStyle(fontSize: 30),
                ),
                subtitle: Text("Every day"),
                trailing: Container(
                  width: 110,
                  child: Row(
                    children: [
                      Switcher(
                        on,
                        user!.uid,
                        doc.id,
                        doc.get('time'),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteReminder(context, doc.id, user!.uid);
                        },
                        icon: FaIcon(FontAwesomeIcons.circleXmark),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  },
);

            }),
      ),
    );
  }
}
