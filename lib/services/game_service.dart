import 'dart:math';

import '../models/game_question.dart';

class GameService {
  final Random _random = Random();

  BluffRoundOptions generateBluffVsTruthOptions(GameQuestion question) {
    final correctOnBluff = _random.nextBool();

    final truth = BluffOption(
      mode: ChoiceMode.truth,
      label: correctOnBluff ? question.misleadingAnswer : question.correctAnswer,
      isCorrect: !correctOnBluff,
    );

    final bluff = BluffOption(
      mode: ChoiceMode.bluff,
      label: correctOnBluff ? question.correctAnswer : question.misleadingAnswer,
      isCorrect: correctOnBluff,
    );

    return BluffRoundOptions(truth: truth, bluff: bluff);
  }

  bool validateAnswer({
    required BluffOption selected,
  }) {
    return selected.isCorrect;
  }

  int applyScore({
    required bool isCorrect,
    required bool choseBluff,
    required int streak,
    required int difficulty,
  }) {
    if (!isCorrect) return -10;

    final safeBase = 10;
    final bluffBase = 18;
    final base = choseBluff ? bluffBase : safeBase;

    final difficultyMultiplier = 1 + (difficulty * 0.2);
    final streakMultiplier = 1 + (streak * 0.12);

    return (base * difficultyMultiplier * streakMultiplier).round();
  }
}
