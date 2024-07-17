class AuthState {
  const AuthState({
    this.username = "",
    this.password = "",
  });

  final String username;
  final String password;

  AuthState copyWith({
    String? username,
    String? password,
  }) {
    return AuthState(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
