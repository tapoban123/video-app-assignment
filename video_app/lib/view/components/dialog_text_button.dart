import 'package:flutter/material.dart';

/// TextButton displayed on dialogs
/// When no values are passed, it implements a Cancel Button.
class DialogTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? buttonColor;
  const DialogTextButton({
    super.key,
    this.onPressed,
    this.buttonText,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ??
          () {
            Navigator.of(context).pop();
          },
      style: TextButton.styleFrom(backgroundColor: buttonColor ?? Colors.red),
      child: Text(
        buttonText ?? "Cancel",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
