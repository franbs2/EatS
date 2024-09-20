import 'package:flutter/material.dart';

import '../../core/style/color.dart';
import '../../core/style/strings_app.dart';
import '../widget/button_default_widget.dart';
import '../widget/upload_widget.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final List<TextEditingController> _controllersIngredients = [];
  final List<TextEditingController> _controllersSteps = [];

  @override
  void initState() {
    super.initState();
    _addField(_controllersSteps);
    _addField(_controllersIngredients);
  }

  void _addField(List<TextEditingController> controllers) {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void _removeField(int index, List<TextEditingController> controllers) {
    if (controllers.length > 1) {
      setState(() {
        controllers.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllersIngredients) {
      controller.dispose();
    }
    for (final controller in _controllersSteps) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Nome da receita',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 28,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        onPressed: () {
                          // Função do botão de salvar
                        },
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 4),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: UploadWidget(height: 0.3, ontap: () {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Adicionar tag',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Ingredientes Principais',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ..._buildFieldList(_controllersIngredients, 'Ingrediente'),
                  const SizedBox(height: 24),
                  const Text(
                    'Modo de Preparo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ..._buildFieldList(_controllersSteps, 'Passo'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.undo, color: Color(0xffB2B2B2)),
                          SizedBox(width: 8),
                          Icon(Icons.redo, color: Color(0xffB2B2B2)),
                          SizedBox(width: 8),
                        ],
                      ),
                      ButtonDefaultlWidget(
                        text: StringsApp.save,
                        color: AppTheme.loginYellow,
                        width: 0.1 / 2,
                        height: 14,
                        onPressed: () {
                          // Ação ao salvar a receita
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFieldList(
      List<TextEditingController> controllers, String label) {
    return List.generate(
      controllers.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controllers[index],
                decoration: InputDecoration(
                  labelText: '$label ${index + 1}',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            if (index == controllers.length - 1)
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: Colors.green, size: 28),
                onPressed: () => _addField(controllers),
              )
            else
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 28),
                onPressed: () => _removeField(index, controllers),
              ),
          ],
        ),
      ),
    );
  }
}
