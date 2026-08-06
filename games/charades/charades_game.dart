import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../core/translations.dart';
import '../../core/game_data.dart';

class CharadesGameScreen extends StatefulWidget {
  final int duration;
  final String team1Name;
  final String team2Name;
  
  const CharadesGameScreen({
    super.key, 
    required this.duration,
    required this.team1Name,
    required this.team2Name,
  });

  @override
  State<CharadesGameScreen> createState() => _CharadesGameScreenState();
}

class _CharadesGameScreenState extends State<CharadesGameScreen> {
  late int _timeLeft;
  int _team1Score = 0;
  int _team2Score = 0;
  int _roundNumber = 1;
  bool _isTeam1Turn = true;
  bool _isGameActive = false; // Turn hasn't started yet
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

  void _nextWord(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        if (_isTeam1Turn) _team1Score++; else _team2Score++;
      }
      _currentIndex = Random().nextInt(sharedWordList.length);
    });
  }

  void _endTurn() {
    setState(() => _isGameActive = false);
    String lang = Localizations.localeOf(context).languageCode;

    if (!_isTeam1Turn) {
      _showRoundEndDialog(lang);
    } else {
      setState(() => _isTeam1Turn = false); // Pass phone to Team 2
    }
  }

  void _showRoundEndDialog(String lang) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(lang == 'ar' ? "نهاية الجولة $_roundNumber" : "Round $_roundNumber Finished"),
        content: Text("${widget.team1Name}: $_team1Score\n${widget.team2Name}: $_team2Score", style: const TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalWinner(lang);
            }, 
            child: Text(lang == 'ar' ? "إنهاء" : "Finish")
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _roundNumber++;
                _isTeam1Turn = true;
              });
            }, 
            child: Text(lang == 'ar' ? "متابعة" : "Continue")
          ),
        ],
      ),
    );
  }

  void _showFinalWinner(String lang) {
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
            const SizedBox(height: 20),
            Text(winnerText, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); 
                  Navigator.pop(context); 
                },
                child: const Text("OK"))
          )
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
    String mainWord = sharedWordList[_currentIndex]['word'][lang];
    String currentTeam = _isTeam1Turn ? widget.team1Name : widget.team2Name;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.team1Name}: $_team1Score | ${widget.team2Name}: $_team2Score"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: !_isGameActive
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lang == 'ar' ? "دور فريق:" : "Turn for:", style: const TextStyle(fontSize: 24)),
              Text(currentTeam, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  lang == 'ar' ? "أعطِ الهاتف للممثل. لا تتحدث!" : "Give phone to performer. No speaking!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startTurn,
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60), backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: Text(uiText[lang]!['start']!, style: const TextStyle(fontSize: 24)),
              )
            ],
          )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$_timeLeft",
                style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft < 10 ? Colors.red : Colors.green)),
            
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    mainWord, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: Colors.black87)
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(140, 70)
                      ),
                      onPressed: () => _nextWord(true),
                      child: Text(uiText[lang]!['correct']!, style: const TextStyle(fontSize: 24))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(140, 70)
                      ),
                      onPressed: () => _nextWord(false),
                      child: Text(uiText[lang]!['skip']!, style: const TextStyle(fontSize: 24))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}