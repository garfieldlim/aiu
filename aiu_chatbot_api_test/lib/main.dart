import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIU Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();

  Future<String> sendMessage(String message, String name) async {
    final response = await http.post(
      Uri.parse('http://localhost:5001/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'name': name}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to load chatbot response');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIU Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String message = messageController.text;
                    messageController.clear();
                    setState(() {
                      messages.add("User: $message");
                    });

                    String response = await sendMessage(message, "JerJer");
                    setState(() {
                      messages.add("AIU: $response");
                    });
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
