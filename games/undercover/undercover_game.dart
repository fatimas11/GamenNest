// File: lib/games/undercover/undercover_game.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/translations.dart';
import '../../core/game_data.dart';
import 'undercover_distribution.dart'; 

class UndercoverGamePage extends StatefulWidget {
  final List<String> players;
  final List<String> imposters;
  final String wordAr;
  final String wordEn;
  final String wordHe;
  final int time;
  final String category;
  final Map<String, int> currentScores; 

  const UndercoverGamePage({
    super.key,
    required this.players,
    required this.imposters,
    required this.wordAr,
    required this.wordEn,
    required this.wordHe,
    required this.time,
    required this.category,
    required this.currentScores,
  });

  @override
  State<UndercoverGamePage> createState() => _UndercoverGamePageState();
}

class _UndercoverGamePageState extends State<UndercoverGamePage> {
  int _gameStep = 0; // 0: Timer, 1: Voting, 2: Reveal Imposters, 3: Guessing, 4: Scores
  late int _secondsLeft;
  Timer? _timer;

  int _voterIndex = 0;
  // Now storing a list of targets per voter
  Map<String, List<String>> _playerVotes = {}; 
  List<String> _selectedInCurrentVote = [];

  int _imposterGuessIndex = 0;
  List<String> _staticGuessOptions = []; 

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.time;
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_staticGuessOptions.isEmpty) {
      _prepareStaticOptions();
    }
  }

  void _prepareStaticOptions() {
    String lang = Localizations.localeOf(context).languageCode;
    String correctWord = lang == 'ar' ? widget.wordAr : (lang == 'he' ? widget.wordHe : widget.wordEn);
    
    List<String> allCategoryWords = undercoverCategories[widget.category]!
        .map((m) => m[lang]!)
        .where((w) => w != correctWord)
        .toList();
    
    allCategoryWords.shuffle();
    _staticGuessOptions = (allCategoryWords.take(3).toList()..add(correctWord))..shuffle();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) setState(() => _secondsLeft--);
      else { _timer?.cancel(); setState(() => _gameStep = 1); }
    });
  }

  void _confirmVote() {
    _playerVotes[widget.players[_voterIndex]] = List.from(_selectedInCurrentVote);
    setState(() {
      _selectedInCurrentVote.clear();
      if (_voterIndex < widget.players.length - 1) {
        _voterIndex++;
      } else {
        _calculateVotingPoints();
        _gameStep = 2; 
      }
    });
  }

  void _calculateVotingPoints() {
    bool isSingleImposter = widget.imposters.length == 1;

    _playerVotes.forEach((voter, targets) {
      bool voterIsImposter = widget.imposters.contains(voter);

      for (var target in targets) {
        bool targetIsImposter = widget.imposters.contains(target);

        if (targetIsImposter) {
          // Identify Imposter (Citizen or Imposter vs Imposter): +1
          widget.currentScores[voter] = (widget.currentScores[voter] ?? 0) + 1;
        } else {
          // Wrong Vote: -1 (Unless voter is the only imposter)
          if (voterIsImposter && isSingleImposter) {
            // No penalty for lone wolf
          } else {
            widget.currentScores[voter] = (widget.currentScores[voter] ?? 0) - 1;
          }
        }
      }
    });
  }

  void _handleImposterGuess(bool isCorrect) {
    String currentImposter = widget.imposters[_imposterGuessIndex];
    if (isCorrect) {
      widget.currentScores[currentImposter] = (widget.currentScores[currentImposter] ?? 0) + 1;
    } else {
      widget.currentScores[currentImposter] = (widget.currentScores[currentImposter] ?? 0) - 1;
    }

    setState(() {
      if (_imposterGuessIndex < widget.imposters.length - 1) {
        _imposterGuessIndex++;
      } else {
        _gameStep = 4;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    if (_gameStep == 0) return _buildTimerView(lang);
    if (_gameStep == 1) return _buildVotingView(lang);
    if (_gameStep == 2) return _buildRevealImpostersView(lang);
    if (_gameStep == 3) return _buildImposterGuessView(lang);
    return _buildScoreView(lang);
  }

  // PHASE 0: TIMER
  Widget _buildTimerView(String lang) {
    return Scaffold(
      appBar: AppBar(title: Text(uiText[lang]!['game_undercover']!), backgroundColor: Colors.orange),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$_secondsLeft", style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                setState(() => _gameStep = 1);
              }, 
              child: const Text("Skip Timer")
            )
          ],
        ),
      ),
    );
  }

  // PHASE 1: MULTI-VOTING
  Widget _buildVotingView(String lang) {
    String currentVoter = widget.players[_voterIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Secret Vote / تصويت سري"), backgroundColor: Colors.redAccent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("${uiText[lang]!['pass_phone']} $currentVoter\n(Select all suspects)", 
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: widget.players.where((p) => p != currentVoter).map((p) {
                bool isSelected = _selectedInCurrentVote.contains(p);
                return CheckboxListTile(
                  title: Text(p, style: const TextStyle(fontSize: 22)),
                  value: isSelected,
                  activeColor: Colors.red,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) _selectedInCurrentVote.add(p);
                      else _selectedInCurrentVote.remove(p);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 60)),
              onPressed: _confirmVote,
              child: const Text("Confirm Selection", style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  // PHASE 2: REVEAL IMPOSTERS
  Widget _buildRevealImpostersView(String lang) {
    return Scaffold(
      appBar: AppBar(title: const Text("The Imposters / المحتالون"), backgroundColor: Colors.black),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            ...widget.imposters.map((name) => Text(name, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red))),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(200, 60)),
              onPressed: () => setState(() => _gameStep = 3), 
              child: const Text("Next: Imposter Guess", style: TextStyle(fontSize: 20))
            )
          ],
        ),
      ),
    );
  }

  // PHASE 3: IMPOSTER GUESSING
  Widget _buildImposterGuessView(String lang) {
    String currentImposter = widget.imposters[_imposterGuessIndex];
    String correctWord = lang == 'ar' ? widget.wordAr : (lang == 'he' ? widget.wordHe : widget.wordEn);

    return Scaffold(
      appBar: AppBar(title: Text(uiText[lang]!['imposter_guess']!), backgroundColor: Colors.purple),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentImposter, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 30),
            ..._staticGuessOptions.map((opt) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(250, 60)),
                onPressed: () => _handleImposterGuess(opt == correctWord),
                child: Text(opt, style: const TextStyle(fontSize: 22)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // PHASE 4: SCOREBOARD
  Widget _buildScoreView(String lang) {
    var sortedEntries = widget.currentScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    String winner = sortedEntries.isNotEmpty ? sortedEntries.first.key : "";

    return Scaffold(
      appBar: AppBar(title: Text(uiText[lang]!['final_scores']!), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: sortedEntries.map((e) => ListTile(
                leading: e.key == winner ? const Icon(Icons.emoji_events, color: Colors.amber) : null,
                title: Text(e.key, style: const TextStyle(fontSize: 20)),
                trailing: Text("${e.value} ${uiText[lang]!['points']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: const Size(0, 60)),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => UndercoverDistributionScreen(
                          players: widget.players,
                          category: widget.category,
                          imposterCount: widget.imposters.length, 
                          discussionTime: widget.time,
                          existingScores: widget.currentScores, 
                        )
                      ));
                    },
                    child: const Text("Next Round", style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size(0, 60)),
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text("Quit", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}