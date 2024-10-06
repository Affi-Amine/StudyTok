import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/question.dart';
import '../repositories/question_repository.dart';

class FYPScreen extends ConsumerStatefulWidget {
  const FYPScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FYPScreen> createState() => _FYPScreenState();
}

class _FYPScreenState extends ConsumerState<FYPScreen> {
  int? _selectedAnswerIndex;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isAnswerVerified = false;
  bool _isCorrectAnswer = false;

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _verifyAnswer(Question question) {
    if (_selectedAnswerIndex == null) return;

    setState(() {
      _isCorrectAnswer = _selectedAnswerIndex == question.correctOptionIndex;
      _isAnswerVerified = true;
    });

    _showResultOverlay(_isCorrectAnswer);
  }

  void _showResultOverlay(bool isCorrect) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Text(
            isCorrect ? 'Correct!' : 'Incorrect!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      _highlightAnswer();
    });
  }

  void _highlightAnswer() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isAnswerVerified = false;
        _selectedAnswerIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionRepositoryProvider);
    if (questions.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Loading state
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: questions.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _selectedAnswerIndex = null;
            _isAnswerVerified = false;
          });
        },
        itemBuilder: (context, index) {
          final question = questions[index];
          return _buildQuestionPage(question, questions);
        },
      ),
    );
  }

  Widget _buildQuestionPage(Question question, List<Question> questions) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category tags (Top part) with horizontal scrolling
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTag("Génétique humaine"),
                  _buildCategoryTag("Bac Math"),
                  _buildCategoryTag("Principale"),
                  _buildCategoryTag("2024"),
                  // Add more tags if needed...
                ],
              ),
            ),
            SizedBox(height: 20),

            // Question Text
            Text(
              question.text,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Answer Options
            ...question.options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;

              // Apply the color change based on whether the answer is verified and correct/incorrect
              Color buttonColor;
              if (_isAnswerVerified && idx == _selectedAnswerIndex) {
                buttonColor = _isCorrectAnswer ? Colors.green : Colors.red;
              } else {
                buttonColor = Colors.green.withOpacity(0.3);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _selectAnswer(idx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(option, style: TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),

            SizedBox(height: 20),

            // Reveal Answer Button
            ElevatedButton(
              onPressed: () => _verifyAnswer(question),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Reveal Answer', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tag, style: TextStyle(color: Colors.black)),
    );
  }
}