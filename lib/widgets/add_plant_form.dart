import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitoterapica/model/plant_model.dart';
import 'package:image_picker/image_picker.dart';

class AddPlantForm extends StatefulWidget {
  final Function(Plant) onSave;
  final Plant? initialPlant;

  const AddPlantForm({super.key, required this.onSave, this.initialPlant});

  @override
  // ignore: library_private_types_in_public_api
  _AddPlantFormState createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _sciNameController;
  late final TextEditingController _usesController;
  late final TextEditingController _contraindicationsController;
  late final TextEditingController _waysOfUseController;

  late final ImagePicker _imagePicker = ImagePicker();
  late XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sciNameController = TextEditingController();
    _usesController = TextEditingController();
    _contraindicationsController = TextEditingController();
    _waysOfUseController = TextEditingController();

    if (widget.initialPlant != null) {
      _nameController.text = widget.initialPlant!.name ?? '';
      _sciNameController.text = widget.initialPlant!.sciName ?? '';
      _usesController.text = widget.initialPlant!.uses ?? '';
      _contraindicationsController.text =
          widget.initialPlant!.contraindications ?? '';
      _waysOfUseController.text = widget.initialPlant!.waysOfUse ?? '';
      _pickedImage = XFile(widget.initialPlant!.imagePath!);
    } else {
      _pickedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _pickImage();
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: _pickedImage != null ? null : Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
                image: _pickedImage != null
                    ? DecorationImage(
                        image: FileImage(File(_pickedImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _pickedImage == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: _sciNameController,
            decoration: const InputDecoration(labelText: 'Nome científico'),
          ),
          TextField(
            controller: _usesController,
            decoration: const InputDecoration(labelText: 'Usos'),
          ),
          TextField(
            controller: _waysOfUseController,
            decoration: const InputDecoration(labelText: 'Formas de uso'),
          ),
          TextField(
            controller: _contraindicationsController,
            decoration: const InputDecoration(labelText: 'Contra-indicações'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _savePlant();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_pickedImage != null && widget.initialPlant == null) {
      File(_pickedImage!.path).delete();
    }

    super.dispose();
  }

  bool _validateFields() {
    return _nameController.text.isNotEmpty &&
        _sciNameController.text.isNotEmpty &&
        _usesController.text.isNotEmpty &&
        _contraindicationsController.text.isNotEmpty &&
        _waysOfUseController.text.isNotEmpty;
  }

  void _clearControllers() {
    _nameController.clear();
    _sciNameController.clear();
    _usesController.clear();
    _contraindicationsController.clear();
    _waysOfUseController.clear();
  }

  void _showToast(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _savePlant() {
    if (_validateFields() && _pickedImage != null) {
      Plant newPlant = Plant(
        name: _nameController.text,
        sciName: _sciNameController.text,
        uses: _usesController.text,
        contraindications: _contraindicationsController.text,
        waysOfUse: _waysOfUseController.text,
        imagePath: _pickedImage!.path,
      );

      widget.onSave(newPlant);

      _clearControllers();
    } else {
      _showToast("Preencha todos os campos");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }
}
