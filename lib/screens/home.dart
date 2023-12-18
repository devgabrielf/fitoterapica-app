import 'package:fitoterapica/screens/add_plant.dart';
import 'package:fitoterapica/screens/plant.dart';
import 'package:flutter/material.dart';
import 'package:fitoterapica/model/plant_model.dart';
import 'package:fitoterapica/data/database.dart';
import 'package:fitoterapica/layout/main_drawer.dart';
import 'package:fitoterapica/layout/my_app_bar.dart';
import 'package:fitoterapica/widgets/plant_item.dart';
import 'package:fitoterapica/widgets/search_box.dart';

class Home extends StatefulWidget {
  final PlantDatabase plantDatabase;

  const Home({Key? key, required this.plantDatabase}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late PlantDatabase db;
  List<Plant> _filteredPlantList = [];
  final _nameController = TextEditingController();
  final _sciNameController = TextEditingController();
  final _usesController = TextEditingController();
  final _contraindicationsController = TextEditingController();
  final _waysOfUseController = TextEditingController();

  @override
  void initState() {
    db = widget.plantDatabase;
    _loadPlants();

    super.initState();
  }

  void _loadPlants() async {
    List<Plant> plants = await db.getPlants();
    setState(() {
      _filteredPlantList = plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: MyAppBar(
        title: "Fitoterápica",
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == "clear") {
                _clearPlants();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: "clear",
                  child: Text("Apagar todas as plantas"),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            // cria uma “decoração” para a imagem
            image: DecorationImage(
          image: AssetImage(
              'assets/images/background.jpg'), // coloca o caminho da imagem
          fit: BoxFit.cover,
        )),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  SearchBox(
                    onChanged: _runFilter,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _filteredPlantList.length,
                    itemBuilder: (context, index) {
                      Plant plant = _filteredPlantList[index];
                      return PlantItem(
                        plant: plant,
                        onViewPlant: _viewPlant,
                      );
                    },
                  )),
                  const SizedBox(
                    height: 64,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 30,
                    ),
                    child: ElevatedButton(
                      onPressed: _addPlant,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        minimumSize: const Size(60, 60),
                        elevation: 10,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addPlant() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPlantPage(db: db)),
    );

    _loadPlants();
  }

  bool _validateFields() {
    return _nameController.text.isNotEmpty &&
        _sciNameController.text.isNotEmpty &&
        _usesController.text.isNotEmpty &&
        _contraindicationsController.text.isNotEmpty &&
        _waysOfUseController.text.isNotEmpty;
  }

  void _showToast(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _savePlant() async {
    if (_validateFields()) {
      Plant newPlant = Plant(
        name: _nameController.text,
        sciName: _sciNameController.text,
        uses: _usesController.text,
        contraindications: _contraindicationsController.text,
        waysOfUse: _waysOfUseController.text,
      );

      await db.createPlant(newPlant);
      _loadPlants();
      _clearControllers();
    } else {
      _showToast("Preencha todos os campos");
    }
  }

  void _viewPlant(Plant plant) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantPage(
          plantDatabase: db,
          plant: plant,
        ),
      ),
    );

    _loadPlants();
  }

  void _clearControllers() {
    _nameController.clear();
    _sciNameController.clear();
    _usesController.clear();
    _contraindicationsController.clear();
    _waysOfUseController.clear();
  }

  void _clearPlants() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagar plantas'),
          content:
              const Text('Tem certeza de que deseja apagar todas as plantas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _confirmClearPlants();
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearPlants() async {
    await db.clearPlants();
    _loadPlants();
  }

  void _runFilter(String enteredKeyword) async {
    List<Plant> results = [];

    if (enteredKeyword.isEmpty) {
      results = await db.getPlants();
    } else {
      results = _filteredPlantList
          .where((plant) =>
              plant.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredPlantList = results;
    });
  }
}
