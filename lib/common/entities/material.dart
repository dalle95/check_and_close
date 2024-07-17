class Material {
  final String? id;
  final String? code;
  final String? descrizione;
  final String? eqptType;

  const Material({
    this.id,
    this.code,
    this.descrizione,
    this.eqptType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'descrizione': descrizione,
        'eqptType': eqptType,
      };

  factory Material.fromJson(Map<String, dynamic> json) => Material(
        id: json["id"],
        code: json["code"],
        descrizione: json["descrizione"],
        eqptType: json["eqptType"],
      );
}
