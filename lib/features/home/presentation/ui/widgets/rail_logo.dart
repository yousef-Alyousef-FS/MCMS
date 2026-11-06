import 'package:flutter/material.dart';

class RailLogo extends StatelessWidget {
  const RailLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.local_hospital_rounded, color: scheme.primary),
    );
  }
}
