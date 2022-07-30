import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../../../infrastructure/models/player.dart';
import '../../providers/player_provider.dart';
import '../shared/navigation_drawer.dart';

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
                Row(
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
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: const Text('Adicionar',
                      style: TextStyle(color: Colors.white)),
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
                ),
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
                            return EditUserRow(player: player);
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
}

class EditUserRow extends StatefulWidget {
  const EditUserRow({super.key, required this.player});

  final Player player;
  @override
  State<EditUserRow> createState() => _EditUserRowState();
}

class _EditUserRowState extends State<EditUserRow> {
  late bool _isMonthlyPayer;
  late TextEditingController _controller;
  late DateTime? _payDay;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.player.name;
    _isMonthlyPayer = widget.player.isMonthlyPayer;
    _payDay = widget.player.lastPay;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitEditPlayerForm(BuildContext context) {
    context.read<PlayerProvider>().editUser(widget.player.id, _controller.text,
        _isMonthlyPayer, widget.player.totalGols, _payDay);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: TextField(
              readOnly: isEditing ? false : true,
              controller: _controller,
            ),
          ),
          const SizedBox(width: 8),
          // const Text('Mensal'),
          if (!isEditing)
            Container(
                width: 80,
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                    widget.player.isMonthlyPayer ? 'Mensalista' : 'Diarista')),
          if (isEditing)
            Checkbox(
              checkColor: Colors.white,
              // fillColor: Colors.green,
              value: _isMonthlyPayer,
              onChanged: (bool? value) {
                setState(() {
                  _isMonthlyPayer = value!;
                });
              },
            ),
          if (isEditing)
            Flexible(
              child: ElevatedButton(
                  child: const Text('Data Pagamento'),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: _payDay ?? DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2023),
                    );

                    if (newDate == null) return;
                    setState(() {
                      _payDay = newDate;
                    });
                  }),
            ),
          if (!isEditing)
            Text(_payDay != null
                ? DateFormat.MMMMd('pt_BR').format(_payDay!)
                : '-'),
          IconButton(
              icon: isEditing ? const Icon(Icons.save) : const Icon(Icons.edit),
              onPressed: () {
                if (isEditing) {
                  _submitEditPlayerForm(context);
                }
                setState(() {
                  isEditing = !isEditing;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  content: Text(
                    'Alteração feita com sucesso',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(seconds: 2),
                ));
              })
        ],
      ),
    );
  }
}
