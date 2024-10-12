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
      correctOptionIndexes: [2], // Paris
    ),
    Question(
      id: '2',
      text: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctOptionIndexes: [1], // Mars
    ),
    Question(
      id: '3',
      text: 'Who wrote "Romeo and Juliet"?',
      options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
      correctOptionIndexes: [1], // William Shakespeare
    ),
    Question(
      id: '4',
      text: 'What is the largest ocean on Earth?',
      options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
      correctOptionIndexes: [3], // Pacific Ocean
    ),
    Question(
      id: '5',
      text: 'What is the chemical symbol for gold?',
      options: ['Au', 'Ag', 'Fe', 'Cu'],
      correctOptionIndexes: [0], // Au
    ),
    Question(
      id: '6',
      text: 'Which country is home to the kangaroo?',
      options: ['New Zealand', 'South Africa', 'Australia', 'Brazil'],
      correctOptionIndexes: [2], // Australia
    ),
    Question(
      id: '7',
      text: 'What is the largest planet in our solar system?',
      options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      correctOptionIndexes: [2], // Jupiter
    ),
    Question(
      id: '8',
      text: 'Who painted the Mona Lisa?',
      options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
      correctOptionIndexes: [2], // Leonardo da Vinci
    ),
    Question(
      id: '9',
      text: 'What is the main ingredient in guacamole?',
      options: ['Tomato', 'Avocado', 'Onion', 'Lime'],
      correctOptionIndexes: [1], // Avocado
    ),
    Question(
      id: '10',
      text: 'Which element has the chemical symbol "O"?',
      options: ['Gold', 'Silver', 'Oxygen', 'Carbon'],
      correctOptionIndexes: [2], // Oxygen
    ),
  ];

  // Initialize the state with the default list of questions
  @override
  List<Question> build() => _questions;

  // Retrieve a specific question by ID
  Question getQuestionById(String id) {
    return _questions.firstWhere((q) => q.id == id);
  }

  // Toggle 'like' status for a specific question
  void toggleLike(String id) {
    state = [
      for (final question in state)
        if (question.id == id)
          question.copyWith(isLiked: !question.isLiked)
        else
          question,
    ];
  }

  // Toggle 'save' status for a specific question
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