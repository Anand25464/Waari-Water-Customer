import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waari_water/utils/constants.dart';

class CommonTextField extends StatelessWidget {

   const CommonTextField({
    Key? key,
     required this.headerText,
     required this.hintText,
     required this.validator,
     required this.controller,
     this.onChanged,
     this.onTap,
    this.suffix
  }) : super(key: key);


  final String headerText;
  final String hintText;
  final Widget? suffix;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          headerText,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Constants.textColor),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Constants.textColor),
          //textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Constants.textDisableColor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Constants.outLineColor),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Constants.outLineColor,
                  width: 2.0,
                ),
              ),
              suffixIcon: suffix
          ),
          validator: validator,
          onTap: onTap,
          cursorColor: Constants.textColor,
        ),
      ],
    );
  }
}
