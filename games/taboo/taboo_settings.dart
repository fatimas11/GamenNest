import 'package:flutter/material.dart';
import '../../core/translations.dart'; 
import 'taboo_game.dart';

class StartScreen extends StatefulWidget {
  final Function(String) onLanguageChange;
  const StartScreen({super.key, required this.onLanguageChange});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  double _timerDuration = 60;
  double _forbiddenCount = 5;
  final TextEditingController _team1Controller = TextEditingController(text: "Team A");
  final TextEditingController _team2Controller = TextEditingController(text: "Team B");

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(uiText[lang]!['title']!), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Icon(Icons.group, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            // Team Name Inputs
            TextField(
              controller: _team1Controller,
              decoration: InputDecoration(labelText: lang == 'ar' ? "اسم الفريق 1" : "Team 1 Name"),
            ),
            TextField(
              controller: _team2Controller,
              decoration: InputDecoration(labelText: lang == 'ar' ? "اسم الفريق 2" : "Team 2 Name"),
            ),
            const SizedBox(height: 30),
            Text("${uiText[lang]!['time']}: ${_timerDuration.toInt()} ${uiText[lang]!['sec']}", style: const TextStyle(fontSize: 18)),
            Slider(
              value: _timerDuration,
              min: 5, max: 120, divisions: 23,
              onChanged: (val) => setState(() => _timerDuration = val),
            ),
            Text("${uiText[lang]!['forbidden']}: ${_forbiddenCount.toInt()}", style: const TextStyle(fontSize: 18)),
            Slider(
              value: _forbiddenCount,
              min: 4, max: 10, divisions: 6,
              onChanged: (val) => setState(() => _forbiddenCount = val),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60), backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => GameScreen(
                    duration: _timerDuration.toInt(), 
                    forbiddenLimit: _forbiddenCount.toInt(),
                    team1Name: _team1Controller.text,
                    team2Name: _team2Controller.text,
                  ))
                );
              },
              child: Text(uiText[lang]!['start']!, style: const TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }
}