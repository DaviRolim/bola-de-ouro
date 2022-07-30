import 'dart:async';

import 'package:bola_de_ouro/infrastructure/repository/player_repository_impl.dart';
import 'package:flutter/foundation.dart';

import '../../infrastructure/models/player.dart';

class PlayerProvider extends ChangeNotifier {
  final repository = PlayerRepository();
  List<Player>? _monthlyPlayers;
  List<Player> get monthlyPlayers => _monthlyPlayers ?? [];
  PlayerProvider() {
    subscribeMonthlyPlayer();
  }

  Stream<List<Player>> monthlyPlayerStream() {
    return repository.watchMonthlyPlayers();
  }

  subscribeMonthlyPlayer() {
    repository.watchMonthlyPlayers().listen((event) {
      _monthlyPlayers = event;
      notifyListeners();
    });
  }
}
