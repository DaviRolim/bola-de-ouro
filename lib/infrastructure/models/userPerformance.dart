import 'package:cloud_firestore/cloud_firestore.dart';

class UserPerformance {
  final String id;
  final String name;
  final int gols;

  UserPerformance({
    required this.id,
    required this.name,
    required this.gols,
  });

  factory UserPerformance.fromJson(Map<String, dynamic>? data) {
    final id = data!.keys.first;
    final userPerformance = data.values.first;
    return UserPerformance(
      id: id,
      name: userPerformance['name'],
      gols: userPerformance['gols'],
    );
  }

  static Map<String, dynamic> toJson(UserPerformance userPerformance) {
    return {'name': userPerformance.name, 'gols': userPerformance.gols};
  }
}
