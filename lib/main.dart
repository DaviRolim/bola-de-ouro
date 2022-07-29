import 'package:bola_de_ouro/presentation/providers/player_provider.dart';
import 'package:bola_de_ouro/presentation/ui/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'infrastructure/repository/pelada_repository_impl.dart';
import 'infrastructure/repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => PeladaState(),
      ),
      ChangeNotifierProvider(
        create: (_) => UserState(),
      ),
      ChangeNotifierProvider(
        create: (_) => PlayerProvider(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pelada dos Monstros',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Home(),
    );
  }
}
