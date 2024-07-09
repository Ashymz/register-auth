import 'package:flutter/material.dart';
import 'dart:math';

import 'package:register/home.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> _questions = [
    Question('What is the capital of France?',
        ['Paris', 'London', 'Rome', 'Berlin'], 'Paris'),
    Question(
        'Who wrote "To Kill a Mockingbird"?',
        ['Harper Lee', 'Mark Twain', 'Ernest Hemingway', 'F. Scott Fitzgerald'],
        'Harper Lee'),
    Question('What is the largest planet in our solar system?',
        ['Earth', 'Mars', 'Jupiter', 'Saturn'], 'Jupiter'),
    Question('What year did World War II end?',
        ['1942', '1945', '1948', '1950'], '1945'),
    Question('What is the chemical symbol for gold?', ['Au', 'Ag', 'Pb', 'Fe'],
        'Au'),
    Question('What is the capital of the United States of America?',
        ['Washington', 'New York', 'Los Angeles', 'Chicago'], 'Washington'),
    Question(
        'What is the capital of the United Kingdom of Great Britain and Northern Ireland?',
        ['London', 'Manchester', 'Birmingham', 'Bristol'],
        'London'),
  ];

  List<Question> _selectedQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _selectedQuestions = _getRandomQuestions(_questions, 10);
  }

  List<Question> _getRandomQuestions(List<Question> questions, int count) {
    final random = Random();
    return List.generate(count, (index) {
      int randomIndex = random.nextInt(questions.length);
      return questions[randomIndex];
    });
  }

  void _answerQuestion(String answer) {
    if (answer == _selectedQuestions[_currentQuestionIndex].correctAnswer) {
      _score++;
    }

    setState(() {
      _currentQuestionIndex++;
      if (_currentQuestionIndex >= _selectedQuestions.length) {
        _quizCompleted = true;
      }
    });
  }

  void _retakeQuiz() {
    setState(() {
      _selectedQuestions = _getRandomQuestions(_questions, 10);
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Quiz'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _quizCompleted ? _buildResult() : _buildQuiz(),
      ),
    );
  }

  Widget _buildQuiz() {
    final question = _selectedQuestions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
            'Question ${_currentQuestionIndex + 1}/${_selectedQuestions.length}',
            style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Text(question.text, style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        ...question.options.map((option) => ElevatedButton(
              onPressed: () => _answerQuestion(option),
              child: Text(option),
            )),
      ],
    );
  }

  Widget _buildResult() {
    String performance;
    if (_score <= 3) {
      performance = 'Poor';
    } else if (_score <= 7) {
      performance = 'Good';
    } else {
      performance = 'Excellent';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Quiz Completed!', style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        Text('Your Score: $_score', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Text('Performance: $performance', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _retakeQuiz,
          child: Text('Retake Quiz'),
        ),
      ],
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question(this.text, this.options, this.correctAnswer);
}
