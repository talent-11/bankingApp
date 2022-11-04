import 'package:flutter/material.dart';

class FotocSearchBar extends StatelessWidget {
  const FotocSearchBar(
    {
      Key? key,
      this.controller,
      required this.onPressedClear,
      required this.onChanged,
    }
  ) : super(key: key);
     
  final TextEditingController? controller;
  final Function onPressedClear;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) => onChanged(value),
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.search, size: 20, color: Colors.black),
                  width: 18,
                )
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onPressedClear();
            },
            child: const Icon(Icons.close, size: 20, color: Colors.black),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: Theme.of(context).primaryColor
            ),
          )
        ],
      );
  }
}
