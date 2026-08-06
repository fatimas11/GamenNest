import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/game_data.dart';
import 'dart:async';
import 'dart:math';
import '../../core/translations.dart';

class GameScreen extends StatefulWidget {
  final int duration;
  final int forbiddenLimit;
  final String team1Name;
  final String team2Name;

  const GameScreen({
    super.key, 
    required this.duration, 
    required this.forbiddenLimit,
    required this.team1Name,
    required this.team2Name,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _timeLeft;
  int _team1Score = 0;
  int _team2Score = 0;
  int _roundNumber = 1;
  bool _isTeam1Turn = true; // Toggle between Team 1 and Team 2
  bool _isGameActive = false;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.duration;
    _currentIndex = Random().nextInt(sharedWordList.length);
  }

  void _startTurn() {
    setState(() {
      _timeLeft = widget.duration;
      _isGameActive = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        _endTurn();
      }
    });
  }

  void _nextWord(String action) {
    setState(() {
      if (action == 'correct') {
        // Current team guessed it
        if (_isTeam1Turn) _team1Score++; else _team2Score++;
      } else if (action == 'taboo') {
        // Violation! Opposing team gets the point per rules
        if (_isTeam1Turn) _team2Score++; else _team1Score++;
      }
      
      _currentIndex = Random().nextInt(sharedWordList.length);
    });
  }

  void _endTurn() {
    setState(() => _isGameActive = false);
    String lang = Localizations.localeOf(context).languageCode;

    // After Team 2 plays, a full round is finished
    if (!_isTeam1Turn) {
      _showRoundEndDialog(lang);
    } else {
      setState(() => _isTeam1Turn = false); // Move to Team 2's turn
    }
  }

  void _showRoundEndDialog(String lang) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(lang == 'ar' ? "نهاية الجولة $_roundNumber" : "End of Round $_roundNumber"),
        content: Text("${widget.team1Name}: $_team1Score\n${widget.team2Name}: $_team2Score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showWinner();
            }, 
            child: Text(lang == 'ar' ? "إنهاء اللعبة" : "Finish Game")
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _roundNumber++;
                _isTeam1Turn = true; // Reset back to Team 1 for next round
              });
            }, 
            child: Text(lang == 'ar' ? "جولة جديدة" : "Continue")
          ),
        ],
      ),
    );
  }

  void _showWinner() {
    String lang = Localizations.localeOf(context).languageCode;
    String winnerText = "";
    if (_team1Score > _team2Score) {
      winnerText = "${widget.team1Name} ${lang == 'ar' ? "يفوز!" : "Wins!"}";
    } else if (_team2Score > _team1Score) {
      winnerText = "${widget.team2Name} ${lang == 'ar' ? "يفوز!" : "Wins!"}";
    } else {
      winnerText = lang == 'ar' ? "تعادل!" : "It's a Tie!";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(uiText[lang]!['over']!),
        content: Text(winnerText, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    var currentCard = sharedWordList[_currentIndex];
    String mainWord = currentCard['word'][lang];
    List<String> displayForbidden = (currentCard['forbidden'][lang] as List<String>).take(widget.forbiddenLimit).toList();
    String currentTeam = _isTeam1Turn ? widget.team1Name : widget.team2Name;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.team1Name}: $_team1Score | ${widget.team2Name}: $_team2Score"),
        backgroundColor: _isTeam1Turn ? Colors.blue[100] : Colors.red[100],
      ),
      body: Center(
        child: !_isGameActive 
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lang == 'ar' ? "دور فريق:" : "Turn for:", style: const TextStyle(fontSize: 24)),
              Text(currentTeam, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startTurn,
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
                child: Text(uiText[lang]!['start']!),
              )
            ],
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Text("$_timeLeft", style: TextStyle(fontSize: 60, color: _timeLeft < 10 ? Colors.red : Colors.green)),
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text(mainWord, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
                        const Divider(height: 40, thickness: 2),
                        ...displayForbidden.map((w) => Text(w, style: const TextStyle(fontSize: 22, color: Colors.red))),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Opposing team shouts Taboo! -> Point goes to them
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: () => _nextWord('taboo'),
                      child: const Text("TABOO!", style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => _nextWord('correct'),
                      child: Text(uiText[lang]!['correct']!, style: const TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () => _nextWord('skip'),
                      child: Text(uiText[lang]!['skip']!),
                    ),
                  ],
                )
              ],
            ),
          ),
      ),
    );
  }
}