import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_data.freezed.dart';
part 'chat_data.g.dart';

@freezed
class ChatData with _$ChatData {
  factory ChatData(
      {required String id,
      required String username,
      required String? latestMessage,
      required String phone,
      required String msId,
      required String deviceToken}) = _ChatData;

  factory ChatData.fromJson(Map<String, dynamic> json) =>
      _$ChatDataFromJson(json);
}
