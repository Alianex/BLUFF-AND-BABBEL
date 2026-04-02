import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_score.dart';
import '../widgets/choice_button.dart';
import '../widgets/game_card.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameState, ThemeProvider>(
      builder: (context, gameState, themeProvider, child) {
        final theme = themeProvider.current;

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                theme.backgroundImage,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withValues(alpha: 0.45),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _TopBar(
                        score: gameState.score,
                        multiplier: gameState.multiplier,
                        round: gameState.round,
                        totalRounds: gameState.totalRounds,
                      ),
                      const SizedBox(height: 16),
                      _LanguagePicker(
                        onChanged: (value) {
                          themeProvider.setLanguageTheme(value);
                          gameState.setLanguage(value);
                        },
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            final offset = Tween<Offset>(
                              begin: const Offset(0.2, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(position: offset, child: child),
                            );
                          },
                          child: _GameRound(
                            key: ValueKey(gameState.round),
                            state: gameState,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.score,
    required this.multiplier,
    required this.round,
    required this.totalRounds,
  });

  final int score;
  final double multiplier;
  final int round;
  final int totalRounds;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: AnimatedScore(score: score)),
            Text(
              'x${multiplier.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: round / totalRounds,
            minHeight: 10,
            backgroundColor: Colors.white24,
          ),
        ),
      ],
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            value: context.watch<ThemeProvider>().current.languageCode,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: 'es', child: Text('Spanish')),
              DropdownMenuItem(value: 'sw', child: Text('Swahili')),
              DropdownMenuItem(value: 'fr', child: Text('French')),
              DropdownMenuItem(value: 'de', child: Text('German')),
              DropdownMenuItem(value: 'ja', child: Text('Japanese')),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}

class _GameRound extends StatelessWidget {
  const _GameRound({super.key, required this.state});

  final GameState state;

  @override
  Widget build(BuildContext context) {
    final q = state.currentQuestion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AnimatedFeedbackWrapper(
          status: state.animationState,
          child: GameCard(
            question: q.prompt,
            theme: context.watch<ThemeProvider>().current,
            showHint: state.showHint,
            hint: q.hint,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ChoiceButton(
            label: 'Truth: ${state.roundOptions.truth.label}',
            color: Colors.green.shade600,
            onTap: () => state.answer(state.roundOptions.truth, choseBluff: false),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ChoiceButton(
            label: 'Bluff: ${state.roundOptions.bluff.label}',
            color: Colors.orange.shade700,
            onTap: () => state.answer(state.roundOptions.bluff, choseBluff: true),
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black54,
              ),
              onPressed: state.toggleHint,
              icon: const Icon(Icons.lightbulb),
              label: const Text('Hint'),
            ),
            const SizedBox(width: 10),
            if (state.isLastCorrect != null)
              Expanded(
                child: Text(
                  state.isLastCorrect! ? 'Correct! Keep the streak alive.' : 'Wrong! Streak reset.',
                  style: TextStyle(
                    color: state.isLastCorrect! ? Colors.lightGreenAccent : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: state.nextRound,
          child: const Text('Next Round'),
        ),
      ],
    );
  }
}

class _AnimatedFeedbackWrapper extends StatelessWidget {
  const _AnimatedFeedbackWrapper({required this.status, required this.child});

  final AnswerAnimationState status;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      builder: (context, value, _) {
        final shake = status == AnswerAnimationState.wrong
            ? math.sin(value * math.pi * 8) * (1 - value) * 12
            : 0.0;
        final bounce = status == AnswerAnimationState.correct
            ? 1 + (math.sin(value * math.pi) * 0.06)
            : 1.0;

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Transform.scale(
            scale: bounce,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  if (status == AnswerAnimationState.correct)
                    const BoxShadow(
                      color: Colors.greenAccent,
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  if (status == AnswerAnimationState.wrong)
                    const BoxShadow(
                      color: Colors.redAccent,
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
