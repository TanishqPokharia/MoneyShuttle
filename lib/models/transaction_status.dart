class TransactionStatus {
  final bool status;
  final String? amount;
  final String? receiverName;
  final String? receiverPhone;
  final String? receiverId;

  TransactionStatus(
      {required this.status,
      required this.amount,
      required this.receiverName,
      required this.receiverPhone,
      required this.receiverId});
}
