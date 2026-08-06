// File: lib/games/undercover/undercover_distribution.dart

import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/translations.dart';
import '../../core/game_data.dart';
import 'undercover_game.dart';

class UndercoverDistributionScreen extends StatefulWidget {
  final List<String> players;
  final String category;
  final int imposterCount; // -1 for random
  final int discussionTime;
  final Map<String, int>? existingScores; // 🏆 ADDED: For tracking rounds

  const UndercoverDistributionScreen({
    super.key,
    required this.players,
    required this.category,
    required this.imposterCount,
    required this.discussionTime,
    this.existingScores, // 🏆 ADDED
  });

  @override
  State<UndercoverDistributionScreen> createState() => _UndercoverDistributionScreenState();
}

class _UndercoverDistributionScreenState extends State<UndercoverDistributionScreen> {
  int _currentIndex = 0;
  bool _isRevealed = false;
  
  late String _secretWordAr;
  late String _secretWordEn;
  late String _secretWordHe;
  late List<String> _imposterNames;
  late Map<String, int> _activeScores; // 🏆 ADDED

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    // 1. Initialize Scores: If we have existing ones, use them. Otherwise, start at 0.
    _activeScores = widget.existingScores ?? {for (var p in widget.players) p: 0};

    // 2. Pick the secret word
    var categoryWords = undercoverCategories[widget.category]!;
    var randomWord = categoryWords[Random().nextInt(categoryWords.length)];
    _secretWordAr = randomWord['ar']!;
    _secretWordEn = randomWord['en']!;
    _secretWordHe = randomWord['he']!;

    // 3. Determine imposter count
    int actualImposterCount = widget.imposterCount;
    if (actualImposterCount == -1) {
      // Random: between 1 and half the players (min 1)
      int maxLimit = (widget.players.length / 2).floor();
      actualImposterCount = Random().nextInt(maxLimit > 0 ? maxLimit : 1) + 1;
    }

    // 4. Assign imposters
    List<String> shuffledPlayers = List.from(widget.players)..shuffle();
    _imposterNames = shuffledPlayers.take(actualImposterCount).toList();
  }

  void _nextPlayer() {
    if (_currentIndex < widget.players.length - 1) {
      setState(() {
        _currentIndex++;
        _isRevealed = false;
      });
    } else {
      // Move to the Game/Timer Screen
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => UndercoverGamePage(
          players: widget.players,
          imposters: _imposterNames,
          wordAr: _secretWordAr,
          wordEn: _secretWordEn,
          wordHe: _secretWordHe,
          time: widget.discussionTime,
          category: widget.category,
          currentScores: _activeScores, // 🏆 PASSING SCORES HERE
        )
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    String currentPlayer = widget.players[_currentIndex];
    bool isImposter = _imposterNames.contains(currentPlayer);

    String wordToShow = lang == 'ar' ? _secretWordAr : (lang == 'he' ? _secretWordHe : _secretWordEn);

    return Scaffold(
      appBar: AppBar(
        title: Text(uiText[lang]!['game_undercover']!), 
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false, // Prevents accidental back button during secret phase
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${uiText[lang]!['pass_phone']} \n $currentPlayer",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => setState(() => _isRevealed = true),
                  child: Container(
                    width: 300, height: 350,
                    decoration: BoxDecoration(
                      color: _isRevealed ? Colors.white : Colors.orange[900],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 4),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: Center(
                      child: _isRevealed
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isImposter ? Icons.help_outline : Icons.wb_sunny, size: 80, color: Colors.orange),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    isImposter 
                                      ? uiText[lang]!['imposter_reveal']! 
                                      : "${uiText[lang]!['citizen_reveal']!}\n$wordToShow",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isImposter ? 30 : 26, 
                                      fontWeight: FontWeight.bold,
                                      color: isImposter ? Colors.red : Colors.black87
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(uiText[lang]!['tap_reveal']!, 
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (_isRevealed)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, 
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                    ),
                    onPressed: _nextPlayer,
                    child: Text(
                      _currentIndex == widget.players.length - 1 
                        ? uiText[lang]!['start_discussion']! 
                        : uiText[lang]!['hide_next']!,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}