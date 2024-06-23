import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final Function(String) onSearch;

  SearchSection({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                )),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.search_outlined,
                size: 30,
              ),
              onPressed: () {
                onSearch(searchController.text);
                searchController.clear();
              },
            ),
            hintText: "Search",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.7),
            )),
      ),
    );
  }
}
