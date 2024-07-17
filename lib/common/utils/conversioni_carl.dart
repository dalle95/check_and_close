class ConversioniCarl {
  /// Funzione per convertire i valori in ID di Carl
  String? convertiValoreID(String valore) {
    //TODO: da migliorare gestione id
    var mappaScelta = {
      // 'Conforme': '190a5529fe7-225',
      // 'Non conforme': '190a5529fe7-228',
      // 'Non valutata': '190a5529fe7-22b', --- DEMO-4
      'Conforme': 'Conforme',
      'Non conforme': 'Non conforme',
      'Non valutata': 'Non valutata',
    };

    return mappaScelta[valore];
  }

  /// Funzione per convertire gli ID di Carl in valori
  String? convertiIDValore(String valore) {
    //TODO: da migliorare gestione id
    var mappaScelta = {
      // '190a5529fe7-225': 'Conforme',
      // '190a5529fe7-228': 'Non conforme',
      // '190a5529fe7-22b': 'Non valutata', --- DEMO-4
      'Conforme': 'Conforme',
      'Non conforme': 'Non conforme',
      'Non valutata': 'Non valutata',
    };

    return mappaScelta[valore];
  }
}
