enum SignInMethod { username, email }

class UserCredentials {
  const UserCredentials({
    required this.username,
    required this.email,
    required this.password,
    required this.signInMethod,
  });

  final String username;
  final String email;
  final String password;
  final SignInMethod signInMethod;

  String get activeIdentifier =>
      signInMethod == SignInMethod.email ? email : username;

  UserCredentials copyWith({
    String? username,
    String? email,
    String? password,
    SignInMethod? signInMethod,
  }) {
    return UserCredentials(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      signInMethod: signInMethod ?? this.signInMethod,
    );
  }
}
