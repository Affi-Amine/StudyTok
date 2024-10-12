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
  List<int> _selectedAnswerIndexes = []; // Track selected answers
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isAnswerVerified = false;
  bool _isCorrectAnswer = false;
  List<int> _correctIndexes = []; // Track correct answers

  // Toggle selected answers (multi-select)
  void _selectAnswer(int index) {
    setState(() {
      if (_selectedAnswerIndexes.contains(index)) {
        _selectedAnswerIndexes.remove(index); // Deselect if already selected
      } else {
        _selectedAnswerIndexes.add(index); // Select the option
      }
    });
  }

  // Verify the answers and set their correctness
  void _verifyAnswer(Question question) {
    if (_selectedAnswerIndexes.isEmpty) {
      _showMessage('Please select at least one answer.');
      return;
    }

    // Check if all selected answers are correct and no extra answers were selected
    final allCorrect = Set.from(_selectedAnswerIndexes)
            .containsAll(question.correctOptionIndexes) &&
        _selectedAnswerIndexes.length == question.correctOptionIndexes.length;

    setState(() {
      _isAnswerVerified = true;
      _isCorrectAnswer = allCorrect;
      _correctIndexes = question.correctOptionIndexes; // Store correct answers
    });

    _showResultOverlay(allCorrect);
  }

  // Show message using Snackbar
  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Display overlay for answer result (Correct/Incorrect)
  void _showResultOverlay(bool isCorrect) {
  // Directly move to the next question after a short delay
  Future.delayed(const Duration(seconds: 2), () {
    _nextQuestion();
  });
}

  // Move to the next question
  void _nextQuestion() {
    setState(() {
      _isAnswerVerified = false;
      _selectedAnswerIndexes = [];
    });

    if (_currentIndex < ref.read(questionRepositoryProvider).length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _showEndQuizMessage();
    }
  }

  // Show message when quiz is completed
  void _showEndQuizMessage() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Text(
            'Quiz Completed!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionRepositoryProvider);
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator()); // Loading state
    }

    return DefaultTabController(
      length: 2, // Two tabs: For You and Library
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0), // Top padding
              child: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Library'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildForYouTab(questions), // "For You" Tab
                  _buildLibraryTab(), // "Library" Tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForYouTab(List<Question> questions) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemCount: questions.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
          _selectedAnswerIndexes = [];
          _isAnswerVerified = false;
        });
      },
      itemBuilder: (context, index) {
        final question = questions[index];
        return _buildQuestionPage(question);
      },
    );
  }

  Widget _buildLibraryTab() {
    return Consumer(
      builder: (context, ref, child) {
        final questions = ref.watch(questionRepositoryProvider);
        final savedQuestions = questions.where((q) => q.isSaved).toList();

        if (savedQuestions.isEmpty) {
          return const Center(
            child: Text(
              'No saved questions yet!',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          );
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: savedQuestions.length,
          itemBuilder: (context, index) {
            final question = savedQuestions[index];
            return _buildQuestionPage(question);
          },
        );
      },
    );
  }

  Widget _buildQuestionPage(Question question) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryTags(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._buildAnswerOptions(question),
            const SizedBox(height: 40),
            _buildRevealButton(question),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryTag("Génétique humaine"),
          _buildCategoryTag("Bac Math"),
          _buildCategoryTag("Principale"),
          _buildCategoryTag("2024"),
        ],
      ),
    );
  }

  Widget _buildCategoryTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          Text(tag, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  List<Widget> _buildAnswerOptions(Question question) {
    final List<String> optionLabels = ['A.', 'B.', 'C.', 'D.'];

    return question.options.asMap().entries.map((entry) {
      final idx = entry.key;
      final option = entry.value;

      // Determine border color based on verification state
      Color borderColor;
      if (_isAnswerVerified) {
        if (_correctIndexes.contains(idx)) {
          borderColor = Colors.green; // Correct answer
        } else if (_selectedAnswerIndexes.contains(idx)) {
          borderColor = Colors.red; // Incorrect answer
        } else {
          borderColor = Colors.transparent; // Unselected
        }
      } else {
        borderColor = _selectedAnswerIndexes.contains(idx)
            ? Colors.blue // Selected but not verified yet
            : Colors.transparent;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              optionLabels[idx],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectAnswer(idx), // Select or deselect answer
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(option, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildRevealButton(Question question) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () => _verifyAnswer(question),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text('REVEAL',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
        Positioned(
          right: 16,
          child: Consumer(
            builder: (context, ref, child) {
              final isSaved = question.isSaved;
              return IconButton(
                onPressed: () => ref
                    .read(questionRepositoryProvider.notifier)
                    .toggleSave(question.id),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.blue : Colors.black,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
