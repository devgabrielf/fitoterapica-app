import 'package:flutter/material.dart';
import 'package:fitoterapica/layout/main_drawer.dart';
import 'package:fitoterapica/layout/my_app_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        title: "Sobre",
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FitoTerápica é uma plataforma dedicada a fornecer acesso a informações sobre plantas medicinais, visando democratizar o conhecimento científico e tradicional. O objetivo é promover o uso seguro de fitoterápicos e inovar na apresentação dessas informações, contribuindo para uma saúde mais informada e sustentável. ',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                'Desenvolvido por:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  developer("Ana Júlia", "ana.jpg"),
                  const SizedBox(height: 12),
                  developer("Bianca Rangel", "bianca.jpg"),
                  const SizedBox(height: 12),
                  developer("Gabriel Ferreira", "gabriel.jpg"),
                  const SizedBox(height: 12),
                  developer("Lucas Gabriell", "lucas.jpg"),
                  const SizedBox(height: 12),
                  developer("Pedro Henrique", "pedro.jpg"),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Voltar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row developer(String name, String photo) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/$photo'),
          radius: 24,
        ),
        const SizedBox(width: 10),
        Text(name)
      ],
    );
  }
}
