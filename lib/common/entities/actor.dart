class Actor {
  final String? id;
  final String? codice;
  final String? nome;

  const Actor({
    this.id,
    this.codice,
    this.nome,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": codice,
        "nome": nome,
      };
}
