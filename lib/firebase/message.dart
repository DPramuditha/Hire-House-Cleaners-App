import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String receiver;
  String text;
  DateTime timestamp;

  Message({
    required this.sender,
    required this.receiver,
    required this.text,
    required this.timestamp,
  });

  // Convert Firestore document to Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert Message object to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
