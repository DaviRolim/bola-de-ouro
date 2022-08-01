import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/pelada.dart';
import '../../providers/pelada_provider.dart';
import '../shared/navigation_drawer.dart';
import 'components/add_player_card.dart';
import 'components/pelada_admin_input.dart';
import 'components/players_in_pelada_card.dart';

class PeladaPage extends StatefulWidget {
  const PeladaPage({Key? key}) : super(key: key);

  @override
  State<PeladaPage> createState() => _PeladaPageState();
}

class _PeladaPageState extends State<PeladaPage> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pelada = context.watch<PeladaProvider>().todaysPelada;
    final isPeladaAdmin = context.watch<PeladaProvider>().isPeladaAdmin;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: pelada != null
              ? _buildAppBarTitle(pelada, context)
              : const SizedBox.shrink(),
          elevation: 0),
      drawer: const NavigationDrawer(),
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: pelada == null
              ? isPeladaAdmin
                  ? _buildStartPeladaButton(isPeladaAdmin)
                  : _buildAdminSecretInput(size, context)
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

  Text _buildAppBarTitle(Pelada pelada, BuildContext context) {
    return Text(
                'Pelada do dia ${DateFormat.MMMMd('pt_BR').format(pelada.date)}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              );
  }

  Center _buildAdminSecretInput(Size size, BuildContext context) {
    return Center(
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
                  );
  }

  Widget _buildStartPeladaButton(bool isPeladaAdmin) => Align(
        alignment: Alignment.center,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.sports_soccer, color: Colors.white, size: 54),
          style: ElevatedButton.styleFrom(
              primary: isPeladaAdmin ? Colors.black : Colors.transparent),
          onPressed: () => isPeladaAdmin
              ? context.read<PeladaProvider>().startNewPelada()
              : null,
          label: Text(
            'Iniciar Pelada',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white),
          ),
        ),
      );

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
