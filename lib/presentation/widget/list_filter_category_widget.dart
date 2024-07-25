import 'package:flutter/material.dart';

import '../style/strings_app.dart';
import 'filter_categories_widget.dart';
import '../style/color.dart';

class ListFilterCategoryWidget  extends StatelessWidget {
  const ListFilterCategoryWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: StringsApp.listFilterCategories.length,
                            itemBuilder: (context, index) {
                              var category =
                                  StringsApp.listFilterCategories[index];
                              return FilterCategoriesWidget(
                                text: category,
                                colorBackground: AppTheme.secondaryColor,
                                fontWeight: FontWeight.normal,
                                textColor: Colors.black,
                              );
                            });
  }
}