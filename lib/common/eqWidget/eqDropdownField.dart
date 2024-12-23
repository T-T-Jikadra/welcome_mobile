import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class eqDropdownField extends StatelessWidget {
  final String value;
  final dynamic items; // Accepts both List<String> and Map<String, String>
  final bool enabled;
  final String labelText;
  final String hintText;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const eqDropdownField({
    super.key,
    this.onChanged,
    this.validator,
    required this.value,
    required this.items,
    required this.enabled,
    required this.labelText,
    required this.hintText,
  });

  // Convert dynamic items to List<DropdownMenuItem<String>> for DropdownButtonFormField
  List<DropdownMenuItem<String>> getDropdownItems() {
    if (items is List<String>) {
      return (items as List<String>).map((String item) {
        return DropdownMenuItem<String>(
          enabled: enabled,
          value: item,
          child: Text(item),
        );
      }).toList();
    } else if (items is Map<String, String>) {
      return (items as Map<String, String>).entries.map((entry) {
        return DropdownMenuItem<String>(
          enabled: enabled,
          value: entry.value,
          child: Text(entry.key),
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color:
                  enabled ? Colors.black45 : Color.fromARGB(255, 223, 222, 222),
            ),
          ),
          labelStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontFamily: 'muli',
              fontWeight: FontWeight.bold,
              color: enabled ? const Color.fromARGB(221, 31, 30, 30) : Colors.grey,
            ),
          ),
          hintStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontFamily: 'muli',
              fontWeight: FontWeight.bold,
              color: enabled ? Colors.black54 : Colors.grey,
            ),
          ),
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        items: getDropdownItems(),
        onChanged: enabled ? onChanged : null,
        validator: validator,
      ),
    );
  }
}
