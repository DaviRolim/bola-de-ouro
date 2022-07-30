import 'dart:async';

import 'package:bola_de_ouro/infrastructure/repository/player_repository_impl.dart';
import 'package:flutter/foundation.dart';

import '../../infrastructure/models/player.dart';

class PlayerProvider extends ChangeNotifier {
  final repository = PlayerRepository();
  List<Player>? _players;
  List<Player> get players => _players ?? [];

  List<Player>? _monthlyPlayers;
  List<Player> get monthlyPlayers => _monthlyPlayers ?? [];

  PlayerProvider() {
    subscribePlayers();
    subscribeMonthlyPlayer();
  }

  subscribePlayers() {
    repository.watchPlayers().listen((event) {
      _players = event;
      notifyListeners();
    });
  }

  subscribeMonthlyPlayer() {
    repository.watchMonthlyPlayers().listen((event) {
      _monthlyPlayers = event;
      notifyListeners();
    });
  }

  void addUser(String playerName, bool isMonthlyPayer) {
    repository.addUser(playerName, isMonthlyPayer);
  }

  void editUser(
      String id, String name, bool isMonthlyPayer, totalGols, lastPay) {
    repository.updateUser(id, name, isMonthlyPayer, totalGols, lastPay);
  }

  void golScoredBy(String userID) {
    repository.increaseUserTotalGols(userID);
  }

  void removeGolFromUser(String userID) {
    repository.decreaseUserTotalGols(userID);
  }
}
