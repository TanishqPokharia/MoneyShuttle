import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpNameProvider = StateProvider<String>((ref) {
  return "";
});

final signUpEmailProvider = StateProvider<String>((ref) {
  return "";
});

final signUpPasswordProvider = StateProvider<String>((ref) {
  return "";
});

final signUpPhoneNumberProvider = StateProvider<String>((ref) {
  return "";
});

final signUpPinProvider = StateProvider<String>(
  (ref) => "",
);
