import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitoterapica/model/plant_model.dart';

class PlantItem extends StatelessWidget {
  final Plant plant;
  final void Function(Plant) onViewPlant;

  const PlantItem({
    Key? key,
    required this.plant,
    required this.onViewPlant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          onViewPlant(plant);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image(
                image: FileImage(File(plant.imagePath!)),
                fit: BoxFit.cover,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                plant.name!.toUpperCase(),
                style: TextStyle(
                  color: Colors.blueGrey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
