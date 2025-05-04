import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message
  Future<void> sendMessage(String chatId, String sender, String receiver, String message) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get messages in real-time
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore.collection('chats').doc(chatId).collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
