import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // My Status
          const ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
            title: Text(
              "My Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Today, 12:30 am"),
            trailing: Icon(Icons.more_vert),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Recent Updates",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          buildStatusTile(
            image: "assets/profile1.jpg",
            name: "Alex",
            time: "Today, 1:40",
          ),

          buildStatusTile(
            image: "assets/profile2.jpg",
            name: "Alex",
            time: "Today, 1:40",
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Viewed Updates",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          buildStatusTile(
            image: "assets/profile3.jpg",
            name: "Dear",
            time: "Yesterday, 10:40",
          ),

          buildStatusTile(
            image: "assets/profile4.jpg",
            name: "Dear",
            time: "Yesterday, 10:40",
          ),
        ],
      ),
    );
  }

  Widget buildStatusTile({
    required String image,
    required String name,
    required String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(image),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(time),
    );
  }
}