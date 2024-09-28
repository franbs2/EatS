import 'dart:typed_data';

import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/args/recipe_arguments.dart';
import 'package:eats/presentation/providers/recipes_provider.dart';
import 'package:eats/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  Uint8List? imageBytes;
  RecipeArguments? args;

  // Variáveis para armazenar os valores iniciais
  String? initialName;
  String? initialCategory;
  String? initialDescription;
  String? initialValue;
  List<String> initialIngredients = [];
  List<String> initialSteps = [];

  void _uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final bytes = await image!.readAsBytes();
    setState(() {
      imageBytes = bytes; // Atualiza o estado com os bytes da imagem.
    });
  }

  Future<void> _createRecipe(RecipesRepository recipesRepository) async {
    double parsedValue = double.tryParse(_valueController.text) ?? 0.0;
    String? newImage;
    Recipes? recipe = args?.recipe;

    if (imageBytes != null) {
      if (recipe?.image != 'recipePics/default_recipe.jpg') {
        debugPrint("AuthMethods: trocando imagem do perfil no Storage");
        await StorageService()
            .replaceImageAtStorage(recipe!.image, imageBytes!);
      } else {
        debugPrint("AuthMethods: Adicionando imagem do perfil no Storage");
        await StorageService().uploadImageToStorage(
            'recipePics', "${recipe!.authorId}_${recipe.name}", imageBytes!);
        newImage = 'recipePics/${recipe.authorId}_${recipe.name}';
      }
    }

    String categoryText = _categoryController.text
        .replaceAll('Almoço', 'Almoco')
        .replaceAll('almoço', 'Almoco')
        .replaceAll('Café da Manhã', 'Cafe da Manha')
        .replaceAll('Café da manhã', 'Cafe da Manha');

    // Filtrar ingredientes e passos vazios
    List<String> ingredients = _controllersIngredients
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    List<String> steps = _controllersSteps
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    recipesRepository.saveRecipe(
      Recipes(
        id: recipe?.id ?? '',
        image: newImage ?? 'recipePics/default_recipe.jpg',
        description: _descriptionController.text,
        name: _nameController.text,
        category: categoryText.split(',').map((e) => e.trim()).toList(),
        ingredients: ingredients,
        steps: steps,
        rating: 0,
        value: parsedValue,
        authorId: recipe?.authorId ?? '',
        public: recipe?.public ?? false,
      ),
    );
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)?.settings.arguments as RecipeArguments?;
    final recipe = args?.recipe;

    if (recipe != null) {
      // Armazena os valores iniciais
      initialName = recipe.name;
      initialCategory = recipe.category.join(", ");
      initialDescription = recipe.description;
      initialValue = recipe.value.toString();
      initialIngredients = List.from(recipe.ingredients);
      initialSteps = List.from(recipe.steps);

      // Define os controladores com os valores da receita
      _nameController.text = initialName!;
      _categoryController.text = initialCategory!;
      _descriptionController.text = initialDescription!;
      _valueController.text = initialValue!;

      // Adiciona os controladores para ingredientes e passos
      _controllersIngredients.clear();
      for (var ingredient in initialIngredients) {
        _controllersIngredients.add(TextEditingController(text: ingredient));
      }

      _controllersSteps.clear();
      for (var step in initialSteps) {
        _controllersSteps.add(TextEditingController(text: step));
      }
    }
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
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
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
    final recipesProvider =
        Provider.of<RecipesProvider>(context, listen: false);
    final recipesRepository =
        Provider.of<RecipesRepository>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
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
                            Icons.arrow_back_ios,
                            color: Colors.black,
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
                              controller: _nameController,
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
                        const SizedBox(
                          width: 48,
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
                        child: UploadWidget(
                          height: 0.3,
                          backgroundImage: imageBytes,
                          ontap: _uploadImage, //),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: _categoryController,
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
                    TextFormField(
                      cursorColor: AppTheme.primaryColor,
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorErrorColor: AppTheme.primaryColor,
                      cursorColor: AppTheme.primaryColor,
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ingredientes Principais',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    ..._buildFieldList(_controllersIngredients, 'Ingrediente'),
                    const SizedBox(height: 24),
                    const Text(
                      'Modo de Preparo',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                        IconButton(
                          icon: const Icon(
                            Icons.refresh_rounded,
                            size: 28,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            // Restaura os valores iniciais dos campos simples
                            _nameController.text = initialName ?? '';
                            _categoryController.text = initialCategory ?? '';
                            _descriptionController.text =
                                initialDescription ?? '';
                            _valueController.text = initialValue ?? '';

                            // Restaurar controladores de ingredientes
                            _controllersIngredients.clear();
                            for (var ingredient in initialIngredients) {
                              _controllersIngredients
                                  .add(TextEditingController(text: ingredient));
                            }

                            // Restaurar controladores de passos
                            _controllersSteps.clear();
                            for (var step in initialSteps) {
                              _controllersSteps
                                  .add(TextEditingController(text: step));
                            }

                            setState(() {});
                          },
                        ),
                        ButtonDefaultlWidget(
                            text: StringsApp.save,
                            color: AppTheme.loginYellow,
                            width: 0.1 / 2,
                            height: 14,
                            onPressed: () {
                              _createRecipe(recipesRepository);
                              recipesProvider.fetchRecipes(null, null);
                              if (args?.isRecipeGenerated ?? false) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pop(true);
                              }
                            }),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                  labelStyle: const TextStyle(
                    color: AppTheme.searchBarColor,
                  ),
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
