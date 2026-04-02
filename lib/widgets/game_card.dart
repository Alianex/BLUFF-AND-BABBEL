import 'package:flutter/material.dart';

import '../models/theme_model.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.question,
    required this.theme,
    required this.showHint,
    required this.hint,
  });

  final String question;
  final ThemeModel theme;
  final bool showHint;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: theme.cardGradient),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: showHint ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: showHint
                ? Text(
                    'Hint: $hint',
                    style: TextStyle(
                      color: theme.accent,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
