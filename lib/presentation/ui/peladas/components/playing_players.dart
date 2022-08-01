import 'package:bola_de_ouro/presentation/ui/peladas/components/player_performance_row.dart';
import 'package:flutter/material.dart';

import '../../../../infrastructure/models/playerPerformance.dart';

class PlayingPlayersList extends StatelessWidget {
  final List<UserPerformance> performances;

  final bool isPeladaAdmin;
  const PlayingPlayersList({
    Key? key,
    required this.performances,
    required this.isPeladaAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/soccer-bg-green.webp"),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(30),
        itemCount: performances.length,
        itemBuilder: (_, index) {
          final userPerformance = performances[index];
          return PlayerPerformanceRow(userPerformance: userPerformance, isPeladaAdmin: isPeladaAdmin);
        },
      ),
    );
  }
}

