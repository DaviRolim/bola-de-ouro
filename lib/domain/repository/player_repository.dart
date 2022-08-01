import '../../infrastructure/models/player.dart';

abstract class PlayerRepository {
  Stream<List<Player>> watchMonthlyPlayers();
  Stream<List<Player>> watchPlayers();
  void addUser(String playerName, bool isMonthlyPayer);

  void updateUser(
    String id,
    String name,
    bool isMonthlyPayer,
    int totalGols,
    DateTime? lastPay,
  );

  void increaseUserTotalGols(String userId);

  void decreaseUserTotalGols(String userId);
}
