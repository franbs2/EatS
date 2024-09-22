import 'package:eats/core/routes/routes.dart';
import 'package:eats/presentation/widget/load_screen_widget.dart';
import 'package:eats/presentation/widget/text_password_input_widget.dart';
import 'package:eats/presentation/widget/text_widget.dart';
import 'package:eats/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../core/style/strings_app.dart';
import '../widget/button_default_widget.dart';
import '../widget/button_google_widget.dart';
import '../widget/continue_with_widget.dart';
import '../widget/page_default_auth.dart';
import '../widget/text_button_have_account_widget.dart';
import '../widget/title_initial_widget.dart';
import '../../core/style/color.dart';

/// [LoginPage] do aplicativo.
///
/// Esta página permite que os usuários façam login usando seu e-mail e senha, ou através do Google. Inclui
/// validação de formulário e manipulação de erros. Durante o login, uma tela de carregamento é exibida.
class LoginPage extends StatefulWidget {
  // Construtor da classe LoginPage.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Chave global para o formulário, usada para validar o estado do formulário.
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para os campos de entrada de e-mail e senha.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Instância do AuthService para realizar operações de autenticação.
  final AuthService _authService = AuthService();

  // Variável para controlar o estado de carregamento.
  bool _isLoading = false;

  /// Método para fazer login do usuário.
  ///
  /// Este método valida o formulário, mostra a tela de carregamento, tenta autenticar o usuário com o AuthService, e exibe uma mensagem
  /// de sucesso ou erro com base no resultado da operação.
  ///
  /// @param [context] O contexto do Build, usado para exibir mensagens e navegar entre páginas.
  void _loginUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Inicia o estado de carregamento.
      });
      try {
        // Tenta fazer login do usuário usando o e-mail e senha fornecidos.
        await _authService.loginUser(
          email: _emailController.text,
          password: _senhaController.text,
        );

        // Exibe uma mensagem de sucesso se a autenticação for bem-sucedida.
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário conectado com sucesso!')),
          );
        }
      } catch (e) {
        // Exibe uma mensagem de erro se a autenticação falhar.
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        setState(() {
          _isLoading = false; // Encerra o estado de carregamento.
        });
      }
    }
  }

  @override
  void dispose() {
    // Descarta os controladores quando o widget é removido da árvore de widgets.
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadScreenWidget();
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            PageDefaultAuth(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          8), // Adiciona padding horizontal ao conteúdo.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12), // Espaçamento superior.
                      const TitleInitialWidget(
                        title: StringsApp
                            .welcomeLogin, // Título da página de login.
                        subtitle:
                            StringsApp.happy, // Subtítulo da página de login.
                        space: 8.0, // Espaçamento entre o título e o subtítulo.
                      ),
                      const SizedBox(height: 32), // Espaçamento vertical.
                      const ButtonGoogleWidget(), // Botão para login com Google.
                      const SizedBox(height: 32), // Espaçamento vertical.
                      const ContinueWithWidget(), // Widget para opções adicionais de login.
                      const SizedBox(height: 40), // Espaçamento vertical.
                      Form(
                        key:
                            _formKey, // Atribui a chave global ao formulário para validação.
                        child: Column(
                          children: [
                            TextInputWidget(
                              hint: StringsApp
                                  .email, // Texto de sugestão para o campo de e-mail.
                              controller:
                                  _emailController, // Controlador para o campo de e-mail.
                              validator: (value) {
                                // Valida o campo de e-mail.
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu email'; // Mensagem de erro se o campo estiver vazio.
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40), // Espaçamento vertical.
                            TextPasswordInputWidget(
                              hint: StringsApp
                                  .password, // Texto de sugestão para o campo de senha.
                              controller:
                                  _senhaController, // Controlador para o campo de senha.
                              validator: (value) {
                                // Valida o campo de senha.
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira sua senha'; // Mensagem de erro se o campo estiver vazio.
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48), // Espaçamento vertical.
                      TextButtonHaveAccountWidget(
                        onPressed: () => Navigator.of(context).pushNamed(RoutesApp
                            .registerPage), // Navega para a página de registro.
                        title: StringsApp
                            .dontHaveAccount, // Texto do botão de texto.
                      ),
                      const SizedBox(height: 24), // Espaçamento vertical.
                      ButtonDefaultlWidget(
                        text: StringsApp.login, // Texto do botão de login.
                        color: AppTheme.loginYellow, // Cor do botão de login.
                        onPressed: () {
                          _loginUser(
                              context); // Chama o método de login ao pressionar o botão.
                        },
                      ),
                      const SizedBox(
                        height: 16, // Espaçamento inferior.
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
