import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/repository/pelada_repository_impl.dart';
import '../home/home.dart';
import '../peladas/peladas.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: const Text('Pelada'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const PeladaPage()));
              },
            ),
            Consumer<PeladaState>(
              builder: (_, peladaState, __) => Column(
                children: [
                  peladaState.isPeladaAdmin
                      ? ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Gerenciar Jogadores'),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const PeladaPage()));
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
