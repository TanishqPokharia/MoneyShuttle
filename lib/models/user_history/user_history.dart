import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_history.freezed.dart';
part 'user_history.g.dart';

@freezed
class UserHistory with _$UserHistory {
  factory UserHistory(
      {required String username,
      required String phone,
      required String note,
      required String msId,
      required String amount,
      required String category,
      required String time,
      required int date,
      required int month,
      required int year}) = _UserHistory;

  factory UserHistory.fromJson(Map<String, dynamic> json) =>
      _$UserHistoryFromJson(json);
}
