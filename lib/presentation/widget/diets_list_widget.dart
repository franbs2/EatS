import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

class DietsListWidget extends StatelessWidget {
  const DietsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de dietas mockada
    final List<String> dietas = [
      'Vegetariana',
      'Vegana',
      'Low Carb',
      'Cetogênica',
      'Sem Glúten',
      'Sem Lactose'
    ];
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
              'Selecione suas dietas',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ...dietas.map((diet) => CheckboxListTile(
                checkColor: AppTheme.secondaryColor,
                activeColor: AppTheme.primaryColor,
                title: Text(
                  diet,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                value: preferencesProvider.selectedDiets.contains(diet),
                onChanged: (bool? newValue) {
                  preferencesProvider.toggleDiet(diet);
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
                onPressed: () async {
                  preferencesProvider.saveDiets();
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
