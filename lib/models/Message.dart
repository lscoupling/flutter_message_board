class Message {
  final int id;
  final String user;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamp,
  });

  // 从JSON解析Message对象
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      user: json['name'],  // 假设JSONPlaceholder返回name作为用户名
      content: json['body'],
      timestamp: DateTime.now(), // JSONPlaceholder不提供时间，使用当前时间
    );
  }

  // 将Message对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': user,
      'body': content,
    };
  }
}
