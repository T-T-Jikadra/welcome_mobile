// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class EqTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final bool? isObscureText;
  final bool readOnly;
  final String? obscureCharacter;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final InputBorder? inputBorder;
  final int? length;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingCompleted;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;
  final List? selValue;
  final double? hPadding;
  final double? vPadding;

  const EqTextField(
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
      this.inputBorder = const OutlineInputBorder(),
      this.onTap,
      required this.controller,
      required this.hintText,
      required this.labelText,
      this.onChanged,
      this.onFieldSubmitted,
      this.selValue,
      this.autofocus = false,
      this.isObscureText = false,
      this.obscureCharacter = '*',
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.sentences,
      this.hPadding = 8,
      this.vPadding = 10});

  @override
  _EqTextFieldState createState() => _EqTextFieldState();
}

class _EqTextFieldState extends State<EqTextField> {
  late FocusNode _focus;
  bool _isTextSelected = false;

  @override
  void initState() {
    super.initState();
    _focus = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.hPadding!, vertical: widget.vPadding!),
      child: TextFormField(
        enabled: widget.enabled,
        textInputAction: TextInputAction.next,
        autofocus: widget.autofocus!,
        textCapitalization: widget.textCapitalization,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isObscureText!,
        obscuringCharacter: widget.obscureCharacter!,
        onTap: () {
          setState(() {
            if (_isTextSelected) {
              // Unselect text if already selected
              widget.controller.selection = TextSelection.collapsed(
                  offset: widget.controller.text.length);
            } else {
              // Select all text if not selected
              widget.controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.controller.text.length,
              );
            }
            _isTextSelected = !_isTextSelected;
          });
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onEditingComplete: widget.onEditingCompleted,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLength: widget.length,
        focusNode: _focus,
        readOnly: widget.readOnly,
        textAlign: widget.textAlign!,
        onChanged: (value) {
          widget.controller.value = TextEditingValue(
            text: value.toUpperCase(),
            selection: widget.controller.selection,
          );
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        validator: widget.validator,
        style: TextStyle(fontFamily: 'muli'),
        decoration: InputDecoration(
            labelStyle: TextStyle(
              fontFamily: 'muli',
              fontWeight: FontWeight.bold,
            ),
            hintStyle: TextStyle(fontFamily: 'muli', fontSize: 10),
            hintText: widget.hintText,
            labelText: widget.labelText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            // counterText: "",
            border: widget.inputBorder),
      ),
    );
  }
}
