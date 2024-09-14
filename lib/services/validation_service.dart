class ValidationService {
  void validateSignUpFields(
      String email, String password, String confirmPassword) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception('Por favor, preencha todos os campos.');
    }
    if (password != confirmPassword) {
      throw Exception('As senhas não coincidem.');
    }
    // Outras validações...
  }
}
