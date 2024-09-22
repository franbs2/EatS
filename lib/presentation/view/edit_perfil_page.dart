import 'dart:typed_data';

import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/widget/load_screen_widget.dart';
import 'package:eats/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../../core/utils/utils.dart';
import '../widget/alergies_list_widget.dart';
import '../widget/button_default_widget.dart';
import '../widget/diets_list_widget.dart';
import '../widget/location_widget.dart';
import '../widget/preference_options_widget.dart';
import '../widget/text_username_input_widget.dart';
import '../widget/upload_widget.dart';
import '../providers/user_provider.dart';

/// A [EditPerfilPage] é uma página para editar o perfil do usuário.
/// Permite ao usuário atualizar sua imagem de perfil, nome de usuário, e preferências.
class EditPerfilPage extends StatefulWidget {
  EditPerfilPage({super.key});

  // Chave global para o formulário, usada para validação.
  final _formKey = GlobalKey<FormState>();

  // Controlador para o campo de nome de usuário.
  final TextEditingController username = TextEditingController();

  @override
  State<EditPerfilPage> createState() => _EditPerfilPageState();
}

class _EditPerfilPageState extends State<EditPerfilPage> {
  // Armazena os bytes da imagem selecionada pelo usuário.
  Uint8List? imageBytes;
  bool _isLoading = false;

  /// Carrega uma imagem da galeria do dispositivo e a converte em bytes.
  void _uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final bytes = await image!.readAsBytes();
    setState(() {
      imageBytes = bytes; // Atualiza o estado com os bytes da imagem.
    });
  }

  /// Método chamado quando o widget é removido da árvore de widgets.
  @override
  void dispose() {
    debugPrint(
        "EditPerfilPage: Disposing..."); // Mensagem de depuração ao descartar o widget.
    imageBytes = null; // Limpa a imagem carregada ao sair da tela.
    super.dispose();
  }

  /// Inicia o nome de usuário com o valor do provedor.
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.username != null) {
      widget.username.text = userProvider.user!.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadScreenWidget();
    }

    // Acesso ao provedor de dados do usuário.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileImage = userProvider.profileImage;

    // Verifica se a seta de voltar deve ser exibida.
    bool arrowBack =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor, // Cor de fundo da página.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Widget para fazer o upload da imagem de perfil.
                  UploadWidget(
                    backgroundImage: imageBytes ?? profileImage,
                    ontap:
                        _uploadImage, // Função chamada ao tocar na área de upload.
                  ),
                  // Exibe o botão de voltar se necessário.
                  if (arrowBack)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 28,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            onPressed: () => Navigator.pop(
                                context), // Volta para a página anterior.
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  // Conteúdo da página principal de edição do perfil.
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.47,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LocationWidget(), // Widget de localização.
                          Form(
                            key: widget
                                ._formKey, // Chave do formulário para validação.
                            child: TextUsernameInputWidget(
                              controller: widget
                                  .username, // Controlador para o campo de nome de usuário.
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Botão para selecionar alergias.
                          PreferenceOptionsWidget(
                            title: 'Alergias',
                            onTap: () => _showAllergiesModal(context),
                            subtitle: StringsApp.add,
                          ),
                          const SizedBox(height: 18),
                          // Botão para selecionar dietas.
                          PreferenceOptionsWidget(
                            title: 'Dietas',
                            onTap: () => _showDietsModal(context),
                            subtitle: StringsApp.add,
                          ),
                          const SizedBox(height: 20),
                          // Botão para salvar as alterações do perfil.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonDefaultlWidget(
                                text: 'Salvar',
                                width: 0.1,
                                height: 16,
                                color: AppTheme.perfilYellow,
                                onPressed: () =>
                                    _updateProfile(context, userProvider),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Exibe o modal de seleção de alergias.
  void _showAllergiesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 50,
      backgroundColor: AppTheme.secondaryColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.0)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SingleChildScrollView(child: AllergiesListWidget()),
        );
      },
    );
  }

  /// Exibe o modal de seleção de dietas.
  void _showDietsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 50,
      backgroundColor: AppTheme.secondaryColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.0)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SingleChildScrollView(child: DietsListWidget()),
        );
      },
    );
  }

  void _updateProfile(BuildContext context, UserProvider userProvider) async {
    if (userProvider.user!.onboarding) {
      // Atualiza o perfil do usuário se estiver na fase de onboarding.
      try {
        setState(() {
          _isLoading = true;
        });

        await UserService().updateUserProfile(
          username: widget.username.text,
          file: imageBytes,
        );
        // Chama refreshUser para atualizar o estado do UserProvider
        await userProvider.refreshUser();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          showSnackBar(e.toString(), context); // Exibe uma mensagem de erro.
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (widget.username.text.isNotEmpty) {
        try {
          setState(() {
            _isLoading = true;
          });

          await UserService().updateUserProfile(
            username: widget.username.text,
            file: imageBytes,
            onboarding: true,
          );

          await userProvider.refreshUser();
        } catch (e) {
          if (context.mounted) {
            showSnackBar(e.toString(), context); // Exibe uma mensagem de erro.
          }
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        showSnackBar("Preencha o nome de usuário",
            context); // Solicita que o nome de usuário seja preenchido.
      }
    }
  }
}
