import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/pelada.dart';
import '../models/user.dart';
import '../models/userPerformance.dart';

class PeladaState extends ChangeNotifier {
  List<QueryDocumentSnapshot<Pelada>>? _peladas;
  List<QueryDocumentSnapshot<Pelada>> get peladas => _peladas ?? [];
  bool isPeladaAdmin = false;
  List<UserPerformance>? _performances;
  List<UserPerformance> get performances => _performances ?? [];

  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Pelada> get _peladasRef =>
      _firestore.collection('peladas').withConverter<Pelada>(
            fromFirestore: (snapshot, _) => Pelada.fromJson(snapshot.data()),
            toFirestore: (Pelada pelada, _) => pelada.toJson(),
          );
  PeladaState() {
    _peladasRef
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      final mostRecentPelada = event.docs[0];
      if (mostRecentPelada.data().date.day == DateTime.now().day) {
        _peladas = event.docs;
        final currentPelada = event.docs.first.data();
        final userPerformances = currentPelada.usersPerformance;
        userPerformances.sort((a, b) => a.name.compareTo(b.name));
        _performances = userPerformances;
        // _performances = userPerformances.reversed.toList();
      } else {
        _peladas = [];
      }
      notifyListeners();
    });
  }

  void startNewPelada() async {
    final peladaData = {"date": Timestamp.now(), "performance": {}};
    _firestore.collection('peladas').add(peladaData);
    notifyListeners();
  }

  void addPlayerToPelada(User user) {
    final currentPelada = _peladas?.first;
    final peladaId = currentPelada?.id;
    final performances = currentPelada?.data().usersPerformance;
    final jsonPerformances = {};
    for (var performance in performances!) {
      jsonPerformances[performance.id] = UserPerformance.toJson(performance);
    }
    jsonPerformances[user.id] = {"name": user.name, "gols": 0};

    _firestore
        .collection('peladas')
        .doc(peladaId!)
        .update({"performance": jsonPerformances});
  }

  void goalScoredInPeladaByUser(String userId) {
    final currentPelada = _peladas?.first;
    final peladaId = currentPelada?.id;
    _firestore
        .collection('peladas')
        .doc(peladaId!)
        .update({"performance.$userId.gols": FieldValue.increment(1)});
  }

  void removeGolInPeladaFromUser(String userId) {
    final currentPelada = _peladas?.first;
    final peladaId = currentPelada?.id;
    _firestore
        .collection('peladas')
        .doc(peladaId!)
        .update({"performance.$userId.gols": FieldValue.increment(-1)});
  }

  void validateAdminSecret(String secret) {
    if (secret == 'uniaoflasco') {
      isPeladaAdmin = true;
      notifyListeners();
    }
  }
}
