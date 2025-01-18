import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:testline_assignment/src/features/home/service/quizService.dart';

/// Main screen for the quiz application.
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // List of questions fetched from the API.
  List<dynamic> _questions = [];

  // Map to store user answers for each question.
  Map<int, String> _userAnswers = {};

  // List of results after the quiz is submitted.
  List<dynamic> _results = [];

  // State to indicate if data is still loading.
  bool _isLoading = true;

  // State to indicate if the results are shown.
  bool _showResults = false;

  // Index of the currently displayed question.
  int _currentQuestionIndex = 0;

  // Total score based on correct answers.
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    // Fetch quiz data when the widget is initialized.
    _fetchQuizData();
  }

  /// Fetches quiz data from the API using the `ApiService`.
  Future<void> _fetchQuizData() async {
    try {
      final data = await ApiService.fetchQuizData();
      setState(() {
        _questions = data['questions']; // Set questions from API response.
        _isLoading = false; // Data has finished loading.
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false; // Set loading to false on failure.
      });
    }
  }

  /// Processes user answers and calculates results.
  Future<void> _submitQuiz() async {
    final results = _questions.map((question) {
      // Find the correct answer for the current question.
      final correctOption = question['options']
          .firstWhere((option) => option['is_correct'] == true)['description'];

      // Retrieve the user's answer for this question.
      final userAnswer = _userAnswers[question['id']] ?? 'Unanswered';

      return {
        'question': question['description'],
        'correct_answer': correctOption,
        'user_answer': userAnswer,
        'is_correct': correctOption == userAnswer, // Check correctness.
      };
    }).toList();

    // Calculate the total score based on correct answers.
    final totalPoints = results.where((result) => result['is_correct']).length;

    setState(() {
      _results = results; // Store the results for display.
      _showResults = true; // Show the results screen.
      _totalPoints = totalPoints; // Update the total score.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being fetched.
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent.withOpacity(.2),
          centerTitle: true,
          title: Text(
            "Quiz Is Loading...",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show results screen after the quiz is submitted.
    if (_showResults) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent.withOpacity(.2),
          title: Text(
            "Quiz Results",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display the user's score.
                  Text(
                    "Your Score: $_totalPoints/${_results.length}",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // Button to restart the quiz.
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showResults = false;
                        _userAnswers = {};
                        _currentQuestionIndex = 0;
                        _totalPoints = 0;
                      });
                    },
                    child: Text(
                      "Restart",
                      style: GoogleFonts.lato(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            // Display detailed results for each question.
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display question text.
                          Text(
                            'Q${index + 1}: ${result['question']}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          // Show user's answer with appropriate color.
                          Text(
                            'Your Answer: ${result['user_answer']}',
                            style: TextStyle(
                              color: result['is_correct']
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Display the correct answer.
                          Text(
                            'Correct Answer: ${result['correct_answer']}',
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // Display the current question and options.
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.withOpacity(.2),
        centerTitle: true,
        title: Text(
          "Quiz",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current question text.
            Text(
              'Q${_currentQuestionIndex + 1}: ${question['description']}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display options with a delay effect.
            ...question['options'].map<Widget>((option) {
              return DelayedDisplay(
                delay: Duration(seconds: 1),
                child: RadioListTile<String>(
                  title: Text(option['description']),
                  value: option['description'],
                  groupValue: _userAnswers[question['id']],
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[question['id']] = value!;
                    });
                  },
                ),
              );
            }).toList(),
            Spacer(),
            // Navigation buttons for previous/next or submit actions.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex--;
                      });
                    },
                    child: Text("Previous"),
                  ),
                if (_currentQuestionIndex < _questions.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex++;
                      });
                    },
                    child: Text("Next"),
                  ),
                if (_currentQuestionIndex == _questions.length - 1)
                  ElevatedButton(
                    onPressed: _submitQuiz,
                    child: Text("Submit"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
