import 'package:flutter/material.dart';
import 'package:quiz_app/screen/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> getHighScore() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt("high_score") ?? 0;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tosin Quiz App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<int>(
              future: getHighScore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading high score"));
                }

                final highScore = snapshot.data;
                return Center(
                  child: Text(
                    "Highest Score: $highScore",
                    style: const TextStyle(color: Colors.blue, fontSize: 24),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: const Text('Start Quiz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
