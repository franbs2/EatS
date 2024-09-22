import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/widget/button_google_widget.dart';
import 'package:eats/presentation/widget/continue_with_widget.dart';
import 'package:eats/presentation/widget/page_default_auth.dart';
import 'package:eats/presentation/widget/text_widget.dart';
import 'package:eats/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/routes.dart';
import '../../core/style/color.dart';

import '../widget/button_default_widget.dart';
import '../widget/text_button_have_account_widget.dart';
import '../widget/text_password_input_widget.dart';
import '../widget/title_initial_widget.dart';

/// Página de registro do usuário. Permite que o usuário se registre fornecendo email e senha.
///
/// A [RegisterPage] é composta por um formulário de registro, com campos para email, senha e confirmação de senha.
/// Além disso, fornece opções de login com Google, e links para a página de login existente.
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Chave global para o formulário. Usada para validar e acessar o estado do formulário.
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto de email, senha e confirmação de senha.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  // Instância do provedor de métodos de autenticação.
  final AuthService _authService = AuthService();

  /// Função responsável por registrar o usuário.
  ///
  /// Valida o formulário e, se válido, tenta registrar o usuário utilizando o provedor de autenticação.
  /// Exibe mensagens de sucesso ou erro usando SnackBars.
  ///
  /// @param [context] O contexto da build atual.
  void _registerUser(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      try {
        // Tenta registrar o usuário.
        await _authService.signUpUser(
          email: _emailController.text,
          password: _senhaController.text,
        );
        if (context.mounted) {
          // Exibe uma mensagem de sucesso após o registro bem-sucedido.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário registrado com sucesso!')),
          );
        }
        _authService.loginUser(
          email: _emailController.text,
          password: _senhaController.text,
        );
        userProvider.refreshUser();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          // Exibe uma mensagem de erro caso algo dê errado durante o registro.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PageDefaultAuth(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                const TitleInitialWidget(
                  title: StringsApp.welcome, // Texto de boas-vindas.
                  subtitle: StringsApp.happy, // Subtítulo de boas-vindas.
                  space: 8.0,
                ),
                const SizedBox(height: 24),
                const ButtonGoogleWidget(), // Widget para login com Google.
                const SizedBox(height: 24),
                const ContinueWithWidget(), // Widget para continuar com opções adicionais.
                const SizedBox(height: 36),
                Form(
                  key: _formKey, // Define a chave do formulário para validação.
                  child: Column(children: [
                    TextInputWidget(
                      hint: StringsApp
                          .labelEmail, // Texto de sugestão para o campo de email.
                      controller:
                          _emailController, // Controlador para o campo de email.
                      validator: (value) {
                        // Função de validação para o campo de email.
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email'; // Mensagem de erro caso o campo esteja vazio.
                        }
                        return null; // Retorna nulo se a validação for bem-sucedida.
                      },
                    ),
                    const SizedBox(height: 40),
                    TextPasswordInputWidget(
                      hint: StringsApp
                          .labelPassword, // Texto de sugestão para o campo de senha.
                      controller:
                          _senhaController, // Controlador para o campo de senha.
                      validator: (value) {
                        // Função de validação para o campo de senha.
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha'; // Mensagem de erro caso o campo esteja vazio.
                        }
                        return null; // Retorna nulo se a validação for bem-sucedida.
                      },
                    ),
                    const SizedBox(height: 40),
                    TextPasswordInputWidget(
                      hint: StringsApp
                          .labelConfirmPassword, // Texto de sugestão para o campo de confirmação de senha.
                      controller:
                          _confirmarSenhaController, // Controlador para o campo de confirmação de senha.
                      validator: (value) {
                        // Função de validação para o campo de confirmação de senha.
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme sua senha'; // Mensagem de erro caso o campo esteja vazio.
                        }
                        return null; // Retorna nulo se a validação for bem-sucedida.
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                TextButtonHaveAccountWidget(
                  onPressed: () => Navigator.of(context).pushNamed(
                      RoutesApp.loginPage), // Navega para a página de login.
                  title: StringsApp
                      .haveAccount, // Texto do botão para usuários que já possuem uma conta.
                ),
                const SizedBox(height: 10),
                ButtonDefaultlWidget(
                  text: StringsApp.register, // Texto do botão de registro.
                  color: AppTheme.loginYellow, // Cor do botão de registro.
                  onPressed: () => _registerUser(
                      context), // Função chamada ao pressionar o botão.
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RoutesApp.termsOfUsePage);
                  },
                  child: const Text(
                    'Ao registrar-se, você concorda com nossos Termos de Uso e Política de Privacidade.',
                    style: TextStyle(
                      color: AppTheme.atencionRed,
                      fontSize: 12,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
