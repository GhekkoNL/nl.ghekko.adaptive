import 'package:adaptive/global/styling.dart';
import 'package:flutter/material.dart';

class OkCancelDialog extends StatelessWidget {
  const OkCancelDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(Insets.large),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: Insets.large),
              const OkCancelButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class OkCancelButtons extends StatelessWidget {
  const OkCancelButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Row(
          children: [
            DialogButton(label: "Cancel", onPressed: () => Navigator.pop(context, false)),
            DialogButton(label: "Ok", onPressed: () => Navigator.pop(context, true)),
          ],
        ),
      ],
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({super.key, required this.onPressed, required this.label});
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(label),
        ));
  }
}
