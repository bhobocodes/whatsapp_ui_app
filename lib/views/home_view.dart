import 'package:flutter/material.dart';
import 'package:practise_project/views/calls_screen.dart';
import 'package:practise_project/views/settings_screen.dart';
import 'package:practise_project/views/status_screen.dart';
import 'package:practise_project/views/camera_screen.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> chatList = [
    {
      'name': 'Bhobotosh',
      'image': 'https://images.unsplash.com/photo-1683',
      'last_msg': 'Hello, how are you',
      'time': '07:00 PM',
      'count': 0,
    },
    {
      'name': 'Sanjoy',
      'image': 'https://images.unsplash.com/photo-1683',
      'last_msg': 'I am very fine',
      'time': '06:51 PM',
      'count': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF075E55),
          title: const Text(
            'Whatsapp',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // search click action
              },
              icon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white.withOpacity(.7),
              ),

              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text("Settings"),
                  ),
                ];
              },

              onSelected: (value) {
                if (value == 'settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                }
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white.withOpacity(.5),
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(icon: Icon(Icons.camera_alt_rounded)),
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            // CAMERA
            const CameraScreen(),

            // CHATS
            ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatList[index]['name']),
                );
              },
            ),

            // STATUS
            const StatusScreen(),

            // CALLS
            const CallsScreen(),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF075E55),
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}