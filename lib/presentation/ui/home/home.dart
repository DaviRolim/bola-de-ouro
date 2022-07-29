import 'package:flutter/material.dart';

import '../shared/navigation_drawer.dart';
import 'components/grid_body.dart';
import 'components/grid_header.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      drawer: const NavigationDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ronaldinho.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.6,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const GridHeader(),
                        GridBody(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                  child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(
                          'https://chat.whatsapp.com/2sab853ZUmeGRNS8JdIOK8'),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      label: const Text(
                        'Grupo do whatsapp',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.whatsapp,
                          color: Colors.white, size: 60)))
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $uri';
  }
}
