import 'dart:ffi';
import 'dart:typed_data';

import 'package:eats/core/utils/utils.dart';
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widget/alergies_list_widget.dart';
import '../widget/button_default_widget.dart';
import '../widget/diets_list_widget.dart';
import '../widget/location_widget.dart';
import '../widget/preference_options_widget.dart';
import '../widget/text_username_input_widget.dart';
import '../widget/upload_widget.dart';
import '../../core/style/color.dart';

class EditPerfilPage extends StatefulWidget {
  EditPerfilPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();

  @override
  State<EditPerfilPage> createState() => _EditPerfilPageState();
}

class _EditPerfilPageState extends State<EditPerfilPage> {
  Uint8List? imageBytes;

  void _uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final bytes = await image!.readAsBytes();
    setState(() {
      imageBytes = bytes;
    });
    debugPrint("bytes: $bytes");
    debugPrint("imageBytes: $imageBytes");
  }

  @override
  void dispose() {
    debugPrint("EditPerfilPage: Disposing...");
    imageBytes = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileImage = userProvider.profileImage;
    bool arrowBack =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                UploadWidget(
                  backgroundImage: imageBytes ?? profileImage,
                  ontap: _uploadImage,
                ),
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
                          onPressed: () => Navigator.pop(context),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.47,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LocationWidget(),
                        Form(
                          key: widget._formKey,
                          child: TextUsernameInputWidget(
                            controller: widget.username,
                          ),
                        ),
                        const SizedBox(height: 18),
                        PreferenceOptionsWidget(
                          title: 'Alergias',
                          onTap: () => _showAllergiesModal(context),
                        ),
                        const SizedBox(height: 18),
                        PreferenceOptionsWidget(
                          title: 'Dietas',
                          onTap: () => _showDietsModal(context),
                        ),
                        const SizedBox(height: 18),
                        PreferenceOptionsWidget(
                          title: 'Preferências',
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonDefaultlWidget(
                              text: 'Salvar',
                              width: 0.1,
                              height: 16,
                              color: AppTheme.perfilYellow,
                              onPressed: () async {
                                if (userProvider.user!.onboarding) {
                                  try {
                                    await AuthMethods().updateUserProfile(
                                      username: widget.username.text,
                                      file: imageBytes,
                                      context: context,
                                    );
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  } catch (e) {
                                    showSnackBar(e.toString(), context);
                                  }
                                } else {
                                  if (widget.username.text.isNotEmpty) {
                                    try {
                                      await AuthMethods().updateUserProfile(
                                        username: widget.username.text,
                                        file: imageBytes,
                                        context: context,
                                        onboarding: true,
                                      );
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } catch (e) {
                                      showSnackBar(e.toString(), context);
                                    }
                                  } else {
                                    showSnackBar(
                                        "Preencha o nome de usuário", context);
                                  }
                                }
                              },
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
    );
  }

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
}
