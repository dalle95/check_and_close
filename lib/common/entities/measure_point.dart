class MeasurePoint {
  String? id;
  String? codice;
  String? descrizione;

  MeasurePoint({
    this.id,
    this.codice,
    this.descrizione,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": codice,
        "nome": descrizione,
      };
}
