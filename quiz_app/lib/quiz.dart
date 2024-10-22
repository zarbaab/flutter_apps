class Quiz {
  final String questionText;
  final dynamic answer; // Can be a String (for MCQs) or bool (for True/False)
  final List<String>? options; // Options for multiple choice questions
  final bool? isTrue; // Optional for true/false logic

  Quiz({
    required this.questionText,
    required this.answer,
    this.options,
    this.isTrue,
  });
}
