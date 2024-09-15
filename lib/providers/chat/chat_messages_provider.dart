import 'package:cash_swift/services/chat_service/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessageProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, chatRoomId) {
  return ChatService.getMessages(chatRoomId);
});
