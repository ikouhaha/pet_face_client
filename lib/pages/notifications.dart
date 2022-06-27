import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/router/route_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {


  @override
  Widget build(BuildContext context) {
     if (FirebaseAuth.instance.currentUser == null) {
      RouteStateScope.of(context).go("/signin");
      return Container();
    }
    
     return Scaffold(
      appBar: AppBar(
        title: Text("book!.title"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "book!.title",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "book!.author.name",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          
          ],
        ),
      ),
    );
  
  }
}