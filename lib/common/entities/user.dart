class User {
  final String? token;
  final String? username;
  final String? password;
  final String? actorId;
  final String? actorCodice;
  final String? actorNome;
  final String? refreshDate;

  const User({
    this.token,
    this.username,
    this.password,
    this.actorId,
    this.actorCodice,
    this.actorNome,
    this.refreshDate,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'username': username,
        'password': password,
        'actor_id': actorId,
        'actor_codice': actorCodice,
        'actor_nome': actorNome,
        'refreshDate': refreshDate,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
        username: json["username"],
        password: json["password"],
        actorId: json["actor_id"],
        actorCodice: json["actor_codice"],
        actorNome: json["actor_nome"],
        refreshDate: json["refreshDate"],
      );
}
