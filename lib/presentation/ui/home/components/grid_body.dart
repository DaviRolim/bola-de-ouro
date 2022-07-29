import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/player_provider.dart';
import 'grid_row.dart';

class GridBody extends StatefulWidget {
  @override
  _GridBodyState createState() => _GridBodyState();
}

class _GridBodyState extends State<GridBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (_, playerProvider, __) {
      return Column(
        children: [
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: playerProvider.monthlyPlayers.length,
              itemBuilder: (_, index) {
                final player = playerProvider.monthlyPlayers[index];
                return GridRow(
                    name: player.name,
                    monthlyOrDaily:
                        player.isMonthlyPayer ? 'Mensalista' : 'Diarista',
                    lastPay: player.lastPay != null
                        ? DateFormat.MMMMd('pt_BR').format(player.lastPay!)
                        : '-',
                    goalsString: player.totalGols.toString(),
                    rowIndex: index);
              }),
        ],
      );
    });
  }
}
