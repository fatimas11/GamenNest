import 'package:flutter/material.dart';
import '../../core/translations.dart';
import 'mafia_distribution.dart';

enum KingMode { assigned, random, none }

class PlayerSetup {
  TextEditingController controller = TextEditingController();
  bool isMale = true; 
}

class MafiaSettingsScreen extends StatefulWidget {
  final Function(String) onLanguageChange;
  const MafiaSettingsScreen({super.key, required this.onLanguageChange});

  @override
  State<MafiaSettingsScreen> createState() => _MafiaSettingsScreenState();
}

class _MafiaSettingsScreenState extends State<MafiaSettingsScreen> {
  final List<PlayerSetup> _playerSetups = [
    PlayerSetup(), PlayerSetup(), PlayerSetup(), PlayerSetup(), PlayerSetup()
  ];
  
  double _mafiaCount = 1;
  KingMode _kingMode = KingMode.random;

  void _startGame() {
    String lang = Localizations.localeOf(context).languageCode;
    List<String> names = [];
    List<bool> genders = [];

    for (var setup in _playerSetups) {
      String name = setup.controller.text.trim();
      if (name.isNotEmpty) {
        names.add(name);
        genders.add(setup.isMale);
      }
    }

    int min = (_kingMode == KingMode.none) ? 4 : 5;

    if (names.length < min) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(lang == 'ar' ? "تحتاج $min لاعبين على الأقل!" : (lang == 'he' ? "צריך לפחות $min שחקנים!" : "Need $min players!")),
        backgroundColor: Colors.red,
      ));
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (c) => MafiaDistributionScreen(
      players: names, 
      playerGenders: genders, 
      mafiaCount: _mafiaCount.toInt(), 
      discussionTime: 60, 
      kingMode: _kingMode
    )));
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    double maxM = (_playerSetups.length < 6) ? 2.0 : 3.0;
    if (_mafiaCount > maxM) _mafiaCount = maxM;

    return Scaffold(
      appBar: AppBar(title: Text(uiText[lang]!['mafia_setup']!), backgroundColor: Colors.black87, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          SegmentedButton<KingMode>(
            segments: [
              ButtonSegment(value: KingMode.none, label: Text(lang == 'ar' ? "بدون (الهاتف)" : (lang == 'he' ? "ללא (טלפון)" : "None (Phone)"))),
              ButtonSegment(value: KingMode.random, label: Text(lang == 'ar' ? "عشوائي" : (lang == 'he' ? "אקראי" : "Random"))),
              ButtonSegment(value: KingMode.assigned, label: Text(lang == 'ar' ? "محدد" : (lang == 'he' ? "נקבע מראש" : "Assigned"))),
            ],
            selected: {_kingMode},
            onSelectionChanged: (v) => setState(() => _kingMode = v.first),
          ),
          
          if (_kingMode == KingMode.assigned)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                lang == 'ar' ? "* اللاعب الأول سيكون هو الملك" : (lang == 'he' ? "* השחקן הראשון יהיה המלך" : "* The first player will be the King"),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

          // 📝 GENDER NOTE
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              lang == 'ar' 
                ? "اختر جنسك لتعديل البطاقة وفقاً لذلك" 
                : (lang == 'he' ? "בחר את המגדר שלך כדי להתאים את הכרטיס" : "Select your gender to adjust the card"),
              style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),
          Text("${uiText[lang]!['mafia_count']}: ${_mafiaCount.toInt()}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(value: _mafiaCount, min: 1, max: maxM, divisions: maxM.toInt()-1 > 0 ? maxM.toInt()-1 : 1, activeColor: Colors.red, onChanged: (v) => setState(() => _mafiaCount = v)),
          
          Expanded(child: ListView.builder(itemCount: _playerSetups.length, itemBuilder: (c, i) => Row(children: [
            IconButton(
              icon: Icon(
                _playerSetups[i].isMale ? Icons.male : Icons.female, 
                color: _playerSetups[i].isMale ? Colors.blue : Colors.pink
              ),
              onPressed: () => setState(() => _playerSetups[i].isMale = !_playerSetups[i].isMale),
            ),
            Expanded(
              child: TextField(
                controller: _playerSetups[i].controller, 
                decoration: InputDecoration(
                  labelText: "${uiText[lang]!['player_name']} ${i + 1}",
                  suffixIcon: (_kingMode == KingMode.assigned && i == 0) ? const Icon(Icons.star, color: Colors.amber) : null,
                )
              )
            ),
            IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => setState(() => _playerSetups.removeAt(i)))
          ]))),
          
          ElevatedButton(onPressed: () => setState(() => _playerSetups.add(PlayerSetup())), child: Text(uiText[lang]!['add_player']!)),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)), onPressed: _startGame, child: Text(uiText[lang]!['start']!, style: const TextStyle(color: Colors.white))),
        ]),
      ),
    );
  }
}