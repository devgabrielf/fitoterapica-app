// Nome: Gabriel Ferreira Marques Mendes

class Plant {
  int? id;
  String? name;
  String? sciName;
  String? uses;
  String? waysOfUse;
  String? contraindications;
  String? imagePath;

  Plant({
    this.id,
    this.name,
    this.sciName,
    this.uses,
    this.waysOfUse,
    this.contraindications,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sciName': sciName,
      'uses': uses,
      'waysOfUse': waysOfUse,
      'contraindications': contraindications,
      'imagePath': imagePath,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      name: map['name'],
      sciName: map['sciName'],
      uses: map['uses'],
      waysOfUse: map['waysOfUse'],
      contraindications: map['contraindications'],
      imagePath: map['imagePath'],
    );
  }
}
