import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pelada.dart';
import '../models/player.dart';
import '../models/playerPerformance.dart';

class PeladaRepositoryImpl {
  final _firestore = FirebaseFirestore.instance;
  bool isPeladaAdmin = false;

  void addNewPelada() async {
    final peladaData = {"date": Timestamp.now(), "performance": {}};
    _firestore.collection('peladas').add(peladaData);
  }

  Stream<Pelada> getPeladaOfCurrentDay() {
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);
    return _firestore
        .collection('peladas')
        .where('date', isGreaterThanOrEqualTo: today)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Pelada.fromJson(data);
      }).toList()[0];
    });
  }

  void addPlayerToPelada(Pelada pelada, Player player) async {
    final performances = pelada.usersPerformance;
    final jsonPerformances = {};
    for (var performance in performances) {
      jsonPerformances[performance.id] = UserPerformance.toJson(performance);
    }
    jsonPerformances[player.id] = {"name": player.name, "gols": 0};

    _firestore
        .collection('peladas')
        .doc(pelada.id)
        .update({"performance": jsonPerformances});
  }

  void addGolToPlayer(Pelada pelada, String userId) {
    final peladaId = pelada.id;
    _firestore
        .collection('peladas')
        .doc(peladaId)
        .update({"performance.$userId.gols": FieldValue.increment(1)});
  }

  void removeGolFromPlayer(Pelada pelada, String userId) {
    final peladaId = pelada.id;
    _firestore
        .collection('peladas')
        .doc(peladaId)
        .update({"performance.$userId.gols": FieldValue.increment(-1)});
  }

  bool isAdminSecret(String secret) {
    if (secret == 'uniaoflasco') {
      return true;
    }
    return false;
  }
}
