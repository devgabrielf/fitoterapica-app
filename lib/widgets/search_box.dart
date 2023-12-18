import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final void Function(String) onChanged;

  const SearchBox({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.shade300,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.green, // Assuming tdBlack is a color variable
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Pesquisar',
          hintStyle: TextStyle(
              color: Colors.grey), // Assuming tdGrey is a color variable
        ),
      ),
    );
  }
}
