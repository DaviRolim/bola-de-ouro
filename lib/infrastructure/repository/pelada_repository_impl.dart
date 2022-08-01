import 'package:bola_de_ouro/infrastructure/helpers/try_get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/pelada.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/playerPerformance.dart';
import '../../domain/repository/pelada_repository.dart';
class PeladaRepositoryImpl implements PeladaRepository {
  final _firestore = FirebaseFirestore.instance;
  bool isPeladaAdmin = false;

  @override
  void addNewPelada() async {
    final peladaData = {"date": Timestamp.now(), "performance": {}};
    _firestore.collection('peladas').add(peladaData);
  }

  @override
  Stream<Pelada?> getPeladaOfCurrentDay() {
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);
    return _firestore
        .collection('peladas')
        .where('date', isGreaterThanOrEqualTo: today)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Pelada.fromJson(data);
          })
          .toList()
          .tryGet(0);
    });
  }

  @override
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

  @override
  void addGolToPlayer(Pelada pelada, String userId) {
    final peladaId = pelada.id;
    _firestore
        .collection('peladas')
        .doc(peladaId)
        .update({"performance.$userId.gols": FieldValue.increment(1)});
  }

  @override
  void removeGolFromPlayer(Pelada pelada, String userId) {
    final peladaId = pelada.id;
    _firestore
        .collection('peladas')
        .doc(peladaId)
        .update({"performance.$userId.gols": FieldValue.increment(-1)});
  }

  @override
  bool isAdminSecret(String secret) {
    if (secret == 'uniaoflasco') {
      return true;
    }
    return false;
  }
}
