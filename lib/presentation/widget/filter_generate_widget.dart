import 'package:flutter/material.dart';
import '../../core/style/color.dart';

class FilterGenerateWidget extends StatefulWidget {
  final String title;
  final List<String> listFilter;
  final Function(String) onSelected;

  const FilterGenerateWidget({
    super.key,
    required this.listFilter,
    required this.title,
    required this.onSelected,
  });

  @override
  State<FilterGenerateWidget> createState() => _FilterGenerateWidgetState();
}

class _FilterGenerateWidgetState extends State<FilterGenerateWidget> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.listFilter.isNotEmpty ? widget.listFilter[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.listFilter.map((filter) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selectedColor: AppTheme.loginYellow,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                  label: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 16,
                      color: _selected == filter
                          ? Colors.white
                          : const Color(0xff2F4B4E),
                    ),
                  ),
                  selected: _selected == filter,
                  onSelected: (selected) {
                    setState(() {
                      _selected = selected ? filter : null;
                    });
                    widget.onSelected(_selected ?? '');
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
