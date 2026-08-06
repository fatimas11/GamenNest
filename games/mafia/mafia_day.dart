import 'package:flutter/material.dart';
import '../../core/translations.dart';
import 'mafia_night.dart';
import 'mafia_settings.dart';

class MafiaDayScreen extends StatefulWidget {
  final Map<String, String> playerRoles;
  final List<String> alivePlayers;
  final List<String> detectiveHistory;
  final KingMode kingMode;
  final String? killedTonight;
  final String? mafiaTarget;   
  final String? doctorTarget;  

  const MafiaDayScreen({
    super.key,
    required this.playerRoles,
    required this.alivePlayers,
    required this.detectiveHistory,
    required this.kingMode,
    this.killedTonight,
    this.mafiaTarget,
    this.doctorTarget,
  });

  @override
  State<MafiaDayScreen> createState() => _MafiaDayScreenState();
}

class _MafiaDayScreenState extends State<MafiaDayScreen> {
  int _dayStep = 0; 
  int _currentVoterIndex = 0;
  final Map<String, int> _voteTally = {};
  String? _eliminatedPlayer;
  String? _winner;

  void _castVote(String? target) {
    if (target != null) _voteTally[target] = (_voteTally[target] ?? 0) + 1;
    setState(() {
      if (_currentVoterIndex < widget.alivePlayers.length - 1) _currentVoterIndex++; else _calculateResults();
    });
  }

  void _calculateResults() {
    if (_voteTally.isNotEmpty) {
      var sortedVotes = _voteTally.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      if (!(sortedVotes.length > 1 && sortedVotes[0].value == sortedVotes[1].value)) {
        _eliminatedPlayer = sortedVotes[0].key;
        widget.alivePlayers.remove(_eliminatedPlayer);
      }
    }
    _checkWinCondition();
    _dayStep = 2;
  }

  void _checkWinCondition() {
    int mafiaAlive = widget.alivePlayers.where((p) => widget.playerRoles[p] == 'role_mafia').length;
    int citizensAlive = widget.alivePlayers.length - mafiaAlive;

    // 🏆 CITIZENS WIN: When all Mafia are gone
    if (mafiaAlive == 0) {
      _winner = 'citizens';
    } 
    // 🏆 MAFIA WINS: Only if there is exactly 1 non-mafia left
    else if (citizensAlive == 1 && mafiaAlive > 0) {
      _winner = 'mafia';
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(uiText[lang]?['day_phase'] ?? "Day Phase"), 
        backgroundColor: Colors.amber, 
        automaticallyImplyLeading: false
      ),
      body: _buildCurrentStep(lang),
    );
  }

  Widget _buildCurrentStep(String lang) {
    if (_dayStep == 0) return _buildAnnouncement(lang);
    if (_dayStep == 1) return _buildVotingLoop(lang);
    return _buildResults(lang);
  }

  Widget _buildAnnouncement(String lang) {
    bool nobodyDied = widget.killedTonight == null;
    bool wasSaved = nobodyDied && widget.mafiaTarget != null;

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(nobodyDied ? Icons.verified_user : Icons.person_off, size: 100, color: nobodyDied ? Colors.green : Colors.red),
        const SizedBox(height: 20),
        if (!nobodyDied) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              lang == 'ar' ? "عملية اغتيال ناجحة على \"${widget.killedTonight}\"" : "Successful assassination on ${widget.killedTonight}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        if (wasSaved)
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
            child: Text(
              lang == 'ar' 
                ? "عملية اغتيال فاشلة على \"${widget.mafiaTarget}\". هو بالتأكيد مواطن!" 
                : "Assassination failed on ${widget.mafiaTarget}. They are definitely a citizen!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        if (nobodyDied && !wasSaved)
          Text(lang == 'ar' ? "لم يمت أحد هذه الليلة" : "Nobody died tonight", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(200, 60)), 
          onPressed: () => setState(() => _dayStep = 1), 
          child: Text(uiText[lang]?['start_voting'] ?? "Start Voting", style: const TextStyle(color: Colors.white))
        ),
      ]),
    );
  }

  Widget _buildVotingLoop(String lang) {
    String voter = widget.alivePlayers[_currentVoterIndex];
    return Column(children: [
      Padding(padding: const EdgeInsets.all(25.0), child: Text("${uiText[lang]?['voter'] ?? 'Voter'}: $voter", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.amber))),
      Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: widget.alivePlayers.where((p) => p != voter).map((p) => Card(child: ListTile(title: Text(p, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center), onTap: () => _castVote(p)))).toList())),
      TextButton(onPressed: () => _castVote(null), child: Text(lang == 'ar' ? "تخطي" : (lang == 'he' ? "דלג" : "Skip"))),
      const SizedBox(height: 20),
    ]);
  }

  Widget _buildResults(String lang) {
    bool isM = _eliminatedPlayer != null && widget.playerRoles[_eliminatedPlayer] == 'role_mafia';
    
    // Multi-language strings for the Results step
    String tieMsg = lang == 'ar' ? "تعادل! لم يخرج أحد." : (lang == 'he' ? "תיקו! אף אחד לא עוזב." : "Tie! No one leaves.");
    String elimTitle = lang == 'ar' ? "تم استبعاد:" : (lang == 'he' ? "הודח:" : "Eliminated:");

    String revealMsg = "";
    if (_eliminatedPlayer != null) {
      if (lang == 'ar') revealMsg = isM ? "كان من المافيا! 🛑" : "كان مواطناً بريئاً! ✅";
      else if (lang == 'he') revealMsg = isM ? "היה מאפיה! 🛑" : "היה אזרח חף מפשע! ✅";
      else revealMsg = isM ? "Was Mafia! 🛑" : "Was a Citizen! ✅";
    }

    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_eliminatedPlayer == null ? tieMsg : elimTitle, style: const TextStyle(fontSize: 24)),
      if (_eliminatedPlayer != null) ...[
        Text(_eliminatedPlayer!, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(revealMsg, style: TextStyle(fontSize: 26, color: isM ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
      ],
      const SizedBox(height: 60),
      
      // Multi-language WINNER MESSAGE
      if (_winner != null) ...[
        Text(
          _winner == 'mafia' 
            ? (lang == 'ar' ? "فازت المافيا! 💀" : (lang == 'he' ? "המאפיה ניצחה! 💀" : "MAFIA WINS!")) 
            : (lang == 'ar' ? "فاز المواطنون! 🎉" : (lang == 'he' ? "האזרחים ניצחו! 🎉" : "CITIZENS WIN!")),
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: _winner == 'mafia' ? Colors.red : Colors.green),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],

      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(220, 60)),
        onPressed: () {
          if (_winner != null) {
            Navigator.of(context).popUntil((route) => route.isFirst); 
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => MafiaNightScreen(
                playerRoles: widget.playerRoles, 
                alivePlayers: widget.alivePlayers, 
                detectiveHistory: widget.detectiveHistory, 
                kingMode: widget.kingMode, 
                lastMafiaTarget: widget.mafiaTarget, 
                lastDoctorTarget: widget.doctorTarget
              )
            ));
          }
        },
        child: Text(
          _winner != null 
            ? (lang == 'ar' ? "الخروج للقائمة" : (lang == 'he' ? "יציאה לתפריט" : "Exit to Hub")) 
            : (lang == 'ar' ? "الليلة التالية" : (lang == 'he' ? "הלילה הבא" : "Next Night")),
          style: const TextStyle(color: Colors.white)
        ),
      )
    ]));
  }
}