import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

/// Um widget que exibe uma lista de opções de restrições alimentares com caixas de seleção.
///
/// O [CustomAllergiesListWidget] permite que os usuários selecionem suas restrições
/// alimentares a partir de uma lista predefinida.
class CustomAllergiesListWidget extends StatefulWidget {
  const CustomAllergiesListWidget({super.key});

  @override
  State<CustomAllergiesListWidget> createState() => _CustomAllergiesListWidgetState();
}

/// Estado do [CustomAllergiesListWidget].
class _CustomAllergiesListWidgetState extends State<CustomAllergiesListWidget> {
  /// Conjunto de restrições selecionadas pelo usuário.
  Set<String> selectedRestrictions = {};

  @override
  Widget build(BuildContext context) {
    const List<String> restrictions = StringsApp.listAllergies;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              'Selecione as Restrições Alimentares',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...restrictions.map((restriction) => CheckboxListTile(
                checkColor: AppTheme.secondaryColor,
                activeColor: AppTheme.primaryColor,
                title: Text(
                  restriction,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: selectedRestrictions.contains(restriction),
                onChanged: (bool? newValue) {
                  setState(() {
                    if (newValue == true) {
                      selectedRestrictions.add(restriction);
                    } else {
                      selectedRestrictions.remove(restriction);
                    }
                  });
                },
              )),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o modal sem retornar dados
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppTheme.atencionRed,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedRestrictions.toList());
                },
                child: const Text(
                  'Salvar',
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

