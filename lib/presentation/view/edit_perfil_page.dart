import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart'; // Importe o PreferencesProvider
import '../widget/alergies_list_widget.dart';
import '../widget/button_default_widget.dart';
import '../widget/diets_list_widget.dart';
import '../widget/location_widget.dart';
import '../widget/preference_options_widget.dart';
import '../widget/text_username_input_widget.dart';
import '../widget/upload_widget.dart';
import '../../core/style/color.dart';

class EditPerfilPage extends StatelessWidget {
  const EditPerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreferencesProvider(),
      child: Scaffold(
        backgroundColor: AppTheme.secondaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  UploadWidget(
                    ontap: () {},
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
                              title: 'Preferências', onTap: () => ()),
                          const SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonDefaultlWidget(
                                  text: 'Salvar',
                                  width: 0.1,
                                  height: 16,
                                  color: AppTheme.perfilYellow,
                                  onPressed: () {},
                                ),
                              ])
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

  //  Função para exibir o modal de dietas
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

  // // Função para exibir o modal de preferências
  // void _showPreferencesModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //     ),
  //     builder: (context) {
  //       return const PreferencesListWidget();
  //     },
  //   );
  // }
}
