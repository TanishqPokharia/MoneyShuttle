class CashSwiftUser {
  final String username;
  final String? id;
  final double? balance;
  final String? phoneNumber;
  final String? email;

  CashSwiftUser(
      {required this.username,
      required this.email,
      required this.id,
      required this.balance,
      required this.phoneNumber});
}
