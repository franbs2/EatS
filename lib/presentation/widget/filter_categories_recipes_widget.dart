import 'package:eats/presentation/style/color.dart';
import 'package:flutter/material.dart';

class FilterCategoriesRecipesWidget extends StatefulWidget {
  final List<String> categories;
  
  const FilterCategoriesRecipesWidget({super.key, required this.categories});

  @override
  State<FilterCategoriesRecipesWidget> createState() => _FilterCategoriesRecipesWidgetState();
}

class _FilterCategoriesRecipesWidgetState extends State<FilterCategoriesRecipesWidget> {
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: widget.categories
                          .map((category) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FilterChip(
                                  selectedColor: AppTheme.primaryColor,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  backgroundColor: AppTheme.secondaryColor,
                                  showCheckmark: false,
                                  label: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedCategory == category
                                          ? Colors.white
                                          : const Color(0xff2F4B4E),
                                    ),
                                  ),
                                  selected: _selectedCategory == category,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      //logica temporaria para teste de seleção de categoria
                                      _selectedCategory =
                                          selected ? category : null;
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
  }
}