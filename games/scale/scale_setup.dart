import 'package:flutter/material.dart';
import 'scale_game.dart';

class ScaleSetupScreen extends StatefulWidget {
  const ScaleSetupScreen({super.key});

  @override
  State<ScaleSetupScreen> createState() => _ScaleSetupScreenState();
}

class _ScaleSetupScreenState extends State<ScaleSetupScreen> {
  final List<String> _players = [];
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _players.add(_nameController.text);
        _nameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Players")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "Player Name"),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addPlayer),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(_players[i]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _players.removeAt(i)),
                ),
              ),
            ),
          ),
          if (_players.length >= 3)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => HumanScaleGame(players: _players)
                  ));
                },
                child: const Text("Start Game"),
              ),
            ),
        ],
      ),
    );
  }
}