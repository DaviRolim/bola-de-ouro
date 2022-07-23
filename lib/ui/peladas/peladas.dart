import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/repository/pelada_repository_impl.dart';
import '../../infrastructure/repository/user_repository.dart';
import '../shared/navigation_drawer.dart';

class PeladaPage extends StatelessWidget {
  const PeladaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pelada = context.watch<PeladaState>().peladas;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      drawer: const NavigationDrawer(),
      body: SafeArea(
        child: context.watch<PeladaState>().peladas.isEmpty
            ? const ButtonStartPelada()
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
                    Center(
                      child: Card(
                        child: Consumer<PeladaState>(
                          builder: (_, peladaState, __) => Column(
                            children: [
                              pelada.first.data().usersPerformance.isEmpty
                                  ? const SizedBox(
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                            'Adicione a galera que vai jogar.'),
                                      ),
                                    )
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(30),
                                      itemCount: pelada.first
                                          .data()
                                          .usersPerformance
                                          .length,
                                      itemBuilder: (_, index) {
                                        final userPerformance = pelada.first
                                            .data()
                                            .usersPerformance[index];
                                        return SizedBox(
                                          height: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                      userPerformance.name)),
                                              SizedBox(
                                                  width: 120,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                          icon: const Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    UserState>()
                                                                .removeGolFromUser(
                                                                    userPerformance
                                                                        .id);
                                                            context
                                                                .read<
                                                                    PeladaState>()
                                                                .removeGolInPeladaFromUser(
                                                                    userPerformance
                                                                        .id);
                                                          }),
                                                      Text(userPerformance.gols
                                                          .toString()),
                                                      IconButton(
                                                          icon: const Icon(
                                                              Icons.add),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    UserState>()
                                                                .goalScoredBy(
                                                                    userPerformance
                                                                        .id);
                                                            context
                                                                .read<
                                                                    PeladaState>()
                                                                .goalScoredInPeladaByUser(
                                                                    userPerformance
                                                                        .id);
                                                          }),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Card(
                        child: Consumer<UserState>(
                          builder: (_, usersState, __) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Center(
                                    child: Text('Adicionar Jogador na pelada',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge)),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(30),
                                itemCount: usersState.usersNotPlaying.length,
                                itemBuilder: (_, index) {
                                  final userDoc =
                                      usersState.usersNotPlaying[index];
                                  final user = userDoc.data();
                                  return SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                            width: 120, child: Text(user.name)),
                                        SizedBox(
                                          width: 100,
                                          child: IconButton(
                                            onPressed: () {
                                              context
                                                  .read<PeladaState>()
                                                  .addPlayerToPelada(user);

                                              context
                                                  .read<UserState>()
                                                  .removePlayerFromNotPlayingList(
                                                      user.id);
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ButtonStartPelada extends StatelessWidget {
  const ButtonStartPelada({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.sports_soccer, color: Colors.white, size: 54),
        style: ElevatedButton.styleFrom(primary: Colors.black),
        onPressed: () => context.read<PeladaState>().startNewPelada(),
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
