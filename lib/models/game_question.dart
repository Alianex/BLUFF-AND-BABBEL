class GameQuestion {
  const GameQuestion({
    required this.language,
    required this.prompt,
    required this.correctAnswer,
    required this.misleadingAnswer,
    required this.hint,
    required this.difficulty,
  });

  final String language;
  final String prompt;
  final String correctAnswer;
  final String misleadingAnswer;
  final String hint;
  final int difficulty;
}

enum ChoiceMode { truth, bluff }

class BluffOption {
  const BluffOption({
    required this.mode,
    required this.label,
    required this.isCorrect,
  });

  final ChoiceMode mode;
  final String label;
  final bool isCorrect;
}

class BluffRoundOptions {
  const BluffRoundOptions({
    required this.truth,
    required this.bluff,
  });

  final BluffOption truth;
  final BluffOption bluff;
}
