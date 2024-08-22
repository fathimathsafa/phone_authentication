import 'package:firebase_study/utils/app_colors.dart';
import 'package:flutter/material.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final String hintText;

  final TextInputType textInputType;
  final bool isObsecureText;
  final Widget? rightIcon;

  const RoundTextField(
      {super.key,
      this.onChanged,
      required this.hintText,
      required this.textInputType,
      this.isObsecureText = false,
      this.rightIcon,
      this.textEditingController,
      this.validator});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObsecureText,
        onChanged: onChanged,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            suffixIcon: rightIcon,
            hintStyle: TextStyle(fontSize: 12, color: AppColors.greyColor)),
        validator: validator,
      ),
    );
  }
}
