import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bola_de_ouro/infrastructure/models/pelada.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/repository/pelada_repository_impl.dart';
import '../../infrastructure/repository/user_repository.dart';
import '../shared/navigation_drawer.dart';

class PeladaPage extends StatefulWidget {
  const PeladaPage({Key? key}) : super(key: key);

  @override
  State<PeladaPage> createState() => _PeladaPageState();
}

class _PeladaPageState extends State<PeladaPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pelada = context.watch<PeladaState>().peladas;
    final isPeladaAdmin = context.watch<PeladaState>().isPeladaAdmin;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      drawer: const NavigationDrawer(),
      body: SafeArea(
        child: pelada.isEmpty
            ? isPeladaAdmin
                ? ButtonStartPelada(isPeladaAdmin: isPeladaAdmin)
                : Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.8,
                            child: Text(
                                'Voce precisa saber a senha pra iniciar uma pelada',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge),
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
                    const SizedBox(height: 30),
                    Text(
                      'Pelada do dia ${DateFormat.MMMMd('pt_BR').format(pelada.first.data().date)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    PeladaPlayersDisplay(
                        pelada: pelada, isPeladaAdmin: isPeladaAdmin),
                    AddPlayerCard(size: size, controller: _controller),
                  ],
                ),
              ),
      ),
    );
  }
}

class PeladaPlayersDisplay extends StatelessWidget {
  const PeladaPlayersDisplay({
    Key? key,
    required this.pelada,
    required this.isPeladaAdmin,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Pelada>> pelada;
  final bool isPeladaAdmin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Consumer<PeladaState>(
          builder: (_, peladaState, __) => Column(
            children: [
              pelada.first.data().usersPerformance.isEmpty
                  ? const NoPlayerText()
                  : PlayingPlayersList(
                      pelada: pelada, isPeladaAdmin: isPeladaAdmin),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayingPlayersList extends StatelessWidget {
  const PlayingPlayersList({
    Key? key,
    required this.pelada,
    required this.isPeladaAdmin,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Pelada>> pelada;
  final bool isPeladaAdmin;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(30),
      itemCount: pelada.first.data().usersPerformance.length,
      itemBuilder: (_, index) {
        final userPerformance = pelada.first.data().usersPerformance[index];
        return SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 120, child: Text(userPerformance.name)),
              SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isPeladaAdmin
                          ? IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                context
                                    .read<UserState>()
                                    .removeGolFromUser(userPerformance.id);
                                context
                                    .read<PeladaState>()
                                    .removeGolInPeladaFromUser(
                                        userPerformance.id);
                              })
                          : Container(),
                      Text(userPerformance.gols.toString()),
                      isPeladaAdmin
                          ? IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context
                                    .read<UserState>()
                                    .goalScoredBy(userPerformance.id);
                                context
                                    .read<PeladaState>()
                                    .goalScoredInPeladaByUser(
                                        userPerformance.id);
                              })
                          : Container(),
                    ],
                  )),
            ],
          ),
        );
      },
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

class AddPlayerCard extends StatelessWidget {
  const AddPlayerCard({
    Key? key,
    required this.size,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final Size size;
  final TextEditingController _controller;

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
                itemCount: usersState.usersNotPlaying.length,
                itemBuilder: (_, index) {
                  final userDoc = usersState.usersNotPlaying[index];
                  final user = userDoc.data();
                  return SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 120, child: Text(user.name)),
                        SizedBox(
                          width: 100,
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<PeladaState>()
                                  .addPlayerToPelada(user);

                              context
                                  .read<UserState>()
                                  .removePlayerFromNotPlayingList(user.id);
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

class SecretPeladaAdminInput extends StatelessWidget {
  const SecretPeladaAdminInput({
    Key? key,
    required this.size,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final Size size;
  final TextEditingController _controller;

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

class ButtonStartPelada extends StatelessWidget {
  const ButtonStartPelada({
    Key? key,
    required this.isPeladaAdmin,
  }) : super(key: key);
  final bool isPeladaAdmin;
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
