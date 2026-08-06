import 'package:flutter/material.dart';
import '../../core/translations.dart';
import 'mafia_day.dart';
import 'mafia_settings.dart';

class MafiaNightScreen extends StatefulWidget {
  final Map<String, String> playerRoles;
  final List<String> alivePlayers;
  final KingMode kingMode;
  final List<String> detectiveHistory;
  final String? lastMafiaTarget; 
  final String? lastDoctorTarget;

  const MafiaNightScreen({
    super.key, 
    required this.playerRoles, 
    required this.alivePlayers, 
    required this.kingMode, 
    required this.detectiveHistory,
    this.lastMafiaTarget, 
    this.lastDoctorTarget,
  });

  @override
  State<MafiaNightScreen> createState() => _MafiaNightScreenState();
}

class _MafiaNightScreenState extends State<MafiaNightScreen> {
  int _playerIndex = 0; 
  int _kingStep = 0;    
  bool _isRevealed = false;
  String? _mafiaProposal;
  String? _doctorTarget;

  void _handleAction(String? target) {
    String lang = Localizations.localeOf(context).languageCode;
    String role = widget.kingMode == KingMode.none 
        ? widget.playerRoles[widget.alivePlayers[_playerIndex]]!
        : (_kingStep == 1 ? 'role_mafia' : _kingStep == 2 ? 'role_doctor' : 'role_detective');

    if (role == 'role_mafia' && target != null && target == widget.lastMafiaTarget) {
      _showSnack(uiText[lang]!['repeat_target_err']!);
      return;
    }
    if (role == 'role_doctor' && target != null && target == widget.lastDoctorTarget) {
      _showSnack(uiText[lang]!['repeat_target_err']!);
      return;
    }

    if (role == 'role_detective' && target != null) {
      _showDetectiveDialog(target, lang);
    } else {
      if (role == 'role_mafia') _mafiaProposal = target;
      if (role == 'role_doctor') _doctorTarget = target;
      _advance();
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _showDetectiveDialog(String target, String lang) {
    bool isM = widget.playerRoles[target] == 'role_mafia';
    String okBtnTxt = lang == 'ar' ? "حسناً" : (lang == 'he' ? "אישור" : "OK");

    showDialog(
      context: context, 
      barrierDismissible: false, 
      builder: (c) => AlertDialog(
        backgroundColor: isM ? Colors.red[900] : Colors.green[900],
        content: Text(
          isM ? uiText[lang]!['detective_yes']! : uiText[lang]!['detective_no']!, 
          textAlign: TextAlign.center, 
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
        ),
        actions: [Center(child: ElevatedButton(onPressed: () { Navigator.pop(c); _advance(); }, child: Text(okBtnTxt)))],
      )
    );
  }

  void _advance() {
    setState(() {
      if (widget.kingMode == KingMode.none) {
        _isRevealed = false;
        if (_playerIndex < widget.alivePlayers.length - 1) _playerIndex++; else _goToDay();
      } else {
        if (_kingStep < 3) _kingStep++; else _goToDay();
      }
    });
  }

  void _goToDay() {
    bool killed = _mafiaProposal != null && _mafiaProposal != _doctorTarget;
    if (killed) widget.alivePlayers.remove(_mafiaProposal);
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MafiaDayScreen(
      playerRoles: widget.playerRoles, 
      alivePlayers: widget.alivePlayers, 
      detectiveHistory: widget.detectiveHistory,
      kingMode: widget.kingMode, 
      killedTonight: killed ? _mafiaProposal : null,
      mafiaTarget: _mafiaProposal, 
      doctorTarget: _doctorTarget,
    )));
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    
    PreferredSizeWidget appBar = AppBar(
      title: Text(widget.kingMode != KingMode.none ? uiText[lang]!['king_hold_phone']! : uiText[lang]!['mafia_setup']!),
      backgroundColor: Colors.black,
      automaticallyImplyLeading: true, 
    );

    if (widget.kingMode != KingMode.none) {
      return Scaffold(backgroundColor: Colors.grey[900], appBar: appBar, body: _buildKingPanel(lang));
    }

    if (_playerIndex == 0 && !_isRevealed) {
      String okTxt = lang == 'ar' ? "حسناً" : (lang == 'he' ? "אישור" : "OK");
      return Scaffold(
        backgroundColor: Colors.black, 
        appBar: appBar,
        body: Center(child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.groups, color: Colors.amber, size: 80),
            Text(uiText[lang]!['sit_in_circle']!, style: const TextStyle(color: Colors.white, fontSize: 22), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: () => setState(() => _isRevealed = true), child: Text(okTxt)),
          ]),
        ))
      );
    }

    return Scaffold(backgroundColor: Colors.black, appBar: appBar, body: _isRevealed ? _buildPhoneUI(lang) : _buildPassUI(lang));
  }

  Widget _buildKingPanel(String lang) {
    List<String> prompts = [uiText[lang]!['everyone_sleep']!, uiText[lang]!['mafia_wake']!, uiText[lang]!['doctor_wake']!, uiText[lang]!['detective_wake']!];
    String nextStepTxt = lang == 'ar' ? "الخطوة التالية" : (lang == 'he' ? "שלב הבא" : "Next Step");
    String skipTxt = lang == 'ar' ? "تخطي" : (lang == 'he' ? "דלג" : "Skip");

    // Check if the specific roles are still alive for Ghost Action logic
    bool doctorAlive = widget.playerRoles.entries.any((e) => e.value == 'role_doctor' && widget.alivePlayers.contains(e.key));
    bool detectiveAlive = widget.playerRoles.entries.any((e) => e.value == 'role_detective' && widget.alivePlayers.contains(e.key));

    return Column(children: [
      Padding(padding: const EdgeInsets.all(30), child: Text(prompts[_kingStep], style: const TextStyle(color: Colors.amber, fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
      if (_kingStep > 0) 
        Expanded(
          child: Column(
            children: [
              if ((_kingStep == 2 && !doctorAlive) || (_kingStep == 3 && !detectiveAlive))
                Expanded(
                  child: Center(
                    child: Text(
                      lang == 'ar' ? "هذا الدور خارج اللعبة" : "This role is out.",
                      style: const TextStyle(color: Colors.white54, fontSize: 18),
                    ),
                  ),
                )
              else
                Expanded(child: _playerList(null)),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50), backgroundColor: Colors.white10),
                  onPressed: () => _handleAction(null), 
                  child: Text(skipTxt, style: const TextStyle(color: Colors.white))
                ),
              ),
            ],
          ),
        )
      else 
        Center(child: Padding(padding: const EdgeInsets.only(top: 50), child: ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)), onPressed: _advance, child: Text(nextStepTxt)))),
    ]);
  }

  Widget _buildPassUI(String lang) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(uiText[lang]!['pass_phone_to']!, style: const TextStyle(color: Colors.white, fontSize: 20)),
      Text(widget.alivePlayers[_playerIndex], style: const TextStyle(color: Colors.amber, fontSize: 44, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      ElevatedButton(onPressed: () => setState(() => _isRevealed = true), child: Text(uiText[lang]!['reveal_role_btn']!)),
    ]));
  }

  Widget _buildPhoneUI(String lang) {
    String curr = widget.alivePlayers[_playerIndex];
    String role = widget.playerRoles[curr]!;
    List<String> partners = widget.playerRoles.entries.where((e) => e.value == 'role_mafia' && e.key != curr).map((e) => e.key).toList();
    int mOrder = widget.alivePlayers.sublist(0, _playerIndex + 1).where((x) => widget.playerRoles[x] == 'role_mafia').length;
    int totalM = widget.playerRoles.values.where((v) => v == 'role_mafia').length;

    String instr = "";
    if (role == 'role_mafia') {
      if (totalM == 1) instr = uiText[lang]!['mafia_instr_solo']!;
      else if (mOrder == 1) instr = uiText[lang]!['mafia_instr_1']!.replaceFirst('{partner}', partners.join(', '));
      else instr = uiText[lang]!['mafia_instr_2']!.replaceFirst('{partner}', partners.join(', ')).replaceFirst('{target}', _mafiaProposal ?? "---");
    } else {
      String key = "${role.split("_")[1]}_instr";
      instr = uiText[lang]![key] ?? "";
    }

    String skipTxt = lang == 'ar' ? "تخطي" : (lang == 'he' ? "דלג" : "Skip");
    return Column(children: [
      const SizedBox(height: 60),
      Text(uiText[lang]![role]!, style: const TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold)),
      Padding(padding: const EdgeInsets.all(20), child: Text(instr, style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center)),
      Expanded(child: _playerList(curr)),
      Padding(padding: const EdgeInsets.only(bottom: 20), child: ElevatedButton(onPressed: () => _handleAction(null), child: Text(skipTxt))),
    ]);
  }

  Widget _playerList(String? current) {
    String activeRole = "";
    if (widget.kingMode != KingMode.none) {
      activeRole = (_kingStep == 1 ? 'role_mafia' : _kingStep == 2 ? 'role_doctor' : 'role_detective');
    } else if (current != null) {
      activeRole = widget.playerRoles[current]!;
    }

    return ListView(children: widget.alivePlayers.where((p) {
      if (p == current) return false;
      // Block Mafia friendly fire
      if (activeRole == 'role_mafia' && widget.playerRoles[p] == 'role_mafia') return false;
      // Block Detective self-check
      if (activeRole == 'role_detective' && widget.playerRoles[p] == 'role_detective') return false;
      
      return true;
    }).map((p) => Card(color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), child: ListTile(title: Text(p, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center), onTap: () => _handleAction(p)))).toList());
  }
}