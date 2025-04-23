// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/constants/app_sizes.dart';

class CustomTextFormInput extends StatelessWidget {
  const CustomTextFormInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.icon,
    required this.obscureText,
    required this.validator,
    required this.textInputAction,
    required this.keyboardType,
    required this.onEditingComplete,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Sizes.p16,
        right: Sizes.p20,
        bottom: Sizes.p12,
      ),
      child: TextFormField(
        controller: controller,
        autocorrect: false,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        keyboardAppearance: Brightness.light,
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hint,
          label: Text(label),
          icon: Container(
            padding: const EdgeInsets.all(Sizes.p12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryLightColor),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
