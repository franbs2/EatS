import 'dart:typed_data';

import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/data/model/recipes.dart';
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
  Recipes? recipe;

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

    if (imageBytes != null) {
      if (recipe?.image != 'recipePics/default_recipe.jpg') {
        debugPrint("AuthMethods: trocando imagem do perfil no Storage");
        await StorageService()
            .replaceImageAtStorage(recipe!.image, imageBytes!);
      } else {
        debugPrint("AuthMethods: Adicionando imagem do perfil no Storage");
        await StorageService().uploadImageToStorage(
            'recipePics', "${recipe!.authorId}_${recipe!.name}", imageBytes!);
        newImage = 'recipePics/${recipe!.authorId}_${recipe!.name}';
      }
    }

    recipesRepository.saveRecipe(
      Recipes(
        id: recipe?.id ?? '',
        image: newImage ??
            'recipePics/default_recipe.jpg', // Update this if you have an image picker
        description: _descriptionController.text,
        name: _nameController.text,
        category:
            _categoryController.text.split(',').map((e) => e.trim()).toList(),
        ingredients: _controllersIngredients.map((e) => e.text).toList(),
        steps: _controllersSteps.map((e) => e.text).toList(),
        rating: 0,
        value: parsedValue,
        authorId: recipe?.authorId ?? '',
        public: recipe?.public ?? false,
      ),
    );
    // Additional actions after saving the recipe
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    recipe = ModalRoute.of(context)?.settings.arguments as Recipes?;

    if (recipe != null) {
      _nameController.text = recipe!.name;
      _categoryController.text = recipe!.category.join(", ");
      _descriptionController.text = recipe!.description;
      _valueController.text = recipe!.value.toString();
    }

    if (_controllersIngredients.isEmpty && recipe?.ingredients != null) {
      for (var ingredient in recipe!.ingredients) {
        _controllersIngredients.add(TextEditingController(text: ingredient));
      }
    } else {
      _addField(_controllersIngredients);
    }

    if (_controllersSteps.isEmpty && recipe?.steps != null) {
      for (var step in recipe!.steps) {
        _controllersSteps.add(TextEditingController(text: step));
      }
    } else {
      _addField(_controllersSteps);
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
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: UnderlineInputBorder(),
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
                              _createRecipe(recipesRepository);
                              recipesProvider.fetchRecipes(null);
                              Navigator.of(context).pop();
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
