class WeakPasswordException implements Exception {
  final String message;
  WeakPasswordException([this.message = 'A senha deve ter pelo menos 6 caracteres.']);
  @override
  String toString() => message;
}

class InvalidEmailException implements Exception {
  final String message;
  InvalidEmailException([this.message = 'O endereço de email possui um formato inválido.']);
  @override
  String toString() => message;
}

class PasswordsDoNotMatchException implements Exception {
  final String message;
  PasswordsDoNotMatchException([this.message = 'As senhas não coincidem.']);
  @override
  String toString() => message;
}

class GenericAuthException implements Exception {
  final String message;
  GenericAuthException([this.message = 'Ocorreu um erro durante o registro.']);
  @override
  String toString() => message;
}
