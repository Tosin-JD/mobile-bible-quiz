import 'package:flutter/material.dart';
import 'package:quiz_app/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int highestScore = 0;

  @override
  void initState() {
    super.initState();
    checkAndSaveHighScore();
  }

  Future<void> checkAndSaveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHighScore = prefs.getInt('high_score') ?? 0;

    if (widget.score > savedHighScore) {
      await prefs.setInt('high_score', widget.score);
      setState(() {
        highestScore = widget.score;
      });
    } else {
      setState(() {
        highestScore = savedHighScore;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNewHighScore = widget.score == highestScore;
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your score: ${widget.score}/${widget.totalQuestions}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Highest Score: $highestScore",
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            if (isNewHighScore)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: const Text(
                      "🎉 Congrates!🎊👏🏆",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "You scored the highest yet!",
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                ],
              ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
                },
                child: Text("Restart Quiz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
