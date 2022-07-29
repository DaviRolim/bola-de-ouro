import 'package:bola_de_ouro/infrastructure/models/pelada.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/models/playerPerformance.dart';
import '../../../infrastructure/repository/pelada_repository_impl.dart';
import '../../../infrastructure/repository/user_repository.dart';
import '../shared/navigation_drawer.dart';

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
        child: Consumer<UserState>(
          builder: (_, usersState, __) => Column(
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
                itemCount: usersState.users.length,
                itemBuilder: (_, index) {
                  final userDoc = usersState.users[index];
                  final player = userDoc.data();
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
                                  .read<PeladaState>()
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

class ButtonStartPelada extends StatelessWidget {
  final bool isPeladaAdmin;
  const ButtonStartPelada({
    Key? key,
    required this.isPeladaAdmin,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.sports_soccer, color: Colors.white, size: 54),
        style: ElevatedButton.styleFrom(
            primary: isPeladaAdmin ? Colors.black : Colors.transparent),
        onPressed: () =>
            isPeladaAdmin ? context.read<PeladaState>().startNewPelada() : null,
        label: Text(
          'Iniciar Pelada',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class NoPlayerText extends StatelessWidget {
  const NoPlayerText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Center(
        child: Text('Adicione a galera que vai jogar.'),
      ),
    );
  }
}

class PeladaPage extends StatefulWidget {
  const PeladaPage({Key? key}) : super(key: key);

  @override
  State<PeladaPage> createState() => _PeladaPageState();
}

class PeladaPlayersDisplay extends StatelessWidget {
  final List<QueryDocumentSnapshot<Pelada>> pelada;

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
        child: Consumer<PeladaState>(
          builder: (_, peladaState, __) => Column(
            children: [
              peladaState.performances.isEmpty
                  ? const NoPlayerText()
                  : PlayingPlayersList(
                      performances: peladaState.performances,
                      isPeladaAdmin: isPeladaAdmin),
            ],
          ),
        ),
      ),
    );
  }
}

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
                                            .read<UserState>()
                                            .removeGolFromUser(
                                                userPerformance.id);
                                        context
                                            .read<PeladaState>()
                                            .removeGolInPeladaFromUser(
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
                                              .read<UserState>()
                                              .goalScoredBy(userPerformance.id);
                                          context
                                              .read<PeladaState>()
                                              .goalScoredInPeladaByUser(
                                                  userPerformance.id);
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
        },
      ),
    );
  }
}

class SecretPeladaAdminInput extends StatelessWidget {
  final Size size;

  final TextEditingController _controller;
  const SecretPeladaAdminInput({
    Key? key,
    required this.size,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.7,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pelada admin secret',
        ),
        onSubmitted: (String value) {
          context.read<PeladaState>().validateAdminSecret(value);
        },
      ),
    );
  }
}

class _PeladaPageState extends State<PeladaPage> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pelada = context.watch<PeladaState>().peladas;
    final isPeladaAdmin = context.watch<PeladaState>().isPeladaAdmin;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: pelada.isNotEmpty
              ? Text(
                  'Pelada do dia ${DateFormat.MMMMd('pt_BR').format(pelada.first.data().date)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                )
              : const SizedBox.shrink(),
          elevation: 0),
      drawer: const NavigationDrawer(),
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: pelada.isEmpty
              ? isPeladaAdmin
                  ? ButtonStartPelada(isPeladaAdmin: isPeladaAdmin)
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        height: 200,
                        margin: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: Text(
                                  'Voce precisa saber a senha pra iniciar uma pelada',
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            const SizedBox(height: 20),
                            SecretPeladaAdminInput(
                                size: size, controller: _controller),
                          ],
                        ),
                      ),
                    )
              : SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      PeladaPlayersDisplay(
                          pelada: pelada, isPeladaAdmin: isPeladaAdmin),
                      AddPlayerCard(size: size, controller: _controller),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
}
