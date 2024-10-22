import 'quiz.dart';

class QuizBrain {
  int _questionIndex = 0;

  final List<Quiz> _questionBank = [
    Quiz(
      questionText: 'Flutter is developed by which company?',
      answer: 'Google',
      options: ['Apple', 'Google', 'Microsoft'],
    ),
    Quiz(
      questionText: 'Which language does Flutter use?',
      answer: 'Dart',
      options: ['Kotlin', 'Swift', 'Dart'],
    ),
    Quiz(
      questionText: 'Which of the following is true about Flutter?',
      answer: 'Widgets are immutable',
      options: ['Widgets are mutable', 'Widgets are immutable', 'No widgets'],
    ),
     Quiz(
    questionText: 'Which of the following is a widget used for layout in Flutter?',
    answer: 'Column',
    options: ['Column', 'Row', 'Stack'],
  ),
  Quiz(
    questionText: 'Which of the following statements is true about Stateless widgets?',
    answer: 'They cannot change their state during their lifetime.',
    options: [
      'They can change their state at any time.',
      'They cannot change their state during their lifetime.',
      'They are mutable.'
    ],
  ),
  Quiz(
    questionText: 'Which of the following is a correct way to create a Stateful widget?',
    answer: 'Extend the StatefulWidget class and override createState().',
    options: [
      'Extend the StatelessWidget class and override build().',
      'Implement the Widget interface.',
      'Extend the StatefulWidget class and override createState().',
    ],
  ),
   
  ];

  String getQuestion() {
    return _questionBank[_questionIndex].questionText;
  }

  dynamic getAnswer() {
    return _questionBank[_questionIndex].answer;
  }

  List<String>? getOptions() {
    return _questionBank[_questionIndex].options;
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
