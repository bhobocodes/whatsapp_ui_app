
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final String name;
  final String image;

  const MessageScreen({super.key, required this.name, required this.image});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Map> chatDetails = [
    {'message': 'Hello', 'isMe': true, 'time': '07:00 PM'},
    {'message': 'Hi', 'isMe': false, 'time': '07:01 PM'},
    {'message': 'How are you?', 'isMe': true, 'time': '07:02 PM'},
    {'message': 'I am fine', 'isMe': false, 'time': '07:03 PM'},
    {'message': 'what are you doing now?', 'isMe': true, 'time': '07:04 PM'},
    {'message': 'Chatting with you ', 'isMe': false, 'time': '07:05 PM'},
    {'message': 'oh, are eating something?', 'isMe': true, 'time': '07:06 PM'},
    {'message': 'No, i am on the way', 'isMe': false, 'time': '07:07 PM'},
    {'message': 'where are you go on the way?', 'isMe': true, 'time': '07:08 PM'},
    {'message': ' end of office then i go to my home ', 'isMe': false, 'time': '07:09 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E55),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Expanded (
          child : ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundImage: NetworkImage(widget.image)),
          title: Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Last seen 07:00 PM',
            style:   TextStyle(color: Colors.white.withOpacity(.5)),
          ),
          trailing: const Icon(Icons.more_vert, color: Colors.white),
        ),
       ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: chatDetails.length,
              itemBuilder: (context, index) {
                final data = chatDetails[index];
                return Column(
                  crossAxisAlignment: data['isMe'] == true
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      constraints: const BoxConstraints(maxWidth: 200), // Adjust width dynamically
                      decoration: BoxDecoration(
                        color: data['isMe'] == true ? Colors.black : const Color(0xFF075E55),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          // bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: data['isMe'] == true
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['message'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 5), // Space between message and time
                          Text(
                            data['time'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding : const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: TextField(
                        decoration:InputDecoration(
                          prefixIcon: Icon(Icons.emoji_emotions_outlined),
                          suffixIcon: Icon(Icons.link),
                          hintText :'Enter your message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                const CircleAvatar(
                  backgroundColor: Color(0xFF075E55),
                  child: Icon(Icons.send, color: Colors.white,),
                )
              ],

            ),
          )
        ],
      ),
    );
  }
}
