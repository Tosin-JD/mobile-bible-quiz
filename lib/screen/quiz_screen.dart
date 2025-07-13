import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/screen/result_screen.dart';

Future<List<Question>> loadQuestionsFromJson() async {
  final String jsonString = await rootBundle.loadString('assets/data/quiz.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((item) => Question.fromJson(item)).toList();
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  late Future<List<Question>> futureQuestions;
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    futureQuestions = loadQuestionsFromJson().then((loadedQuestions) {
      loadedQuestions.shuffle();
      return loadedQuestions;
    });
  }

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctOptionIndex) {
      setState(() {
        score++;
      });
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: score, totalQuestions: questions.length),
          ),
        );
      }
    });
  }

  void endQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(score: score, totalQuestions: questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: futureQuestions,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        questions = asyncSnapshot.data!;
        final question = questions[currentQuestionIndex];

        return Scaffold(
          appBar: AppBar(title: const Text('Quiz')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${currentQuestionIndex + 1} of ${questions.length}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  question.text,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () => answerQuestion(index),
                        child: Text(option, style: TextStyle(fontSize: 20),),
                      ),
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: () => endQuiz(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(200, 60),
                  ),
                  child: const Text(
                    "End Quiz",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
