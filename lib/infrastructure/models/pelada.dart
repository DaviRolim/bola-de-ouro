import 'package:bola_de_ouro/infrastructure/models/playerPerformance.dart';

class Pelada {
  final String id;
  final DateTime date;
  final List<UserPerformance> usersPerformance;

  Pelada({required this.id, required this.date, required this.usersPerformance});

  factory Pelada.fromJson(Map<String, dynamic>? data) {
    final performances = data?['performance'] as Map<String, dynamic>;
    List<UserPerformance> allPerformances = [];
    if (performances.isNotEmpty) {
      performances.forEach(
          (k, v) => allPerformances.add(UserPerformance.fromJson({k: v})));
    }
    final dateFromTimestamp = DateTime.fromMicrosecondsSinceEpoch(
        data?['date'].microsecondsSinceEpoch);
    return Pelada(id: data?['id'], date: dateFromTimestamp, usersPerformance: allPerformances);
  }

  toJson() {
    // TODO implement toJson return Map<String, dynamic>
    return {
      'highlight': '1',
    };
  }
}
