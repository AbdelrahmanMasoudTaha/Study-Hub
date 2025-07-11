import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: MyColors.buttonPrimary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CupertinoButton(
        onPressed: isLoading ? null : onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
