import 'package:eats/model/Recipes.dart';
import 'package:flutter/material.dart';

class CardRecipeWidget extends StatelessWidget {
  final Recipes recipe;

  const CardRecipeWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              recipe.image,
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.infinity,
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
