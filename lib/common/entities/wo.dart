class WO {
  String? id;
  String? code;
  String? descrizione;
  String? natura;
  DateTime? dataInizio;
  DateTime? dataFine;

  WO({
    this.id,
    this.code,
    this.descrizione,
    this.natura,
    this.dataInizio,
    this.dataFine,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'descrizione': descrizione,
        'natura': natura,
        'dataInizio': dataInizio,
        'dataFine': dataFine,
      };

  factory WO.fromJson(Map<String, dynamic> json) => WO(
        id: json["id"],
        code: json["code"],
        descrizione: json["descrizione"],
        natura: json["natura"],
        dataInizio: json["dataInizio"],
        dataFine: json["dataFine"],
      );
}
