import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final int totalGols;
  final bool isMonthlyPayer;
  DateTime? lastPay;

  User(
      {required this.id,
      required this.name,
      required this.totalGols,
      required this.isMonthlyPayer,
      DateTime? lastPay});

  factory User.fromJson(Map<String, dynamic>? data) {
    final lastPay = data?['lastPay'] != null
        ? DateTime.fromMicrosecondsSinceEpoch(
            data!['lastPay'].microsecondsSinceEpoch)
        : null;
    return User(
        id: data?['id'],
        name: data?['name'],
        totalGols: data?['totalGols'],
        isMonthlyPayer: data?['monthlyPayer'],
        lastPay: lastPay);
  }

  toJson() {
    final jsonUser = {
      'name': name,
      'monthlyPayer': isMonthlyPayer,
      'totalGols': 0,
    };
    if (isMonthlyPayer) {
      jsonUser['lastPay'] = Timestamp.now();
    }
    return jsonUser;
  }
}
