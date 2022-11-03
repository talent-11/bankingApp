import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField(
      {Key? key, this.enabled, this.labelText, this.hintText, this.obscureText, this.keyboardType, this.validator, this.onSaved, this.onChanged})
      : super(key: key);

  final bool? enabled;
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  List<Widget> decorate(BuildContext context) {
    var widget = <Widget>[];

    if (labelText != null) {
      widget.add(Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(labelText!, style: Theme.of(context).textTheme.bodyText2)));
    }

    widget.add(TextFormField(
      enabled: enabled,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText1,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0)),
    ));

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: decorate(context)));
  }
}
