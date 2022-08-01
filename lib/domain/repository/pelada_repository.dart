import '../entities/pelada.dart';
import '../entities/player.dart';

abstract class PeladaRepository {
  void addNewPelada();
  Stream<Pelada?> getPeladaOfCurrentDay();
  void addPlayerToPelada(Pelada pelada, Player player);
  void addGolToPlayer(Pelada pelada, String userId);
  void removeGolFromPlayer(Pelada pelada, String userId);
  bool isAdminSecret(String secret);
}
