import 'package:bola_de_ouro/infrastructure/repository/pelada_repository_impl.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/models/pelada.dart';
import '../../infrastructure/models/player.dart';

class PeladaProvider extends ChangeNotifier {
  final repository = PeladaRepositoryImpl();
  Pelada? _todaysPelada;
  Pelada? get todaysPelada => _todaysPelada;
  bool isPeladaAdmin = false;

  PeladaProvider() {
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
