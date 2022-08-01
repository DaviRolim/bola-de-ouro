import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../infrastructure/models/player.dart';
import '../../../providers/player_provider.dart';

class EditPlayerRow extends StatefulWidget {
  const EditPlayerRow({super.key, required this.player});

  final Player player;
  @override
  State<EditPlayerRow> createState() => _EditUserRowState();
}

class _EditUserRowState extends State<EditPlayerRow> {
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
