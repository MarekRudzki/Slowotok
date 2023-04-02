import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            boxShadow: [
              BoxShadow(
                blurRadius: 2.0,
                color: Theme.of(context).dividerColor,
                offset: const Offset(1, 3), // shadow direction: bottom right
              )
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}
