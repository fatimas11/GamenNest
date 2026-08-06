// File: lib/games/undercover/undercover_settings.dart

import 'package:flutter/material.dart';
import '../../core/translations.dart';
import '../../core/game_data.dart';
import 'undercover_distribution.dart';

class UndercoverSettingsScreen extends StatefulWidget {
  final Function(String) onLanguageChange;
  const UndercoverSettingsScreen({super.key, required this.onLanguageChange});

  @override
  State<UndercoverSettingsScreen> createState() => _UndercoverSettingsScreenState();
}

class _UndercoverSettingsScreenState extends State<UndercoverSettingsScreen> {
  final List<TextEditingController> _playerControllers = [
    TextEditingController(), TextEditingController(), TextEditingController()
  ]; // Start with 3 players
  
  double _discussionTime = 60;
  double _imposterCount = 1;
  bool _isRandomImposters = false;
  String _selectedCategory = 'animals';

  void _addPlayerField() {
    setState(() => _playerControllers.add(TextEditingController()));
  }

  void _removePlayerField(int index) {
    setState(() {
      _playerControllers[index].dispose();
      _playerControllers.removeAt(index);
    });
  }

  // Algorithm to calculate max imposters based on player count
  double _getMaxImposters() {
    int count = _playerControllers.length;
    if (count <= 3) return 1.0;
    return (count / 2).floorToDouble(); // Max is half the players
  }

  void _startGame() {
    String lang = Localizations.localeOf(context).languageCode;
    
    List<String> playerNames = _playerControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (playerNames.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(uiText[lang]!['min_players_error'] ?? "Need 3 players!"), backgroundColor: Colors.red)
      );
      return;
    }

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => UndercoverDistributionScreen(
        players: playerNames,
        category: _selectedCategory,
        imposterCount: _isRandomImposters ? -1 : _imposterCount.toInt(),
        discussionTime: _discussionTime.toInt(),
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    double maxImposters = _getMaxImposters();
    if (_imposterCount > maxImposters) _imposterCount = maxImposters; // Auto-correct slider

    return Scaffold(
      appBar: AppBar(
        title: Text(uiText[lang]!['undercover_setup']!),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // SETTINGS CARD
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Category Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(uiText[lang]!['category']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          items: undercoverCategories.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(uiText[lang]!['cat_$key']!),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val!),
                        ),
                      ],
                    ),
                    const Divider(),
                    
                    // Discussion Time
                    Text("${uiText[lang]!['time']}: ${_discussionTime.toInt()} ${uiText[lang]!['sec']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Slider(
                      value: _discussionTime, min: 30, max: 180, divisions: 5, activeColor: Colors.orange,
                      onChanged: (val) => setState(() => _discussionTime = val),
                    ),
                    const Divider(),

                    // Imposter Setup (Random Checkbox + Slider)
                    SwitchListTile(
                      title: Text(uiText[lang]!['random_imposters']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      value: _isRandomImposters,
                      activeColor: Colors.orange,
                      onChanged: (val) => setState(() => _isRandomImposters = val),
                    ),
                    if (!_isRandomImposters) ...[
                      Text("${uiText[lang]!['imposter_count']}: ${_imposterCount.toInt()}", style: const TextStyle(fontSize: 16)),
                      Slider(
                        value: _imposterCount, min: 1, max: maxImposters < 1 ? 1 : maxImposters, 
                        divisions: maxImposters > 1 ? (maxImposters - 1).toInt() : 1,
                        activeColor: Colors.red,
                        onChanged: (val) => setState(() => _imposterCount = val),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // PLAYERS LIST
            Expanded(
              child: ListView.builder(
                itemCount: _playerControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _playerControllers[index],
                            decoration: InputDecoration(
                              labelText: "${uiText[lang]!['player_name']} ${index + 1}",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.orange),
                            ),
                          ),
                        ),
                        if (_playerControllers.length > 3) 
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removePlayerField(index),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], minimumSize: const Size(0, 50)),
                    icon: const Icon(Icons.add),
                    label: Text(uiText[lang]!['add_player']!),
                    onPressed: _addPlayerField,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(0, 50)),
                    onPressed: _startGame,
                    child: Text(uiText[lang]!['start']!, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}