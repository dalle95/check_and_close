abstract class AuthEvent {
  const AuthEvent();
}

class UsernameEvent extends AuthEvent {
  final String username;
  const UsernameEvent(this.username);
}

class PasswordEvent extends AuthEvent {
  final String password;
  const PasswordEvent(this.password);
}
