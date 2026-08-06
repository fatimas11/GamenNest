import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:vibration/vibration.dart'; 
import '../../core/translations.dart';
import '../../core/game_data.dart';

class BombGameScreen extends StatefulWidget {
  const BombGameScreen({super.key});

  @override
  State<BombGameScreen> createState() => _BombGameScreenState();
}

class _BombGameScreenState extends State<BombGameScreen> with SingleTickerProviderStateMixin {
  bool _isTicking = false;
  bool _hasExploded = false;
  String _currentCategory = "";
  Timer? _timer;
  int _secondsLeft = 0;

  // Animation Controller
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. Initialize Controller immediately
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 2. Set default Bouncing Animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 3. Heartbeat Listener
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed && _isTicking) {
        _controller.forward();
      }
    });

    _pickNewCategory();
  }

  void _pickNewCategory() {
    setState(() {
      var keys = undercoverCategories.keys.toList();
      _currentCategory = keys[Random().nextInt(keys.length)];
      _hasExploded = false;
      _isTicking = false;
      
      _controller.stop();
      _controller.reset();
      
      // Reset to Bouncing scale
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    });
  }

  void _startBomb() {
    // 🎲 RANDOM TIME: 10 to 60 seconds
    int randomTime = Random().nextInt(51) + 10; 

    setState(() {
      _isTicking = true;
      _hasExploded = false;
      _secondsLeft = randomTime;
    });

    _controller.forward(); // Start visual heartbeat

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
        
        // Vibration pulse for the final 5-second panic
        if (_secondsLeft < 5) {
          _heartbeatVibration();
        }
      } else {
        _explode();
      }
    });
  }

  void _heartbeatVibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100);
    }
  }

  void _explode() async {
    _timer?.cancel();
    _controller.stop();
    
    setState(() {
      _isTicking = false;
      _hasExploded = true;
    });

    // 💥 IMPACT ANIMATION
    _controller.duration = const Duration(milliseconds: 150);
    _scaleAnimation = Tween<double>(begin: 0.1, end: 2.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [0, 500, 100, 1000]);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    Color bgColor = _hasExploded ? Colors.red : (_isTicking ? Colors.orange[50]! : Colors.white);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(uiText[lang]!['game_bomb'] ?? "The Bomb"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                uiText[lang]!['cat_$_currentCategory'] ?? _currentCategory,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              
              // ScaleTransition uses the _scaleAnimation we defined
              ScaleTransition(
                scale: _scaleAnimation,
                child: _buildBombIcon(),
              ),

              const SizedBox(height: 80),

              if (!_isTicking && !_hasExploded)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(220, 75),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _startBomb,
                  child: Text(
                    uiText[lang]!['bomb_start']!, 
                    style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),

              if (_hasExploded)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 2),
                    minimumSize: const Size(200, 60),
                  ),
                  onPressed: _pickNewCategory,
                  child: Text(
                    lang == 'ar' ? "التصنيف التالي" : "Next Round",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBombIcon() {
    if (_hasExploded) return const Text("💥", style: TextStyle(fontSize: 120));
    if (_isTicking) return const Icon(Icons.timer, size: 160, color: Colors.black);
    return const Icon(Icons.wb_sunny_outlined, size: 160, color: Colors.black12);
  }
}