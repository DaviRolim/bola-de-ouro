import 'package:flutter/material.dart';

import '../../domain/entities/pelada.dart';
import '../../domain/entities/player.dart';
import '../../domain/repository/pelada_repository.dart';

class PeladaProvider extends ChangeNotifier {
  final PeladaRepository repository;
  Pelada? _todaysPelada;
  Pelada? get todaysPelada => _todaysPelada;
  bool isPeladaAdmin = false;

  PeladaProvider(this.repository) {
    subscribeTodaysPelada();
  }
  subscribeTodaysPelada() {
    repository.getPeladaOfCurrentDay().listen((event) {
      _todaysPelada = event;
      notifyListeners();
    });
  }

  void startNewPelada() {
    repository.addNewPelada();
  }

  void addPlayerToPelada(Player player) {
    repository.addPlayerToPelada(_todaysPelada!, player);
  }

  void playerScored(String playerID) {
    repository.addGolToPlayer(_todaysPelada!, playerID);
  }

  void removeGolFromPlayer(String playerID) {
    repository.removeGolFromPlayer(_todaysPelada!, playerID);
  }

  validatePeladaAdmin(String secret) {
    isPeladaAdmin = repository.isAdminSecret(secret);
  }
}
