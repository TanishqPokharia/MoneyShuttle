import 'package:cash_swift/models/chat_data/chat_data.dart';
import 'package:cash_swift/services/chat_service/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatListProvider = StreamProvider<List<ChatData>>((ref) {
  return ChatService.getChatList();
});
