import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitoterapica/data/database.dart';
import 'package:fitoterapica/layout/my_app_bar.dart';
import 'package:fitoterapica/model/plant_model.dart';
import 'package:fitoterapica/screens/add_plant.dart';

// ignore: must_be_immutable
class PlantPage extends StatefulWidget {
  final PlantDatabase plantDatabase;
  Plant plant;

  PlantPage({super.key, required this.plantDatabase, required this.plant});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  late PlantDatabase db;

  @override
  void initState() {
    db = widget.plantDatabase;
    super.initState();
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir planta'),
          content: const Text('Tem certeza de que deseja excluir esta planta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _deletePlantAndNavigateBack();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePlantAndNavigateBack() async {
    await db.deletePlant(widget.plant.id!);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Colors.green;

    TextStyle detailTextStyle =
        const TextStyle(fontSize: 16, color: Colors.black);

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Detalhes da planta',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(File(widget.plant.imagePath!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            buildDetailTile('Nome:', widget.plant.name!, detailTextStyle),
            buildDetailTile(
              'Nome científico:',
              widget.plant.sciName!,
              detailTextStyle.merge(
                const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            buildDetailTile('Usos:', widget.plant.uses!, detailTextStyle),
            buildDetailTile(
                'Formas de uso:', widget.plant.waysOfUse!, detailTextStyle),
            buildDetailTile(
              'Contra-indicações:',
              widget.plant.contraindications!,
              detailTextStyle,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final updatedPlant = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPlantPage(
                          db: db,
                          initialPlant: widget.plant,
                        ),
                      ),
                    );

                    if (updatedPlant != null) {
                      setState(() {
                        widget.plant = updatedPlant;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Editar'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  child: const Text('Excluir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildDetailTile(String title, String value, TextStyle textStyle,
      {TextStyle titleTextStyle = const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)}) {
    return ListTile(
      title: Text(title, style: titleTextStyle),
      subtitle: Text(value, style: textStyle),
    );
  }
}
