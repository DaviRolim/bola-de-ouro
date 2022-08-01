import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/pelada_provider.dart';
import '../../../providers/player_provider.dart';
import 'pelada_admin_input.dart';

class AddPlayerCard extends StatelessWidget {
  final Size size;

  final TextEditingController _controller;
  const AddPlayerCard({
    Key? key,
    required this.size,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Consumer<PlayerProvider>(
          builder: (_, playerProvider, __) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                    child: Text('Adicionar Jogador na pelada',
                        style: Theme.of(context).textTheme.titleLarge)),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(30),
                itemCount: playerProvider.players.length,
                itemBuilder: (_, index) {
                  final player = playerProvider.players[index];
                  return SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 120, child: Text(player.name)),
                        SizedBox(
                          width: 100,
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<PeladaProvider>()
                                  .addPlayerToPelada(player);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child:
                    SecretPeladaAdminInput(size: size, controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}