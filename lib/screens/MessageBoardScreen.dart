import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Message.dart';


class MessageBoardScreen extends StatefulWidget {
  @override
  _MessageBoardScreenState createState() => _MessageBoardScreenState();
}

class _MessageBoardScreenState extends State<MessageBoardScreen> {
  final _contentController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        messages = responseData.map((data) => Message.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> _submitMessage() async {
    final content = _contentController.text;

    if (content.isEmpty) {
      return;
    }

    final newMessage = Message(
      id: messages.length + 1,
      user: "Current User",
      content: content,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.insert(0, newMessage); // 将新留言插入到列表顶部
    });

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/comments'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(newMessage.toJson()),
    );

    if (response.statusCode == 201) {
      _contentController.clear();
    } else {
      throw Exception('Failed to submit message');
    }
  }

  void _sortMessages(String sortType) {
    setState(() {
      if (sortType == "newest") {
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      } else {
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('留言板'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.sort),
            items: [
              DropdownMenuItem(
                child: Text("最新"),
                value: "newest",
              ),
              DropdownMenuItem(
                child: Text("最舊"),
                value: "oldest",
              ),
            ],
            onChanged: (value) {
              _sortMessages(value as String);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: "新增回應……",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _submitMessage();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitMessage,
                ),
              ],
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) {
                      String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(messages[index].timestamp);
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(messages[index].user),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(messages[index].content),
                            SizedBox(height: 4),
                            Text(
                              '講・$formattedDate',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
