import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'grid_row.dart';

class GridBody extends StatefulWidget {
  @override
  _GridBodyState createState() => _GridBodyState();
}

class _GridBodyState extends State<GridBody> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where("monthlyPayer", isEqualTo: true)
      .orderBy('totalGols', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Column(
          children: snapshot.data!.docs.asMap().entries.map((entry) {
            int idx = entry.key;
            DocumentSnapshot document = entry.value;
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            Timestamp? lastPay = data['lastPay'];
            int totalGols = data['totalGols'] ?? 0;
            return GridRow(
                name: data['name'],
                monthlyOrDaily:
                    data['monthlyPayer'] ? 'Mensalista' : 'Diarista',
                lastPay: lastPay != null
                    ? DateFormat.MMMMd('pt_BR').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            lastPay.microsecondsSinceEpoch))
                    : '-',
                goalsString: totalGols.toString(),
                rowIndex: idx);
          }).toList(),
        );
      },
    );
  }
}
