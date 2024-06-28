import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  factory UserData(
      {required String username,
      required String email,
      required String phone,
      required String pin,
      required String msId,
      required double balance,
      required double expenditure,
      required Map<String, double> paymentCategory,
      required List history,
      required String deviceToken}) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
