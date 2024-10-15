import 'quiz.dart';

class QuizBrain {
  int _questionIndex = 0;

  final List<Quiz> _questionBank = [
    Quiz(questionText: 'Flutter is a framework?', answer: true),
    Quiz(questionText: 'Flutter uses Dart language?', answer: true),
    Quiz(questionText: 'Widgets in Flutter are immutable?', answer: true),
    Quiz(questionText: 'Flutter is developed by Apple?', answer: false),
    Quiz(questionText: 'Hot Reload is a feature in Flutter?', answer: true),
    Quiz(questionText: 'Dart is a statically-typed language?', answer: true),
    Quiz(
        questionText: 'Flutter can be used for web development?', answer: true),
    Quiz(questionText: 'Stateful widgets cannot change state?', answer: false),
    Quiz(
        questionText: 'The build method is called only once in widgets?',
        answer: false),
    Quiz(
        questionText: 'The default Flutter app starts with a counter example?',
        answer: true),
  ];

  String getQuestion() {
    return _questionBank[_questionIndex].questionText;
  }

  bool getAnswer() {
    return _questionBank[_questionIndex].answer;
  }

  void nextQuestion() {
    if (_questionIndex < _questionBank.length - 1) {
      _questionIndex++;
    }
  }

  bool isFinished() {
    return _questionIndex >= _questionBank.length - 1;
  }

  void reset() {
    _questionIndex = 0;
  }
}
