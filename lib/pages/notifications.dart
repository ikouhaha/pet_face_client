import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/notification.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/router/route_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late FirebaseDatabase database;
  late DatabaseReference notificationsListRef;
  UserModel? profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = FirebaseDatabase.instanceFor(
        app: FirebaseDatabase.instance.app, databaseURL: Config.firebaseRDBUrl);
    profile = SharedPreferencesService.getProfile();
    if (profile?.role == "staff") {
      notificationsListRef = database
          .ref()
          .child("notifications")
          .child(profile?.companyCode.toString() ?? "");
    } else if (profile?.role == "user") {
      notificationsListRef = database
          .ref()
          .child("notifications")
          .child(profile?.id.toString() ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      RouteStateScope.of(context).go("/signin");
      return Container();
    }

    void clearAll() async {
      await notificationsListRef.remove();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          actions: [
            TextButton(
                onPressed: clearAll,
                child: Text("Clear all", style: TextStyle(color: Colors.white)))
          ],
        ),
        body: 
         Container(
          padding: EdgeInsets.only(top:10),
          child:
         StreamBuilder(
          stream: notificationsListRef.onValue,
          builder: (context, snapshot) {
            var emptyNotification = const Center(
              child: Text("No messages"),
            );

            if (snapshot.hasError) {
              print(snapshot.error);
              return emptyNotification;
            }
            if (snapshot.hasData) {
               var data = snapshot.data;
               if(data==null){
                return emptyNotification;
               }

              var value = (data as DatabaseEvent).snapshot;

              List<Notifications> notificationsList = [];
              for (final child in value.children) {
                // Handle the post.
                if (child.value != null) {
                  var notification =
                      Notifications.fromJson(Helper.objectToJson(child.value!));

                  notificationsList.add(notification);
                }
              }

                return ListView.builder(
                  itemCount: notificationsList.length,
                  itemBuilder: (context, idx) {
                    var notification = notificationsList[idx];

                    if (notification.type == "comment") {
                      Comment comment =
                          Comment.fromJson(json.decode(notification.jsonValue!));
                      var title = (comment.commentBy ?? '') +
                          ' ▪ ' +
                          Helper.getTimeAgo(Helper.stringToDate(
                              dateString: comment.commentDate!));
                      var subtitle = (comment.comment ?? '');
                      Widget? trailing = null;

                      return Container(
                          padding: EdgeInsets.only(left:10,right: 10),
                          child: Card(
                              child: ListTile(
                            onTap: () async {
                              await notificationsListRef.child(notification.key!).remove();
                              RouteStateScope.of(context).go("/post/${comment.postId}");
                              
                            },
                            
                            title: Text(title, style: TextStyle(fontSize: 12)),
                            isThreeLine: true,
                            subtitle: Text(subtitle),
                            leading: comment.avatar == null
                                ? Icon(Icons.person)
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(comment.avatar!)),
                            enableFeedback: true,
                            trailing: trailing,
                          )));
                    }

                    return emptyNotification;
                  },
                );
              
            }

            return emptyNotification;
          },
        )));
  }
}
