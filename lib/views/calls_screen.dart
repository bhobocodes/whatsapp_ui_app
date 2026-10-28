import 'package:flutter/material.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: ListView(
        children: [

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search name or number",
                hintStyle: const TextStyle(color: Colors.black ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),

                prefixIcon: const Icon(Icons.search,color: Colors.black),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Favourite
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Favourites",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.favorite,color: Colors.red),
            ),

            title: Text(
              "Add favourite",
              style: TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 10),

          // Recent
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Recent",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          callTile(
            name: "+880 1571-149607",
            type: "Outgoing",
            time: "10:23 am",
            image: "https://i.pravatar.cc/150?img=1",
          ),

          callTile(
            name: "+880 1635-214014",
            type: "Incoming",
            time: "2:21 pm",
            image: "https://i.pravatar.cc/150?img=2",
          ),
          callTile(
            name: "+880 1838-490345",
            type: "Outgoing",
            time: "3:21 pm",
            image: "https://i.pravatar.cc/150?img=2",
          ),
          callTile(
            name: "+880 1551-796636",
            type: "Incoming",
            time: "9:32 am",
            image: "https://i.pravatar.cc/150?img=2",
          ),
          callTile(
            name: "+880 1829-501374",
            type: "Missed call",
            time: "8:21 pm",
            image: "https://i.pravatar.cc/150?img=2",
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff00a884),
        onPressed: () {},
        child: const Icon(Icons.add_call),
      ),
    );
  }

  Widget callTile({
    required String name,
    required String type,
    required String time,
    required String image,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(image),
      ),

      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),

      subtitle: Row(
        children: [
          Icon(
            type == "Outgoing"
                ? Icons.call_made
                : Icons.call_received,
            color: Colors.grey,
            size: 18,
          ),

          const SizedBox(width: 5),

          Text(
            type,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),

      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}