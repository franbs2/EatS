import 'package:eats/data/model/recipes.dart';
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:flutter/material.dart';

class CardRecipeWidget extends StatelessWidget {
  final Recipes recipe;

  const CardRecipeWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final StorageMethods storageMethods = StorageMethods();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FutureBuilder<String>(
              future: storageMethods
                  .loadImageAtStorage(recipe.image), // Use a função loadImage
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(child: Text('Erro ao carregar imagem')),
                  );
                } else {
                  return Image.network(
                    snapshot.data ?? '',
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: double.infinity,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff2F2D2C),
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffB7B7B7),
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Text(
                  'R\$ ${recipe.value.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff2F2D2C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
