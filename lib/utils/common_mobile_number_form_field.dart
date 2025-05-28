import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waari_water/utils/constants.dart';

class MobileNumberInput extends StatelessWidget {
  const MobileNumberInput({Key? key,  this.onChanged, required this.validator,required this.controller, this.suffix})
      : super(key: key);
  final Widget? suffix;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mobile Number",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Constants.textColor),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Constants.textColor),
          keyboardType: TextInputType.number,
          //textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Enter mobile number",
            hintStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Constants.textDisableColor),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "+91  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " |",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Constants.textDisableColor),
                  ),
                ],
              ),
            ),
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
          cursorColor: Constants.textColor,
        ),
      ],
    );
  }
}
