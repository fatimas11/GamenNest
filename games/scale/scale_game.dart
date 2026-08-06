import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/translations.dart'; // ✅ Make sure this import is UNCOMMENTED

class HumanScaleGame extends StatefulWidget {
  final List<String> players;
  final Map<String, int>? initialScores; 

  const HumanScaleGame({super.key, required this.players, this.initialScores});

  @override
  State<HumanScaleGame> createState() => _HumanScaleGameState();
}

class _HumanScaleGameState extends State<HumanScaleGame> {
  int _step = 0; // 0: Intro, 1: Judge Rank, 2: Players Guess, 3: Round Summary, 4: Final Results
  late String _judgeName;
  late int _questionIndex;
  
  late List<String> _judgeOrder;
  late List<String> _guessOrder;
  
  late int _totalRights;
  late int _totalWrongs;
  
  int _lastRoundRights = 0;
  bool _hasPlayedPreviousRound = false;

  final Map<String, List<String>> _localizedQuestions = {
    'en': ["Who is the best cook?", "Who is the funniest?", "Who is the most organized?"],
    'ar': ["من هو أفضل طباخ؟", "من هو الشخص الأكثر مضحكاً؟", "من هو الأكثر ترتيباً؟"],
    'he': ["מי הבשלן הכי טוב?", "מי הבנאדם הכי מצחיק?", "מי הכי מאורגן?"],
  };

  @override
  void initState() {
    super.initState();
    _totalRights = widget.initialScores?['rights'] ?? 0;
    _totalWrongs = widget.initialScores?['wrongs'] ?? 0;
    _setupRound();
  }

  void _setupRound() {
    // 1. Pick Judge
    _judgeName = widget.players[Random().nextInt(widget.players.length)];
    
    // 2. Pick Question
    _questionIndex = Random().nextInt(_localizedQuestions['en']!.length);
    
    // 3. FIX: Create list of players EXCEPT judge
    _judgeOrder = widget.players.where((p) => p != _judgeName).toList();
    _judgeOrder.shuffle(); 
    
    // 4. Fresh copy for guessing
    _guessOrder = List.from(_judgeOrder);
  }

  void _processRoundEnd() {
    int currentRights = 0;
    for (int i = 0; i < _judgeOrder.length; i++) {
      if (_judgeOrder[i] == _guessOrder[i]) currentRights++;
    }
    
    _lastRoundRights = currentRights; 
    _totalRights += currentRights;
    _totalWrongs += (_judgeOrder.length - currentRights);
    _hasPlayedPreviousRound = true;
    
    setState(() => _step = 3);
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    String currentQuestion = (_localizedQuestions[lang] ?? _localizedQuestions['en']!)[_questionIndex];

    if (_step == 0) return _buildIntro(lang, currentQuestion);
    if (_step == 1) return _buildRankingStep(lang, currentQuestion, isJudge: true);
    if (_step == 2) return _buildRankingStep(lang, currentQuestion, isJudge: false);
    if (_step == 3) return _buildRoundSummary(lang);
    return _buildFinalResults(lang);
  }

  // PHASE 0: INTRO
  Widget _buildIntro(String lang, String question) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🏆 NEW: Show Previous Round Score
            if (_hasPlayedPreviousRound) ...[
               const Icon(Icons.history, color: Colors.blueGrey),
               Text("${lang == 'ar' ? 'التقييم السابق' : (lang == 'he' ? 'דירוג קודם' : 'Previous Rating')}: $_lastRoundRights / ${_judgeOrder.length}", 
                    style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
               const SizedBox(height: 20),
            ],
            Text(_judgeName, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.teal)),
            Text(uiText[lang]!['is_judge'] ?? "is the Judge!", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            Text(question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(200, 60)),
              onPressed: () => setState(() => _step = 1), 
              child: Text(uiText[lang]!['scale_submit'] ?? "Start", style: const TextStyle(color: Colors.white))
            )
          ],
        ),
      ),
    );
  }

  // PHASE 1 & 2: RANKING
  Widget _buildRankingStep(String lang, String question, {required bool isJudge}) {
    List<String> currentList = isJudge ? _judgeOrder : _guessOrder;
    return Scaffold(
      appBar: AppBar(
        title: Text(isJudge ? (uiText[lang]!['scale_desc'] ?? "Rank") : (uiText[lang]!['scale_guess'] ?? "Guess")),
        backgroundColor: isJudge ? Colors.teal : Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (old, newItem) => setState(() {
                if (newItem > old) newItem -= 1;
                final item = currentList.removeAt(old);
                currentList.insert(newItem, item);
              }),
              children: [
                for (int i = 0; i < currentList.length; i++)
                  Card(
                    // ✅ UNIQUE KEY FIX: ensures all players are rendered
                    key: ValueKey("player_${currentList[i]}_$i"), 
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${i + 1}")),
                      title: Text(currentList[i]),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 60)),
              onPressed: () => setState(() {
                if (isJudge) _step = 2; else _processRoundEnd();
              }),
              child: Text(uiText[lang]!['scale_submit'] ?? "Confirm", style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // PHASE 3: ROUND SUMMARY
  Widget _buildRoundSummary(String lang) {
    return Scaffold(
      appBar: AppBar(title: Text(lang == 'ar' ? 'نتائج الجولة' : 'סיכום סיבוב'), backgroundColor: Colors.blueGrey),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _judgeOrder.length,
              itemBuilder: (context, i) {
                bool isCorrect = _judgeOrder[i] == _guessOrder[i];
                return Card(
                  color: isCorrect ? Colors.green[50] : Colors.red[50],
                  child: ListTile(
                    leading: Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red),
                    title: Text("${lang == 'ar' ? 'تخمينك' : 'ניחוש'}: ${_guessOrder[i]}"),
                    subtitle: Text("${lang == 'ar' ? 'ترتيب القاضي' : 'דירוג השופט'}: ${_judgeOrder[i]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _setupRound();
                        _step = 0;
                      });
                    },
                    child: Text(uiText[lang]!['next_round'] ?? "Next"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () => setState(() => _step = 4),
                    child: Text(uiText[lang]!['finish_game'] ?? "Finish", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // PHASE 4: FINAL RESULTS
  Widget _buildFinalResults(String lang) {
    bool win = _totalRights > _totalWrongs;
    return Scaffold(
      backgroundColor: win ? Colors.green[100] : Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(win ? (uiText[lang]!['scale_win']!) : (uiText[lang]!['scale_lose']!), 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Text("✅ Total Correct: $_totalRights", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("❌ Total Wrong: $_totalWrongs", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
              onPressed: () => Navigator.pop(context), 
              child: const Text("Exit to Hub")
            ),
          ],
        ),
      ),
    );
  }
}