import 'package:cash_swift/models/chat_data/chat_data.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final _instance = FirebaseFirestore.instance;
  static final _uid = FirebaseAuth.instance.currentUser!.uid;
  static Future<void> sendMessage(
      {required String userID,
      required String receiverID,
      required ChatMessage chatMessage}) async {
    final chatRoomIdList = [userID, receiverID];
    chatRoomIdList.sort();
    final String chatRoomId = chatRoomIdList.join('');
    await _instance
        .collection("chat")
        .doc(chatRoomId)
        .collection("messages")
        .add(chatMessage.toJson());
    print("sent");
  }

  static Stream<List<Map<String, dynamic>>> getMessages(String chatRoomId) {
    final messages = _instance
        .collection("chat")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();

    final chats =
        messages.map((event) => event.docs.map((e) => e.data()).toList());
    print(chats.forEach((element) {
      print(element);
    }));

    return chats;
  }

  static Stream<List<ChatData>> getChatList() {
    final chatsData =
        _instance.collection("users").doc(_uid).collection("chats").snapshots();

    chatsData.isEmpty.then((value) {
      return [];
    });

    final chatsList = chatsData.map(
        (event) => event.docs.map((e) => ChatData.fromJson(e.data())).toList());
    chatsList.forEach((item) {
      print(item);
    });

    return chatsList;
  }

  static String makeChatRoomId(String userId, String receiverId) {
    final chatRoomList = [userId, receiverId];
    chatRoomList.sort();
    final chatRoomId = chatRoomList.join('');
    return chatRoomId;
  }
}
