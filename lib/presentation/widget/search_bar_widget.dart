import 'package:eats/presentation/style/color.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.searchBarColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.search, color: AppTheme.secondaryColor),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Procurar',
                hintStyle: TextStyle(color: AppTheme.textInitial),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: AppTheme.secondaryColor,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.filterSearchBarColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
