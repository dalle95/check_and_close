import '/common/entities/measure_point.dart';

class WOProcess {
  String? id;
  String? comment;
  double? ordering;
  String? tipologia;
  bool? obbligatorio;
  DateTime? dataRealizzazione;
  dynamic valore;
  MeasurePoint? puntoDiLettura;
  String? letturaID;

  WOProcess({
    this.id,
    this.comment,
    this.ordering,
    this.tipologia,
    this.obbligatorio,
    this.dataRealizzazione,
    this.valore,
    this.puntoDiLettura,
    this.letturaID,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'ordering': ordering,
        'tipologia': tipologia,
        'obbligatorio': obbligatorio,
        'dataRealizzazione': dataRealizzazione,
        'valore': valore,
        'puntoDiLettura': puntoDiLettura?.toJson(),
        'letturaID': letturaID,
      };
}
