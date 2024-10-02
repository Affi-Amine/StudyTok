import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/question.dart';

part 'question_repository.g.dart';

@riverpod
class QuestionRepository extends _$QuestionRepository {
  final List<Question> _questions = [
    Question(
      id: '1',
      text: 'What is the capital of France?',
      options: ['London', 'Berlin', 'Paris', 'Madrid'],
      correctOptionIndex: 2,
    ),
    Question(
      id: '2',
      text: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctOptionIndex: 1,
    ),
    Question(
      id: '3',
      text: 'Who wrote "Romeo and Juliet"?',
      options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
      correctOptionIndex: 1,
    ),
    Question(
      id: '4',
      text: 'What is the largest ocean on Earth?',
      options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
      correctOptionIndex: 3,
    ),
    Question(
      id: '5',
      text: 'What is the chemical symbol for gold?',
      options: ['Au', 'Ag', 'Fe', 'Cu'],
      correctOptionIndex: 0,
    ),
    Question(
      id: '6',
      text: 'Which country is home to the kangaroo?',
      options: ['New Zealand', 'South Africa', 'Australia', 'Brazil'],
      correctOptionIndex: 2,
    ),
    Question(
      id: '7',
      text: 'What is the largest planet in our solar system?',
      options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      correctOptionIndex: 2,
    ),
    Question(
      id: '8',
      text: 'Who painted the Mona Lisa?',
      options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
      correctOptionIndex: 2,
    ),
    Question(
      id: '9',
      text: 'What is the main ingredient in guacamole?',
      options: ['Tomato', 'Avocado', 'Onion', 'Lime'],
      correctOptionIndex: 1,
    ),
    Question(
      id: '10',
      text: 'Which element has the chemical symbol "O"?',
      options: ['Gold', 'Silver', 'Oxygen', 'Carbon'],
      correctOptionIndex: 2,
    ),
  ];

  @override
  List<Question> build() => _questions;

  Question getQuestionById(String id) {
    return _questions.firstWhere((q) => q.id == id);
  }

  void toggleLike(String id) {
    state = [
      for (final question in state)
        if (question.id == id)
          question.copyWith(isLiked: !question.isLiked)
        else
          question,
    ];
  }

  void toggleSave(String id) {
    state = [
      for (final question in state)
        if (question.id == id)
          question.copyWith(isSaved: !question.isSaved)
        else
          question,
    ];
  }
}