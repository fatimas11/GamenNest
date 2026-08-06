import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/translations.dart';
import 'mafia_night.dart';
import 'mafia_settings.dart';

class MafiaDistributionScreen extends StatefulWidget {
  final List<String> players;
  final List<bool> playerGenders;
  final int mafiaCount;
  final int discussionTime;
  final KingMode kingMode;

  const MafiaDistributionScreen({
    super.key, 
    required this.players, 
    required this.playerGenders, 
    required this.mafiaCount, 
    required this.discussionTime, 
    required this.kingMode
  });

  @override
  State<MafiaDistributionScreen> createState() => _MafiaDistributionScreenState();
}

class _MafiaDistributionScreenState extends State<MafiaDistributionScreen> {
  int _currentIndex = 0;
  bool _isRevealed = false;
  late List<String> _assignedRoles;

  @override
  void initState() {
    super.initState();
    _assignRoles();
  }

  void _assignRoles() {
    List<String> deck = [];
    for (int i = 0; i < widget.mafiaCount; i++) deck.add('role_mafia');
    deck.add('role_doctor');
    deck.add('role_detective');
    if (widget.kingMode != KingMode.none) deck.add('role_king');
    while (deck.length < widget.players.length) deck.add('role_citizen');
    
    deck.shuffle();

    if (widget.kingMode == KingMode.assigned) {
      deck.remove('role_king');
      _assignedRoles = ['role_king', ...deck];
    } else {
      _assignedRoles = deck;
    }
  }

  String _getRoleImage(String role, bool isMale) {
    String gender = isMale ? "male" : "female";
    String basePath = "assets/images/mafia/";

    // FIX: Match your specific filename with double underscores for mafia_male
    if (role == 'role_mafia') {
      return isMale ? "${basePath}mafia__male.png" : "${basePath}mafia_female.png";
    }
    if (role == 'role_doctor') return "${basePath}doctor_$gender.png";
    if (role == 'role_detective') return "${basePath}detective_$gender.png";
    if (role == 'role_citizen') return "${basePath}citizen_$gender.png";
    if (role == 'role_king') return "${basePath}king_$gender.png";
    
    return "${basePath}cards_back.png"; 
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    String tapReveal = lang == 'ar' ? "إضغط للكشف" : (lang == 'he' ? "לחץ לחשיפה" : "Tap to Reveal");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Text(
              widget.players[_currentIndex], 
              style: const TextStyle(fontSize: 36, color: Colors.amber, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),
            
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: _isRevealed ? pi : 0),
              builder: (context, double value, child) {
                bool isBack = value < pi / 2;
                String currentImage = isBack 
                    ? "assets/images/mafia/cards_back.png" 
                    : _getRoleImage(_assignedRoles[_currentIndex], widget.playerGenders[_currentIndex]);

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value),
                  alignment: Alignment.center,
                  child: isBack 
                    ? _buildCardFront(currentImage, "") 
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi), 
                        child: _buildCardFront(
                          currentImage,
                          uiText[lang]![_assignedRoles[_currentIndex]]!
                        ),
                      ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            if (!_isRevealed) 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, 
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () => setState(() => _isRevealed = true), 
                child: Text(tapReveal, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            if (_isRevealed) 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: _nextPlayer, 
                child: Text(lang == 'ar' ? "التالي" : "Next", style: const TextStyle(fontSize: 20))
              ),
          ]
        )
      ),
    );
  }

  Widget _buildCardFront(String imgPath, String label) {
      return Container(
        key: ValueKey(imgPath), 
        width: 320, 
        height: 480,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(
            image: AssetImage(imgPath), 
            fit: BoxFit.cover,
          ),
        ),
        child: label.isEmpty 
            ? null 
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
      );
    }

  void _nextPlayer() {
    if (_currentIndex < widget.players.length - 1) {
      // FIX: Reset reveal state FIRST to close the card before moving to the next player
      setState(() => _isRevealed = false);
      
      // Short delay to let the card flip back to the "Bomb" side before changing name
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() { 
            _currentIndex++; 
          });
        }
      });
    } else {
      Map<String, String> mapped = Map.fromIterables(widget.players, _assignedRoles);
      _finishDistribution(mapped);
    }
  }

  void _finishDistribution(Map<String, String> mapped) {
    String lang = Localizations.localeOf(context).languageCode;
    if (widget.kingMode != KingMode.none) {
      String kingName = mapped.entries.firstWhere((e) => e.value == 'role_king').key;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          backgroundColor: Colors.amber[50],
          title: const Icon(Icons.stars, color: Colors.amber, size: 50),
          content: Text(
            uiText[lang]!['king_announce_body']!.replaceFirst('{name}', kingName),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(c);
                  _navigateToNight(mapped);
                }, 
                child: const Text("OK")
              )
            ),
          ],
        ),
      );
    } else {
      _navigateToNight(mapped);
    }
  }

  void _navigateToNight(Map<String, String> mapped) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (c) => MafiaNightScreen(
          playerRoles: mapped, 
          alivePlayers: widget.players.where((p) => mapped[p] != 'role_king').toList(), 
          kingMode: widget.kingMode, 
          detectiveHistory: const []
        )
      )
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final String label;
  CurvedTextPainter({required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Reversing the string for RTL processing
    final String processedLabel = label.split('').reversed.join();

    final textStyle = TextStyle(
      color: Colors.brown[900], // Dark brown for the gold ribbon
      fontSize: 24,
      fontWeight: FontWeight.w900,
      letterSpacing: 2.0,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.rtl,
    );

    // 2. THE GEOMETRY - Adjusted specifically for your card's gold ribbon
    double radius = 165; 
    // Start angle: pi * 0.5 is bottom center. 
    // We start a bit to the right (pi * 0.35) and move left for Arabic
    double startAngle = pi * 0.38; 

    // 3. THE CENTER POINT
    // We move the "center of the circle" higher up so the arc sits on the ribbon
    canvas.translate(size.width / 2, size.height * 0.65);

    for (int i = 0; i < processedLabel.length; i++) {
      String char = processedLabel[i];
      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();

      // Calculate the angle for each character
      double charAngle = i * (textPainter.width / (radius * 0.8));
      double currentAngle = startAngle + charAngle;

      canvas.save();
      
      // Move to the specific point on the curve
      double x = radius * cos(currentAngle);
      double y = radius * sin(currentAngle);
      canvas.translate(x, y);

      // Rotate the character so it stands upright on the curve
      // (currentAngle + pi/2) makes the base of the letter follow the line
      canvas.rotate(currentAngle + pi / 2);

      // Paint the character centered on its point
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}