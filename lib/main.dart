import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pelada dos Monstros',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: App(),
    );
  }
}

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

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
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            Timestamp? lastPay = data['lastPay'];
            print('EEEEI $data');
            return GridRow(
                name: data['name'],
                monthlyOrDaily: data['monthlyPayer'] ? 'M' : 'D',
                lastPay: lastPay != null
                    ? DateFormat.MMMMd('pt_BR').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            lastPay.microsecondsSinceEpoch))
                    : 'NA',
                goalsString: '5');
          }).toList(),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ronaldinho.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: size.width * 0.8,
              height: size.height * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  children: [const GridHeader(), UserInformation()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridRow extends StatelessWidget {
  const GridRow(
      {Key? key,
      required this.name,
      required this.monthlyOrDaily,
      required this.lastPay,
      required this.goalsString})
      : super(key: key);
  final String name;
  final String monthlyOrDaily;
  final String lastPay;
  final String goalsString;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 80,
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
          Container(
            width: 35,
            alignment: Alignment.center,
            child: Text(
              goalsString,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
          Container(
            width: 35,
            alignment: Alignment.center,
            child: Text(
              monthlyOrDaily,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
          Container(
            width: 90,
            alignment: Alignment.center,
            child: Text(lastPay),
          ),
        ],
      ),
    );
  }
}

class GridHeader extends StatelessWidget {
  const GridHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(15),
        topLeft: Radius.circular(15),
      ),
      child: Container(
        height: 40,
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                'Nome',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
            Container(
              width: 35,
              alignment: Alignment.center,
              child: Text(
                'Gols',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
            Container(
              width: 35,
              alignment: Alignment.center,
              child: Text(
                'M/D',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
            Container(
              width: 90,
              alignment: Alignment.center,
              child: Text(
                'Último Pgto',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
