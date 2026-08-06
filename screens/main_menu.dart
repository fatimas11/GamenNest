// File: lib/screens/main_menu.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/games/scale/scale_setup.dart';
import '../core/translations.dart';
import '../games/taboo/taboo_settings.dart';
import '../games/charades/charades_settings.dart';
import '../games/mafia/mafia_settings.dart';
import '../games/undercover/undercover_settings.dart';
import '../games/bomb/bomb_game.dart';

class MainMenuScreen extends StatelessWidget {
  final Function(String) onLanguageChange;

  const MainMenuScreen({super.key, required this.onLanguageChange});

  // --- 📖 Scrollable Rules Dialog Helper ---
  void _showRules(BuildContext context, String gameKey, String lang) {
    String title = uiText[lang]?['game_$gameKey'] ?? gameKey;
    String rules = uiText[lang]?['rules_$gameKey'] ?? "Rules coming soon...";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title, 
          textAlign: TextAlign.center, 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        content: SizedBox(
          width: double.maxFinite, 
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Text(
              rules, 
              style: const TextStyle(fontSize: 18), 
              textAlign: TextAlign.center,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              lang == 'ar' ? 'إغلاق' : (lang == 'he' ? 'סגור' : 'Close'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(uiText[lang]?['hub_title'] ?? "Game Hub"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: onLanguageChange,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'ar', child: Text("العربية")),
              const PopupMenuItem(value: 'he', child: Text("עברית")),
              const PopupMenuItem(value: 'en', child: Text("English")),
            ],
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          // 1. TABOO
          _buildSquareButton(
            context,
            title: uiText[lang]?['game_taboo'] ?? "Taboo",
            color: Colors.blue,
            imagePath: "assets/images/games/taboo.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StartScreen(onLanguageChange: onLanguageChange))),
            onInfoTap: () => _showRules(context, 'taboo', lang),
          ),

          // 2. CHARADES
          _buildSquareButton(
            context,
            title: uiText[lang]?['game_charades'] ?? "Charades",
            color: Colors.green,
            imagePath: "assets/images/games/Charades.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CharadesSettingsScreen(onLanguageChange: onLanguageChange))),
            onInfoTap: () => _showRules(context, 'charades', lang),
          ),

          // 3. UNDERCOVER
          _buildSquareButton(
            context,
            title: uiText[lang]?['game_undercover'] ?? "Undercover",
            color: Colors.orange,
            imagePath: "assets/images/games/undercover.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UndercoverSettingsScreen(onLanguageChange: onLanguageChange))),
            onInfoTap: () => _showRules(context, 'undercover', lang),
          ),

          // 4. MAFIA
          _buildSquareButton(
            context,
            title: uiText[lang]?['game_mafia'] ?? "Mafia",
            color: Colors.red,
            imagePath: "assets/images/games/mafia.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MafiaSettingsScreen(onLanguageChange: onLanguageChange))),
            onInfoTap: () => _showRules(context, 'mafia', lang),
          ),

          // 5. THE BOMB
          _buildSquareButton(
            context,
            title: uiText[lang]?['game_bomb'] ?? "The Bomb",
            color: Colors.purple,
            imagePath: "assets/images/games/bomb.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BombGameScreen())),
            onInfoTap: () => _showRules(context, 'bomb', lang),
          ),

          // 6. HUMAN SCALE
          _buildSquareButton(
            context,
            title: uiText[lang]?['game_scale'] ?? "Scale",
            color: Colors.teal,
            imagePath: "assets/images/games/scale.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScaleSetupScreen())),
            onInfoTap: () => _showRules(context, 'scale', lang),
          ),
        ],
      ),
    );
  }

  // --- 🎨 Custom Game Button Widget ---
  Widget _buildSquareButton(BuildContext context, {
    required String title,
    required Color color,
    required VoidCallback onTap,
    required String imagePath,
    required VoidCallback onInfoTap,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            blurRadius: 8, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: Stack(
        children: [
          // 🖼️ Layer 1: The Image & Game Trigger
          Positioned.fill(
            child: GestureDetector(
              onTap: onTap,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: color,
                  child: const Icon(Icons.videogame_asset, color: Colors.white70, size: 40),
                ),
              ),
            ),
          ),
          
          // 🌚 Layer 2: Gradient for Readability
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
            ),
          ),

          // ℹ️ Layer 3: Info/Rules Button
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white, size: 26),
              onPressed: onInfoTap,
              tooltip: 'Rules',
            ),
          ),

          // ✍️ Layer 4: Title
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}