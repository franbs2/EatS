class Recipes {
  final String name;
  final List<String> category;
  final String image;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;
  final double value;

  Recipes({
    required this.image,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.name,
    required this.category,
    required this.rating,
    required this.value,
  });
}
