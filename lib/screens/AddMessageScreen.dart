import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Message.dart';

class AddMessageScreen extends StatefulWidget {
  @override
  _AddMessageScreenState createState() => _AddMessageScreenState();
}

class _AddMessageScreenState extends State<AddMessageScreen> {
  final _userController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitMessage() async {
    final user = _userController.text;
    final content = _contentController.text;

    if (user.isEmpty || content.isEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final newMessage = Message(
      id: 0, // JSONPlaceholder 会自动生成ID
      user: user,
      content: content,
      timestamp: DateTime.now(),
    );

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/comments'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(newMessage.toJson()),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 201) {
      Navigator.of(context).pop(true);  // 返回主界面并刷新数据
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('提交失敗，請稍後再試')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增留言'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _userController,
              decoration: InputDecoration(labelText: '用戶名稱'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '留言內容'),
              keyboardType: TextInputType.multiline,
              maxLines: null,  // 允许多行输入
            ),
            SizedBox(height: 20),
            _isSubmitting
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitMessage,
                    child: Text('提交'),
                  ),
          ],
        ),
      ),
    );
  }
}
