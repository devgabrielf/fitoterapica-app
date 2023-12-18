import 'package:flutter/material.dart';
import 'package:fitoterapica/data/database.dart';
import 'package:fitoterapica/layout/my_app_bar.dart';
import 'package:fitoterapica/model/plant_model.dart';
import 'package:fitoterapica/widgets/add_plant_form.dart';

class AddPlantPage extends StatelessWidget {
  final PlantDatabase db;
  final Plant? initialPlant;

  const AddPlantPage({Key? key, required this.db, this.initialPlant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: '${initialPlant == null ? 'Cadastrar' : 'Editar'} planta',
      ),
      body: SingleChildScrollView(
        child: AddPlantForm(
          onSave: (Plant newPlant) {
            _savePlant(newPlant, context);
          },
          initialPlant: initialPlant,
        ),
      ),
    );
  }

  void _savePlant(Plant newPlant, BuildContext context) async {
    if (initialPlant != null) {
      newPlant.id = initialPlant!.id;
      await db.updatePlant(newPlant);
    } else {
      await db.createPlant(newPlant);
    }

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(newPlant);
  }
}
