import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final int totalGols;
  final bool isMonthlyPayer;
  Timestamp? lastPay;

  User(
      {required this.id,
      required this.name,
      required this.totalGols,
      required this.isMonthlyPayer,
      this.lastPay});

  factory User.fromJson(Map<String, dynamic>? data) {
    // print('DATA $data');
    return User(
        id: data?['id'],
        name: data?['name'],
        totalGols: data?['totalGols'],
        isMonthlyPayer: data?['monthlyPayer'],
        lastPay: data?['lastPay']);
  }
  @override
  toString() {
    return '$name - ${lastPay?.toDate()}';
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
