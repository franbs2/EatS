/// [WeakPasswordException] - Exceção para caso a senha seja muito fraca.
class WeakPasswordException implements Exception {
  final String message;
  WeakPasswordException(
      [this.message = 'A senha deve ter pelo menos 6 caracteres.']);
  @override
  String toString() => message;
}

/// [InvalidEmailException] - Exceção para caso o email seja inválido.
class InvalidEmailException implements Exception {
  final String message;
  InvalidEmailException(
      [this.message = 'O endereço de email possui um formato inválido.']);
  @override
  String toString() => message;
}

/// [PasswordsDoNotMatchException] - Exceção para caso as senhas não sejam iguais.
class PasswordsDoNotMatchException implements Exception {
  final String message;
  PasswordsDoNotMatchException([this.message = 'As senhas não coincidem.']);
  @override
  String toString() => message;
}

/// [GenericAuthException] - Exceção genérica para erros de autenticação.
class GenericAuthException implements Exception {
  final String message;
  GenericAuthException([this.message = 'Ocorreu um erro durante o registro.']);
  @override
  String toString() => message;
}

/// [EmailPassException] - Exceção para caso o email ou senha sejam inválidos.
class EmailPassException implements Exception {
  final String message;
  EmailPassException([this.message = 'Email ou senha inválidos.']);
  @override
  String toString() => message;
}

/// [LogOutException] - Exceção para caso o usuário seja deslogado.
class LogOutException implements Exception {
  final String message;
  LogOutException([this.message = 'Ocorreu um erro ao sair.']);
  @override
  String toString() => message;
}

/// [EmailAlreadyInUseException] - Exceção para caso o email seja inválido.
class EmailAlreadyInUseException implements Exception {
  final String message;
  EmailAlreadyInUseException([this.message = 'O email informado está em uso.']);
  @override
  String toString() => message;
}

/// [UsernameAlreadyInUseException] - Exceção para caso o username já exista.
class UsernameAlreadyInUseException implements Exception {
  final String message;
  UsernameAlreadyInUseException(
      [this.message = 'Esse nome de usuário já está em uso.']);
  @override
  String toString() => message;
}

/// [InvalidTooShortException] - Exceção para caso o username seja pequeno.
class InvalidTooShortException implements Exception {
  final String message;
  InvalidTooShortException(
      [this.message = 'O nome de usuário deve ter pelo menos 5 caracteres.']);
  @override
  String toString() => message;
}

/// [UsernameTooLongException] - Exceção para caso o username seja grande.
class UsernameTooLongException implements Exception {
  final String message;
  UsernameTooLongException(
      [this.message =
          'O nome de usuário deve ter menos de menos 20 caracteres.']);
  @override
  String toString() => message;
}

/// [InvalidUsernameException] - Exceção para caso o username tenha caracteres inválidos.
class InvalidUsernameException implements Exception {
  final String message;
  InvalidUsernameException(
      [this.message =
          'O nome de usuário deve conter apenas letras, números e traços.']);
  @override
  String toString() => message;
}
