import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _verifyAnswer(Question question) {
    if (_selectedAnswerIndex == null) return;

    bool isCorrect = _selectedAnswerIndex == question.correctOptionIndex;
    _showResultOverlay(isCorrect);
  }

  void _showResultOverlay(bool isCorrect) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Lottie.asset(
            isCorrect
                ? 'assets/correct_animation.json'
                : 'assets/incorrect_animation.json',
            repeat: false,
          ),
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      setState(() {
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
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: questions.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _selectedAnswerIndex = null;
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
      child: Container(
        height: MediaQuery.of(context).size.height, // Full-screen height
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Text(
                question.text,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ...question.options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _selectAnswer(idx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswerIndex == idx
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    children: [
                      if (_selectedAnswerIndex == idx)
                        Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text(option, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _verifyAnswer(question),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Check Answer', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward, color: Colors.white),
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _currentIndex--;
                            _selectedAnswerIndex = null;
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: _currentIndex < questions.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _currentIndex++;
                            _selectedAnswerIndex = null;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
