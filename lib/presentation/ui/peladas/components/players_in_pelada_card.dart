import 'package:bola_de_ouro/presentation/ui/peladas/components/playing_players.dart';
import 'package:flutter/material.dart';

import '../../../../infrastructure/models/pelada.dart';

class PeladaPlayersDisplay extends StatelessWidget {
  final Pelada pelada;

  final bool isPeladaAdmin;
  const PeladaPlayersDisplay({
    Key? key,
    required this.pelada,
    required this.isPeladaAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: [
            pelada.usersPerformance.isEmpty
                ? _buildNoPlayerText()
                : PlayingPlayersList(
                    performances: pelada.usersPerformance,
                    isPeladaAdmin: isPeladaAdmin),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPlayerText() => const SizedBox(
        height: 40,
        child: Center(
          child: Text('Adicione a galera que vai jogar.'),
        ),
      );
}