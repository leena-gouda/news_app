import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/notification_model.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  Future<List<AppNotification>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList('notifications') ?? [];
    return stored.map((e) => AppNotification.fromJson(jsonDecode(e))).toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Notifications")),
      body: FutureBuilder<List<AppNotification>>(
        future: loadNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet 📭",
                style: TextStyle(fontSize: 18, color: Colors.grey,fontWeight: FontWeight.bold),
              ),
            );
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                title: Text(n.title),
                subtitle: Text(n.body),
                trailing: Text("${n.timestamp.hour}:${n.timestamp.minute}"),
              );
            },
          );
        },
      )
    );
  }
}
