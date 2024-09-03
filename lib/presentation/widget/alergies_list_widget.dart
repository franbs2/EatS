import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

class AllergiesListWidget extends StatelessWidget {
  const AllergiesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de alergias mockada
    final allergies = ['Amendoim', 'Leite', 'Ovos', 'Peixes', 'Nozes', 'Soja'];
    final preferencesProvider = Provider.of<PreferencesProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              'Selecione suas alergias',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ...allergies.map((allergy) => CheckboxListTile(
                checkColor: AppTheme.secondaryColor,
                activeColor: AppTheme.primaryColor,
                title: Text(
                  allergy,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                value: preferencesProvider.selectedAllergies.contains(allergy),
                onChanged: (bool? newValue) {
                  preferencesProvider.toggleAllergy(allergy);
                },
              )),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color.fromARGB(255, 229, 85, 74),
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  )),
              TextButton(
                onPressed: () {
                  preferencesProvider.saveAllergies(context);
                  Navigator.of(context).pop();
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
