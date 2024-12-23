// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class EqEmailField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final bool? isobsecureText;
  final bool readOnly;
  final String? obsecureCharacter;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final int? length;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingCompleted;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;
  final List? selValue;

  const EqEmailField(
      {super.key,
      this.length,
      this.enabled,
      this.focusNode,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.textInputAction,
      this.onEditingCompleted,
      this.readOnly = false,
      this.textAlign = TextAlign.start,
      this.selValue,
      this.onTap,
      this.onChanged,
      required this.controller,
      required this.hintText,
      required this.labelText,
      this.autofocus = false,
      this.isobsecureText = false,
      this.obsecureCharacter = '*',
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.sentences});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextFormField(
          enabled: enabled,
          textInputAction: TextInputAction.next,
          autofocus: autofocus!,
          textCapitalization: textCapitalization,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          obscureText: isobsecureText!,
          obscuringCharacter: obsecureCharacter!,
          onTap: onTap,
          onEditingComplete: onEditingCompleted,
          maxLength: length,
          focusNode: focusNode,
          readOnly: readOnly,
          textAlign: textAlign!,
          onChanged: (value) {
            controller.value = TextEditingValue(
                text: value.toLowerCase(), selection: controller.selection);
            onChanged!(value);
          },
          validator: validator,
          style: TextStyle(fontFamily: 'muli'),
          decoration: InputDecoration(
              labelStyle:
                  TextStyle(fontFamily: 'muli', fontWeight: FontWeight.bold),
              hintStyle: TextStyle(fontFamily: 'muli', fontSize: 10),
              hintText: hintText,
              labelText: labelText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder()),
        ));
  }
}
