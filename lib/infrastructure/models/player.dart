import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final int totalGols;
  final bool isMonthlyPayer;
  DateTime? lastPay;

  Player(
      {required this.id,
      required this.name,
      required this.totalGols,
      required this.isMonthlyPayer,
      this.lastPay});

  factory Player.fromJson(Map<String, dynamic>? data) {
    return Player(
        id: data?['id'],
        name: data?['name'],
        totalGols: data?['totalGols'],
        isMonthlyPayer: data?['monthlyPayer'],
        lastPay: data?['lastPay']?.toDate());
  }
  @override
  toString() {
    return '$name - $lastPay';
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
