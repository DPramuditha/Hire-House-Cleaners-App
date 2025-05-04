import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_cleaners_app/firebase/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Send Message
  Future<void> sendMessage(String sender, String receiver, String text) async {
    String chatId = _getChatId(sender, receiver);
    CollectionReference messagesRef = _firestore.collection('chats').doc(chatId).collection('messages');

    Message newMessage = Message(
      sender: sender,
      receiver: receiver,
      text: text,
      timestamp: DateTime.now(),
    );

    await messagesRef.add(newMessage.toJson());
  }

  // 🔹 Stream Messages (Real-Time Updates)
  Stream<List<Message>> getMessages(String sender, String receiver) {
    String chatId = _getChatId(sender, receiver);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  // 🔹 Generate Unique Chat ID (Customer + Cleaner Emails)
  String _getChatId(String user1, String user2) {
    List<String> emails = [user1, user2]..sort();
    return emails.join("_");
  }




  //  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // // Send a message
  // Future<void> sendMessage(String chatId, String sender, String receiver, String message) async {
  //   await _firestore.collection('chats').doc(chatId).collection('messages').add({
  //     'sender': sender,
  //     'receiver': receiver,
  //     'message': message,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  // // Get messages in real-time
  // Stream<QuerySnapshot> getMessages(String chatId) {
  //   return _firestore.collection('chats').doc(chatId).collection('messages')
  //       .orderBy('timestamp', descending: false)
  //       .snapshots();
  // }
}
