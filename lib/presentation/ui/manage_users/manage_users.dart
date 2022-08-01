import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';
import '../shared/navigation_drawer.dart';
import 'components/edit_player_row.dart';

enum PaymentType { daily, monthly }

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  PaymentType? _paymentType = PaymentType.daily;
  late TextEditingController _controller;
  String _playerName = '';

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

  void _submitAddPlayerForm(BuildContext context) {
    final isMonthlyPayer = _paymentType.toString() == 'PaymentType.monthly';
    _playerName = _controller.text;
    context.read<PlayerProvider>().addUser(_playerName, isMonthlyPayer);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.green, elevation: 0),
      drawer: const NavigationDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _buildAddPlayerFields(),
                const SizedBox(height: 10),
                _buildAddUserButton(context),
                const SizedBox(height: 30),
                Card(
                  child: Consumer<PlayerProvider>(
                    builder: (_, playerProvider, __) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                              child: Text('Gerenciar Jogadores',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          itemCount: playerProvider.players.length,
                          itemBuilder: (_, index) {
                            final player = playerProvider.players[index];
                            return EditPlayerRow(player: player);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildAddUserButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
      onPressed: () {
        _submitAddPlayerForm(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Text(
            'Jogador adicionado com sucesso',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
        ));
      },
    );
  }

  Row _buildAddPlayerFields() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: 200,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome do Jogador',
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              ListTile(
                title: const Text('Diarista'),
                leading: Radio<PaymentType>(
                  value: PaymentType.daily,
                  groupValue: _paymentType,
                  onChanged: (PaymentType? value) {
                    setState(() {
                      _paymentType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Mensalista'),
                leading: Radio<PaymentType>(
                  value: PaymentType.monthly,
                  groupValue: _paymentType,
                  onChanged: (PaymentType? value) {
                    setState(() {
                      _paymentType = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
