import 'package:bola_de_ouro/infrastructure/repository/player_repository_impl.dart';
import 'package:bola_de_ouro/presentation/providers/pelada_provider.dart';
import 'package:bola_de_ouro/presentation/providers/player_provider.dart';
import 'package:get_it/get_it.dart';

import 'domain/repository/pelada_repository.dart';
import 'domain/repository/player_repository.dart';
import 'infrastructure/repository/pelada_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Repository
  getIt.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl());
  getIt.registerLazySingleton<PlayerProvider>(() => PlayerProvider(getIt()));

  getIt.registerLazySingleton<PeladaRepository>(() => PeladaRepositoryImpl());
  getIt.registerLazySingleton<PeladaProvider>(() => PeladaProvider(getIt()));
}
