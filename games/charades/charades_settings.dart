import 'package:flutter/material.dart';
import '../../core/translations.dart'; 
import 'charades_game.dart'; 

class CharadesSettingsScreen extends StatefulWidget {
  final Function(String) onLanguageChange;
  const CharadesSettingsScreen({super.key, required this.onLanguageChange});

  @override
  State<CharadesSettingsScreen> createState() => _CharadesSettingsScreenState();
}

class _CharadesSettingsScreenState extends State<CharadesSettingsScreen> {
  double _timerDuration = 60;
  final TextEditingController _team1Controller = TextEditingController(text: "Team 1");
  final TextEditingController _team2Controller = TextEditingController(text: "Team 2");

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(uiText[lang]!['game_charades']!),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.theater_comedy, size: 100, color: Colors.green),
            const SizedBox(height: 30),
            
            // Team Name Inputs
            TextField(
              controller: _team1Controller,
              decoration: InputDecoration(
                labelText: lang == 'ar' ? "اسم الفريق 1" : "Team 1 Name",
                prefixIcon: const Icon(Icons.groups, color: Colors.green),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _team2Controller,
              decoration: InputDecoration(
                labelText: lang == 'ar' ? "اسم الفريق 2" : "Team 2 Name",
                prefixIcon: const Icon(Icons.groups, color: Colors.green),
              ),
            ),
            
            const SizedBox(height: 40),
            Text("${uiText[lang]!['time']}: ${_timerDuration.toInt()} ${uiText[lang]!['sec']}", 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Slider(
              value: _timerDuration,
              min: 5, max: 120, divisions: 23,
              activeColor: Colors.green,
              onChanged: (val) => setState(() => _timerDuration = val),
            ),
            
            const SizedBox(height: 50),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60), 
                backgroundColor: Colors.green, 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => CharadesGameScreen(
                    duration: _timerDuration.toInt(),
                    team1Name: _team1Controller.text,
                    team2Name: _team2Controller.text,
                  ))
                );
              },
              child: Text(uiText[lang]!['start']!, style: const TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}