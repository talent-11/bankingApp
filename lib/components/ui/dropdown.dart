import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class FotocDropdown extends StatelessWidget {
  const FotocDropdown(
    {
      Key? key,
      this.buttonWidth,
      required this.placeholder,
      required this.list,
      this.selectedValue,
      this.onChanged,
    }
  ) : super(key: key);
  
  final double? buttonWidth;
  final String placeholder;
  final List<String> list;
  final String? selectedValue;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: Text(placeholder, style: Theme.of(context).textTheme.bodyText1)),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                // isExpanded: true,
                hint: const Text("Select an item", style: TextStyle(fontSize: 14.0, color: Color(0xff252631))),
                items: list.map((item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14.0, color: Color(0xff252631))),
                  )).toList(),
                value: selectedValue,
                onChanged: (value) => onChanged!(value),
                buttonWidth: buttonWidth,
              )
            )
          ],
        )
      )
    );
  }
}
