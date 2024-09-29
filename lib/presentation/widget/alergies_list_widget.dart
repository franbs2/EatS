import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

/// Um widget que exibe uma lista de opções de alergias com caixas de seleção.
///
/// O [AllergiesListWidget] permite que os usuários selecionem suas alergias
/// a partir de uma lista predefinida. Utiliza o [PreferencesProvider] para
/// gerenciar o estado das seleções e para salvar as preferências do usuário.
class AllergiesListWidget extends StatelessWidget {
  /// Cria uma instância do widget [AllergiesListWidget].

  const AllergiesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de alergias disponíveis para seleção.
    const List<String> allergies = StringsApp.listAllergies;

    // Obtém o provedor de preferências do contexto.
    final preferencesProvider = Provider.of<PreferencesProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cabeçalho com título.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              StringsApp.selectAllergies,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Gera uma lista de CheckboxListTile a partir da lista de alergias.
          ...allergies.map((allergy) => CheckboxListTile(
                checkColor: AppTheme.secondaryColor,
                activeColor: AppTheme.primaryColor,
                title: Text(
                  allergy,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: preferencesProvider.selectedAllergies.contains(allergy),
                onChanged: (bool? newValue) {
                  // Alterna a seleção da alergia quando o usuário marca/desmarca.
                  preferencesProvider.toggleAllergy(allergy);
                },
              )),
          const SizedBox(height: 16),
          // Botões para cancelar ou salvar a seleção.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão para cancelar e voltar para a tela anterior.
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  StringsApp.cancel,
                  style: TextStyle(
                    color: AppTheme.atencionRed,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
              // Botão para salvar as seleções e voltar para a tela anterior.
              TextButton(
                onPressed: () {
                  // Salva as alergias selecionadas e fecha o modal.
                  preferencesProvider.saveAllergies(context);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  StringsApp.save,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
