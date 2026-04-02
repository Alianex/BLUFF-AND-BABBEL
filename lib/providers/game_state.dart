import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game_question.dart';
import '../services/game_service.dart';

enum AnswerAnimationState { idle, correct, wrong }

class GameState extends ChangeNotifier {
  GameState(this._gameService) {
    _questions = _seedQuestions;
    _loadQuestion();
  }

  final GameService _gameService;
  late List<GameQuestion> _questions;

  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _round = 1;
  double _multiplier = 1.0;
  bool _showHint = false;
  bool? _isLastCorrect;
  AnswerAnimationState _animationState = AnswerAnimationState.idle;
  late BluffRoundOptions _roundOptions;

  int get score => _score;
  int get streak => _streak;
  int get round => _round;
  int get totalRounds => _questions.length;
  double get multiplier => _multiplier;
  bool get showHint => _showHint;
  bool? get isLastCorrect => _isLastCorrect;
  AnswerAnimationState get animationState => _animationState;

  GameQuestion get currentQuestion => _questions[_currentIndex];
  BluffRoundOptions get roundOptions => _roundOptions;

  void toggleHint() {
    _showHint = !_showHint;
    notifyListeners();
  }

  void answer(BluffOption option, {required bool choseBluff}) {
    final isCorrect = _gameService.validateAnswer(selected: option);
    if (isCorrect) {
      _streak += 1;
      _animationState = AnswerAnimationState.correct;
      HapticFeedback.lightImpact();
    } else {
      _streak = 0;
      _animationState = AnswerAnimationState.wrong;
      HapticFeedback.mediumImpact();
    }

    final delta = _gameService.applyScore(
      isCorrect: isCorrect,
      choseBluff: choseBluff,
      streak: _streak,
      difficulty: currentQuestion.difficulty,
    );

    _score = (_score + delta).clamp(0, 999999);
    _multiplier = (1 + (_streak * 0.1) + (currentQuestion.difficulty * 0.15));
    _isLastCorrect = isCorrect;

    notifyListeners();
  }

  void nextRound() {
    _animationState = AnswerAnimationState.idle;
    _showHint = false;

    if (_currentIndex < _questions.length - 1) {
      _currentIndex += 1;
      _round += 1;
      _loadQuestion();
      notifyListeners();
      return;
    }

    _currentIndex = 0;
    _round = 1;
    _streak = 0;
    _multiplier = 1.0;
    _loadQuestion();
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    _questions = _seedQuestions.where((q) => q.language == languageCode).toList();
    if (_questions.isEmpty) {
      _questions = _seedQuestions.where((q) => q.language == 'es').toList();
    }

    _currentIndex = 0;
    _round = 1;
    _streak = 0;
    _multiplier = 1.0;
    _score = 0;
    _isLastCorrect = null;
    _animationState = AnswerAnimationState.idle;
    _loadQuestion();
    notifyListeners();
  }

  void _loadQuestion() {
    _roundOptions = _gameService.generateBluffVsTruthOptions(currentQuestion);
  }
}

const List<GameQuestion> _seedQuestions = [
  GameQuestion(
    language: 'es',
    prompt: 'How do you say "apple" in Spanish?',
    correctAnswer: 'Manzana',
    misleadingAnswer: 'Pomme',
    hint: 'It starts with M and has 7 letters.',
    difficulty: 1,
  ),
  GameQuestion(
    language: 'es',
    prompt: 'Choose the correct translation for "I am learning quickly".',
    correctAnswer: 'Estoy aprendiendo rápido',
    misleadingAnswer: 'Je suis apprendre vite',
    hint: 'Think present progressive in Spanish.',
    difficulty: 2,
  ),
  GameQuestion(
    language: 'fr',
    prompt: 'What is "good night" in French?',
    correctAnswer: 'Bonne nuit',
    misleadingAnswer: 'Buenos noches',
    hint: 'Not Spanish, and 2 words.',
    difficulty: 1,
  ),
  GameQuestion(
    language: 'fr',
    prompt: 'Correct translation for "We travel tomorrow"?',
    correctAnswer: 'Nous voyageons demain',
    misleadingAnswer: 'Nous viaje demain',
    hint: 'Use proper French verb conjugation for nous.',
    difficulty: 2,
  ),
  GameQuestion(
    language: 'de',
    prompt: 'What does "Danke" mean?',
    correctAnswer: 'Thank you',
    misleadingAnswer: 'Please',
    hint: 'It is a gratitude phrase.',
    difficulty: 1,
  ),
  GameQuestion(
    language: 'ja',
    prompt: 'Pick the truth for "water" in Japanese romaji.',
    correctAnswer: 'Mizu',
    misleadingAnswer: 'Sakura',
    hint: 'Sakura is a flower.',
    difficulty: 2,
  ),
  GameQuestion(
    language: 'sw',
    prompt: 'How do you say "hello" in Swahili?',
    correctAnswer: 'Jambo',
    misleadingAnswer: 'Arigatou',
    hint: 'A common East African greeting.',
    difficulty: 1,
  ),
  GameQuestion(
    language: 'sw',
    prompt: 'Truth for "Thank you very much" in Swahili?',
    correctAnswer: 'Asante sana',
    misleadingAnswer: 'Merci beaucoup',
    hint: 'Two words; first begins with A.',
    difficulty: 2,
  ),
];
