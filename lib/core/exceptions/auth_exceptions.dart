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

class EmailPassException implements Exception {
  final String message;
  EmailPassException([this.message = 'Email ou senha inválidos.']);
  @override
  String toString() => message;
}

class LogOutException implements Exception {
  final String message;
  LogOutException([this.message = 'Ocorreu um erro ao sair.']);
  @override
  String toString() => message;
}

class EmailAlreadyInUseException implements Exception {
  final String message;
  EmailAlreadyInUseException([this.message = 'O email informado está em uso.']);
  @override
  String toString() => message;
}

class UsernameAlreadyInUseException implements Exception {
  final String message;
  UsernameAlreadyInUseException([this.message = 'Esse nome de usuário já está em uso.']);
  @override
  String toString() => message;
}

class InvalidTooShortException implements Exception {
  final String message;
  InvalidTooShortException([this.message = 'O nome de usuário deve ter mais de 2 caracteres.']);
  @override
  String toString() => message;
}

class UsernameTooLongException implements Exception {
  final String message;
  UsernameTooLongException([this.message = 'O nome de usuário deve ter menos de menos 20 caracteres.']);
  @override
  String toString() => message;
}

class InvalidUsernameException implements Exception {
  final String message;
  InvalidUsernameException([this.message = 'O nome de usuário deve conter apenas letras, números e traços.']);
  @override
  String toString() => message;
}