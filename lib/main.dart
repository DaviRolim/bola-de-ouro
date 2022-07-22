import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('pt_BR');
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
      home: const App(),
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
              child: Column(
                children: [
                  const GridHeader(),
                  Container(
                    height: 40,
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80,
                          alignment: Alignment.center,
                          child: Text(
                            'Davi Rolim',
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                        Container(
                          width: 35,
                          alignment: Alignment.center,
                          child: Text(
                            '2',
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                        Container(
                          width: 35,
                          alignment: Alignment.center,
                          child: Text(
                            'M',
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                        Container(
                          width: 90,
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat.MMMMd('pt_BR').format(DateTime.now()),
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
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
