import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/playerPerformance.dart';
import '../../../providers/pelada_provider.dart';
import '../../../providers/player_provider.dart';

class PlayerPerformanceRow extends StatelessWidget {
  const PlayerPerformanceRow({
    Key? key,
    required this.userPerformance,
    required this.isPeladaAdmin,
  }) : super(key: key);

  final UserPerformance userPerformance;
  final bool isPeladaAdmin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(userPerformance.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white))),
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
                width: 120,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isPeladaAdmin
                        ? Center(
                            child: SizedBox(
                              height: 25,
                              width: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  primary: Colors.redAccent,
                                ),
                                onPressed: () {
                                  context
                                      .read<PlayerProvider>()
                                      .removeGolFromUser(
                                          userPerformance.id);
                                  context
                                      .read<PeladaProvider>()
                                      .removeGolFromPlayer(
                                          userPerformance.id);
                                },
                                child: const Icon(
                                  Icons.remove_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Container(
                      color: Colors.white,
                      width: 15,
                      child: Text(userPerformance.gols.toString(),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium!),
                    ),
                    isPeladaAdmin
                        ? Center(
                            child: SizedBox(
                              height: 25,
                              width: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.greenAccent,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<PlayerProvider>()
                                        .golScoredBy(userPerformance.id);
                                    context
                                        .read<PeladaProvider>()
                                        .playerScored(userPerformance.id);
                                  }),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}