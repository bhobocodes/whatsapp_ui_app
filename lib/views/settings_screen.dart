import 'package:flutter/material.dart';
import 'settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff075E54),
        title: const Text("Settings"),
      ),

      body: const Column(
        children: [

          // Profile Section
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),

            title: Text(
              "Programmer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            subtitle: Text(
              "Hey there, I am using whatsapp.",
            ),
          ),

          Divider(),

          // Account
          ListTile(
            leading: Icon(Icons.key),
            title: Text("Account"),
            subtitle: Text(
              "Privacy, security, change number",
            ),
          ),

          // Chats
          ListTile(
            leading: Icon(Icons.chat),
            title: Text("Chats"),
            subtitle: Text(
              "Theme, wallpapers, chat history",
            ),
          ),

          // Notification
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            subtitle: Text(
              "Message, group & call tones",
            ),
          ),

          // Storage
          ListTile(
            leading: Icon(Icons.circle_outlined),
            title: Text("Storage and Data"),
            subtitle: Text(
              "Network usage, auto-download",
            ),
          ),

          // Help
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Help"),
            subtitle: Text(
              "Help centre, contact us, privacy policy",
            ),
          ),

          // Invite
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Invite a Friend"),
          ),

          Spacer(),

          Text(
            "from",
            style: TextStyle(color: Colors.grey),
          ),

          Text(
            "Facebook",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}