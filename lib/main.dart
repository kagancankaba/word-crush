//200201049 Kağan Can Kaba

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Crush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (!mounted) return;
    if (username != null && username.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
      );
    } else {
      await prefs.setInt('gold', 50000);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UsernameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _saveUsername() async {
    final username = _controller.text.trim();
    if (username.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Word Crush',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 48),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSubmitted: (_) => _saveUsername(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Devam Et',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  Future<void> _changeUsername(BuildContext context) async {
    final controller = TextEditingController(text: username);
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kullanıcı Adını Değiştir'),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(labelText: 'Yeni kullanıcı adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newName);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(username: newName)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => _changeUsername(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(username,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                      const SizedBox(width: 4),
                      const Icon(Icons.edit,
                          size: 16, color: Colors.deepPurple),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Word Crush',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                    const SizedBox(height: 48),
                    _MenuButton(
                      label: 'Yeni Oyun',
                      icon: Icons.play_arrow,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GameSetupScreen())),
                    ),
                    const SizedBox(height: 16),
                    _MenuButton(
                      label: 'Skor Tablosu',
                      icon: Icons.leaderboard,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScoreScreen())),
                    ),
                    const SizedBox(height: 16),
                    _MenuButton(
                      label: 'Market',
                      icon: Icons.store,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MarketScreen())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int? selectedGrid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Yeni Oyun'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Grid Boyutu Seç',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 32),
              _GridOption(
                  label: '6x6 Grid',
                  sublabel: 'Zor Seviye',
                  gridSize: 6,
                  selected: selectedGrid == 6,
                  onTap: () => setState(() => selectedGrid = 6)),
              const SizedBox(height: 16),
              _GridOption(
                  label: '8x8 Grid',
                  sublabel: 'Orta Seviye',
                  gridSize: 8,
                  selected: selectedGrid == 8,
                  onTap: () => setState(() => selectedGrid = 8)),
              const SizedBox(height: 16),
              _GridOption(
                  label: '10x10 Grid',
                  sublabel: 'Kolay Seviye',
                  gridSize: 10,
                  selected: selectedGrid == 10,
                  onTap: () => setState(() => selectedGrid = 10)),
              const SizedBox(height: 40),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  onPressed: selectedGrid == null
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MoveSelectScreen(
                                  gridSize: selectedGrid!))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Devam Et',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridOption extends StatelessWidget {
  final String label;
  final String sublabel;
  final int gridSize;
  final bool selected;
  final VoidCallback onTap;

  const _GridOption({
    required this.label,
    required this.sublabel,
    required this.gridSize,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple, width: 2),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.deepPurple)),
            Text(sublabel,
                style: TextStyle(
                    fontSize: 14,
                    color: selected ? Colors.white70 : Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class MoveSelectScreen extends StatefulWidget {
  final int gridSize;
  const MoveSelectScreen({super.key, required this.gridSize});

  @override
  State<MoveSelectScreen> createState() => _MoveSelectScreenState();
}

class _MoveSelectScreenState extends State<MoveSelectScreen> {
  int? selectedMoves;

  String get difficulty {
    if (widget.gridSize == 6) return 'Zor';
    if (widget.gridSize == 8) return 'Orta';
    return 'Kolay';
  }

  final List<Map<String, dynamic>> moveOptions = const [
    {'label': 'Kolay', 'moves': 25},
    {'label': 'Orta', 'moves': 20},
    {'label': 'Zor', 'moves': 15},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Hamle Sayısı'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Grid: ${widget.gridSize}x${widget.gridSize} ($difficulty)',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Hamle Sayısı Seç',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 32),
              ...moveOptions.map((option) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => selectedMoves = option['moves']),
                      child: Container(
                        width: 240,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: selectedMoves == option['moves']
                              ? Colors.deepPurple
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.deepPurple, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(option['label'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedMoves == option['moves']
                                        ? Colors.white
                                        : Colors.deepPurple)),
                            Text('${option['moves']} Hamle',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: selectedMoves == option['moves']
                                        ? Colors.white70
                                        : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 40),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  onPressed: selectedMoves == null
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GameScreen(
                                    gridSize: widget.gridSize,
                                    maxMoves: selectedMoves!,
                                  ))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Oyunu Başlat',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String toUpperCaseTR(String s) {
  return s
      .replaceAll('i', 'İ')
      .replaceAll('ı', 'I')
      .replaceAll('ğ', 'Ğ')
      .replaceAll('ü', 'Ü')
      .replaceAll('ş', 'Ş')
      .replaceAll('ö', 'Ö')
      .replaceAll('ç', 'Ç')
      .toUpperCase();
}

String toLowerCaseTR(String s) {
  return s
      .replaceAll('İ', 'i')
      .replaceAll('I', 'ı')
      .replaceAll('Ğ', 'ğ')
      .replaceAll('Ü', 'ü')
      .replaceAll('Ş', 'ş')
      .replaceAll('Ö', 'ö')
      .replaceAll('Ç', 'ç')
      .toLowerCase();
}

class LetterGenerator {
  static const Map<String, double> _frequencies = {
    'a': 12.046, 'e': 9.065, 'l': 8.077, 'i': 7.482, 'k': 7.178,
    'm': 5.835, 'r': 5.515, 'ı': 4.956, 't': 4.545, 'n': 4.209,
    's': 3.569, 'u': 2.755, 'b': 2.399, 'y': 2.301, 'd': 2.268,
    'ş': 2.209, 'o': 2.148, 'z': 1.892, 'ü': 1.872, 'c': 1.310,
    'ç': 1.299, 'p': 1.190, 'g': 1.155, 'h': 1.076, 'v': 1.054,
    'f': 0.811, 'ğ': 0.754, 'ö': 0.717, 'j': 0.132,
  };

  static List<String> generate(int count) {
    final random = Random();
    final letters = <String>[];
    final entries = _frequencies.entries.toList();
    final cumulative = <double>[];
    double total = 0;
    for (final entry in entries) {
      total += entry.value;
      cumulative.add(total);
    }
    for (int i = 0; i < count; i++) {
      final roll = random.nextDouble() * total;
      for (int j = 0; j < cumulative.length; j++) {
        if (roll <= cumulative[j]) {
          letters.add(entries[j].key);
          break;
        }
      }
    }
    return letters;
  }
}

class LetterScore {
  static const Map<String, int> _scores = {
    'a': 1, 'b': 3, 'c': 4, 'ç': 4, 'd': 3, 'e': 1, 'f': 7, 'g': 5,
    'ğ': 8, 'h': 5, 'ı': 2, 'i': 1, 'j': 10, 'k': 1, 'l': 1, 'm': 2,
    'n': 1, 'o': 2, 'ö': 7, 'p': 5, 'r': 1, 's': 2, 'ş': 4, 't': 1,
    'u': 2, 'ü': 3, 'v': 7, 'y': 3, 'z': 4,
  };

  static int calculate(String word) {
    int total = 0;
    for (final char in toLowerCaseTR(word).split('')) {
      total += _scores[char] ?? 0;
    }
    return total;
  }
}

class WordDictionary {
  static Set<String>? _words;

  static Future<void> load() async {
    if (_words != null) return;
    final raw = await rootBundle.loadString('assets/kelimeler.txt');
    _words = raw
        .split('\n')
        .map((w) => toLowerCaseTR(w.trim()))
        .where((w) => w.isNotEmpty)
        .toSet();
  }

  static bool contains(String word) {
    return _words?.contains(toLowerCaseTR(word)) ?? false;
  }
}

enum PowerType { row, bomb, column, mega }

class CellData {
  String? letter;
  PowerType? power;
  bool exploding;
  bool selected2;
  bool swapping;

  CellData({this.letter, this.power, this.exploding = false, this.selected2 = false, this.swapping = false});

  bool get isEmpty => letter == null;
  bool get hasPower => power != null;
  String get displayLetter => letter ?? '';

  String get powerSymbol {
    switch (power) {
      case PowerType.row: return '⇆';
      case PowerType.bomb: return '✹';
      case PowerType.column: return '⇅';
      case PowerType.mega: return '✪';
      default: return '';
    }
  }

  Color get powerColor {
    switch (power) {
      case PowerType.row: return Colors.blue;
      case PowerType.bomb: return Colors.orange;
      case PowerType.column: return Colors.green;
      case PowerType.mega: return Colors.red;
      default: return Colors.deepPurple;
    }
  }
}

PowerType? getPowerType(int wordLength) {
  if (wordLength == 4) return PowerType.row;
  if (wordLength == 5) return PowerType.bomb;
  if (wordLength == 6) return PowerType.column;
  if (wordLength >= 7) return PowerType.mega;
  return null;
}

class PowerInfo {
  final int index;
  final PowerType power;
  PowerInfo(this.index, this.power);
}

class GameScreen extends StatefulWidget {
  final int gridSize;
  final int maxMoves;

  const GameScreen({super.key, required this.gridSize, required this.maxMoves});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const bool kShowWordCount = true;

  String? _activeJoker;
  Map<String, int> _jokerStocks = {};

  late List<CellData> _cells;
  late int _remainingMoves;
  int _score = 0;
  int _wordCount = 0;
  int _availableWordCount = 0;
  String _longestWord = '';
  late DateTime _startTime;
  final List<int> _selectedIndices = [];
  final Map<int, Rect> _cellRects = {};
  bool _dictionaryLoaded = false;
  bool _isProcessing = false;
  String _lastMessage = '';
  Color _messageColor = Colors.deepPurple;

  final List<Map<String, dynamic>> _jokerList = [
    {'key': 'joker_balik', 'name': 'Balık', 'image': 'assets/images/balik.png'},
    {'key': 'joker_tekerlek', 'name': 'Tekerlek', 'image': 'assets/images/tekerlek.png'},
    {'key': 'joker_lolipop', 'name': 'Lolipop Kırıcı', 'image': 'assets/images/lolipop_kirici.png'},
    {'key': 'joker_serbest', 'name': 'Serbest Değiştirme', 'image': 'assets/images/serbest_degistirme.png'},
    {'key': 'joker_karistirma', 'name': 'Harf Karıştırma', 'image': 'assets/images/harf_karistirma.png'},
    {'key': 'joker_parti', 'name': 'Parti Güçlendiricisi', 'image': 'assets/images/parti_guclendiricisi.png'},
  ];

  @override
  void initState() {
    super.initState();
    _remainingMoves = widget.maxMoves;
    _startTime = DateTime.now();
    _cells = LetterGenerator.generate(widget.gridSize * widget.gridSize)
        .map((e) => CellData(letter: e))
        .toList();
    _loadDictionary();
  }

  Future<void> _loadDictionary() async {
    await WordDictionary.load();
    await _loadJokerStocks();
    setState(() => _dictionaryLoaded = true);
    if (kShowWordCount) await _regenerateIfNoWords();
  }

  List<String> _findSubWords(String word) {
    final Set<String> found = {};
    final n = word.length;
    for (int i = 0; i < n; i++) {
      for (int j = i + 3; j <= n; j++) {
        final sub = word.substring(i, j);
        if (sub != word && WordDictionary.contains(sub)) {
          found.add(sub);
        }
      }
    }
    return found.toList();
  }

  Future<void> _loadJokerStocks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _jokerStocks = {
        'joker_balik': prefs.getInt('joker_balik') ?? 0,
        'joker_tekerlek': prefs.getInt('joker_tekerlek') ?? 0,
        'joker_lolipop': prefs.getInt('joker_lolipop') ?? 0,
        'joker_serbest': prefs.getInt('joker_serbest') ?? 0,
        'joker_karistirma': prefs.getInt('joker_karistirma') ?? 0,
        'joker_parti': prefs.getInt('joker_parti') ?? 0,
      };
    });
  }

  void _handleJokerCellTap(int index) async {
    if (_activeJoker == 'joker_tekerlek') {
      await _useTekerlek(index);
    } else if (_activeJoker == 'joker_lolipop') {
      await _useLolipop(index);
    } else if (_activeJoker == 'joker_serbest') {
      await _useSerbestSecim(index);
    }
  }

  Future<void> _consumeJoker(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final newStock = (_jokerStocks[key] ?? 1) - 1;
    await prefs.setInt(key, newStock);
    setState(() {
      _jokerStocks[key] = newStock;
      _activeJoker = null;
    });
  }

  Future<void> _useBalik() async {
    _isProcessing = true;
    final nonEmptyIndices = List.generate(_cells.length, (i) => i)
        .where((i) => !_cells[i].isEmpty)
        .toList()..shuffle();
    final toRemove = nonEmptyIndices.take(6).toList();

    setState(() {
      for (final i in toRemove) {
        _cells[i].exploding = true;
      }
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      for (final i in toRemove) {
        _cells[i] = CellData();
      }
      _lastMessage = '🐟 Balık: 6 harf yok edildi!';
      _messageColor = Colors.blue;
    });

    _applyGravity();
    await _consumeJoker('joker_balik');
    if (kShowWordCount) _updateWordCount();
    _isProcessing = false;
  }

  Future<void> _useTekerlek(int index) async {
    _isProcessing = true;
    final row = index ~/ widget.gridSize;
    final col = index % widget.gridSize;
    final Set<int> toRemove = {};

    for (int c = 0; c < widget.gridSize; c++) {
      toRemove.add(row * widget.gridSize + c);
    }
    for (int r = 0; r < widget.gridSize; r++) {
      toRemove.add(r * widget.gridSize + col);
    }

    setState(() {
      for (final i in toRemove) {
        if (!_cells[i].isEmpty) _cells[i].exploding = true;
      }
      _lastMessage = '☸️ Tekerlek: Satır ve sütun temizlendi!';
      _messageColor = Colors.orange;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      for (final i in toRemove) {
        _cells[i] = CellData();
      }
    });

    _applyGravity();
    await _consumeJoker('joker_tekerlek');
    if (kShowWordCount) _updateWordCount();
    _isProcessing = false;
  }

  Future<void> _useLolipop(int index) async {
    _isProcessing = true;

    setState(() {
      _cells[index].exploding = true;
      _lastMessage = '🍭 Lolipop: Harf yok edildi!';
      _messageColor = Colors.pink;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _cells[index] = CellData();
    });

    _applyGravity();
    await _consumeJoker('joker_lolipop');
    if (kShowWordCount) _updateWordCount();
    _isProcessing = false;
  }

  int? _serbestFirstIndex;

  Future<void> _useSerbestSecim(int index) async {
    if (_serbestFirstIndex == null) {
      setState(() {
        _serbestFirstIndex = index;
        _cells[index] = CellData(letter: _cells[index].letter, power: _cells[index].power, selected2: true);
        _lastMessage = 'Değiştirmek istediğiniz 2. harfi seçin';
        _messageColor = Colors.purple;
      });
      return;
    }

    final first = _serbestFirstIndex!;
    _serbestFirstIndex = null;

    if (!_isNeighbor(first, index)) {
      setState(() {
        _cells[first] = CellData(letter: _cells[first].letter, power: _cells[first].power);
        _lastMessage = 'Harfler komşu olmalı! Tekrar seçin.';
        _messageColor = Colors.red;
        _serbestFirstIndex = null;
      });
      return;
    }

    _isProcessing = true;

    setState(() {
      _cells[index] = CellData(letter: _cells[index].letter, power: _cells[index].power, selected2: true);
    });

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    setState(() {
      _cells[first] = CellData(letter: _cells[first].letter, power: _cells[first].power, swapping: true);
      _cells[index] = CellData(letter: _cells[index].letter, power: _cells[index].power, swapping: true);
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final tempLetter = _cells[first].letter;
    final tempPower = _cells[first].power;

    setState(() {
      _cells[first] = CellData(letter: _cells[index].letter, power: _cells[index].power);
      _cells[index] = CellData(letter: tempLetter, power: tempPower);
      _lastMessage = '🔀 Serbest Değiştirme: Harfler yer değiştirdi!';
      _messageColor = Colors.purple;
    });

    await _consumeJoker('joker_serbest');
    if (kShowWordCount) _updateWordCount();
    _isProcessing = false;
  }

  Future<void> _useHarfKaristirma() async {
    _isProcessing = true;

    final nonEmptyIndices = List.generate(_cells.length, (i) => i)
        .where((i) => !_cells[i].isEmpty)
        .toList();

    final letters = nonEmptyIndices
        .map((i) => MapEntry(i, _cells[i]))
        .toList()..shuffle();

    setState(() {
      for (int i = 0; i < nonEmptyIndices.length; i++) {
        _cells[nonEmptyIndices[i]] = letters[i].value;
      }
      _lastMessage = '🔀 Harf Karıştırma: Grid karıştırıldı!';
      _messageColor = Colors.teal;
    });

    await _consumeJoker('joker_karistirma');
    if (kShowWordCount) _updateWordCount();
    _isProcessing = false;
  }

  Future<void> _usePartiGuclendiricisi() async {
    _isProcessing = true;

    setState(() {
      for (int i = 0; i < _cells.length; i++) {
        _cells[i].exploding = true;
      }
      _lastMessage = '🎉 Parti: Tüm grid yenileniyor!';
      _messageColor = Colors.purple;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _cells = LetterGenerator.generate(widget.gridSize * widget.gridSize)
          .map((e) => CellData(letter: e))
          .toList();
    });

    await _consumeJoker('joker_parti');
    if (kShowWordCount) _updateWordCount();
    _isProcessing = false;
  }

  bool _isNeighbor(int a, int b) {
    final rowA = a ~/ widget.gridSize;
    final colA = a % widget.gridSize;
    final rowB = b ~/ widget.gridSize;
    final colB = b % widget.gridSize;
    return (rowA - rowB).abs() <= 1 &&
        (colA - colB).abs() <= 1 &&
        a != b;
  }

  int? _getIndexAtPosition(Offset globalPos) {
    for (final entry in _cellRects.entries) {
      if (!_cells[entry.key].isEmpty && entry.value.contains(globalPos)) {
        return entry.key;
      }
    }
    return null;
  }

  void _onPanStart(DragStartDetails details) {
    if (_isProcessing) return;
    final index = _getIndexAtPosition(details.globalPosition);
    if (index == null) return;

    if (_activeJoker != null) {
      if (_activeJoker != 'joker_serbest') {
        _handleJokerCellTap(index);
      }
      return;
    }

    setState(() {
      _selectedIndices.clear();
      _selectedIndices.add(index);
      _lastMessage = '';
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isProcessing) return;
    final index = _getIndexAtPosition(details.globalPosition);
    if (index == null || _selectedIndices.contains(index)) return;
    if (_selectedIndices.isEmpty) return;
    if (_isNeighbor(_selectedIndices.last, index)) {
      setState(() => _selectedIndices.add(index));
    }
  }

  void _onPanEnd(DragEndDetails details) async {
    if (_isProcessing) return;

    if (_selectedIndices.length < 3) {
      setState(() {
        _lastMessage = 'En az 3 harf seçmelisiniz!';
        _messageColor = Colors.orange;
        _selectedIndices.clear();
      });
      return;
    }

    final selectedCopy = List<int>.from(_selectedIndices);
    final word = selectedCopy.map((i) => _cells[i].letter ?? '').join();
    final isValid = WordDictionary.contains(word);

    _remainingMoves--;
    _isProcessing = true;
    setState(() => _selectedIndices.clear());

    if (isValid) {
      final wordScore = LetterScore.calculate(word);
      if (word.length > _longestWord.length) _longestWord = word;

      final comboWords = _findSubWords(word);
      int comboScore = 0;
      for (final sub in comboWords) {
        comboScore += LetterScore.calculate(sub);
      }
      final totalWordScore = wordScore + comboScore;

      final List<PowerInfo> triggeredPowers = [];
      for (final i in selectedCopy) {
        if (_cells[i].hasPower) {
          triggeredPowers.add(PowerInfo(i, _cells[i].power!));
        }
      }

      final newPowerType = getPowerType(selectedCopy.length);
      final lastIndex = selectedCopy.last;
      final lastLetter = _cells[lastIndex].letter;

      setState(() {
        _score += totalWordScore;
        _wordCount++;
        _lastMessage = comboWords.isEmpty
            ? '✓ "${toUpperCaseTR(word)}" +$totalWordScore puan!'
            : '✓ ${([word, ...comboWords].map((w) => toUpperCaseTR(w)).join(', '))} → ${comboWords.length + 1}x Combo! +$totalWordScore puan!';
        _messageColor = Colors.green;
        for (final i in selectedCopy) {
          _cells[i].exploding = true;
        }
      });

      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      setState(() {
        for (final i in selectedCopy) {
          _cells[i] = CellData();
        }
        if (newPowerType != null) {
          _cells[lastIndex] = CellData(letter: lastLetter, power: newPowerType);
        }
      });

      _applyGravity();

      for (final powerInfo in triggeredPowers) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        await _executePower(powerInfo.index, powerInfo.power);
      }
    } else {
      setState(() {
        _lastMessage = '✗ "${toUpperCaseTR(word)}" sözlükte yok!';
        _messageColor = Colors.red;
      });
    }

    _isProcessing = false;

    if (_remainingMoves <= 0) {
      Future.delayed(const Duration(milliseconds: 400), _saveAndShowGameOver);
    } else if (isValid) {
      if (kShowWordCount) _updateWordCount();
    }
  }

  Future<void> _executePower(int index, PowerType power) async {
    final row = index ~/ widget.gridSize;
    final col = index % widget.gridSize;
    final Set<int> toExplode = {};

    String powerMsg = '';
    switch (power) {
      case PowerType.row:
        for (int c = 0; c < widget.gridSize; c++) {
          toExplode.add(row * widget.gridSize + c);
        }
        powerMsg = ' 🔵 Satır temizlendi!';
        break;
      case PowerType.bomb:
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            final nr = row + dr;
            final nc = col + dc;
            if (nr >= 0 && nr < widget.gridSize && nc >= 0 && nc < widget.gridSize) {
              toExplode.add(nr * widget.gridSize + nc);
            }
          }
        }
        powerMsg = ' 🟠 Alan patlatıldı!';
        break;
      case PowerType.column:
        for (int r = 0; r < widget.gridSize; r++) {
          toExplode.add(r * widget.gridSize + col);
        }
        powerMsg = ' 🟢 Sütun temizlendi!';
        break;
      case PowerType.mega:
        for (int dr = -2; dr <= 2; dr++) {
          for (int dc = -2; dc <= 2; dc++) {
            final nr = row + dr;
            final nc = col + dc;
            if (nr >= 0 && nr < widget.gridSize && nc >= 0 && nc < widget.gridSize) {
              toExplode.add(nr * widget.gridSize + nc);
            }
          }
        }
        powerMsg = ' 🔴 Mega patlama!';
        break;
    }

    setState(() {
      _lastMessage += powerMsg;
      for (final i in toExplode) {
        if (!_cells[i].isEmpty) _cells[i].exploding = true;
      }
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      for (final i in toExplode) {
        _cells[i] = CellData();
      }
    });

    _applyGravity();
  }

  void _applyGravity() {
    setState(() {
      for (int col = 0; col < widget.gridSize; col++) {
        List<CellData> column = [];
        for (int row = 0; row < widget.gridSize; row++) {
          column.add(_cells[row * widget.gridSize + col]);
        }
        List<CellData> nonEmpty = column.where((e) => !e.isEmpty).toList();
        int emptyCount = widget.gridSize - nonEmpty.length;
        List<CellData> newLetters = LetterGenerator.generate(emptyCount)
            .map((e) => CellData(letter: e))
            .toList();
        List<CellData> newColumn = [...newLetters, ...nonEmpty];
        for (int row = 0; row < widget.gridSize; row++) {
          _cells[row * widget.gridSize + col] = newColumn[row];
        }
      }
    });
  }

  Future<int> _countAvailableWords() async {
    final Map<String, int> foundWords = {};
    final int total = widget.gridSize * widget.gridSize;

    for (int start = 0; start < total; start++) {
      if (_cells[start].isEmpty) continue;
      await _dfs(start, '', {start}, foundWords, start);
    }

    final sortedWords = foundWords.entries.toList()
      ..sort((a, b) => LetterScore.calculate(a.key).compareTo(LetterScore.calculate(b.key)));

    for (final entry in sortedWords) {
      final word = entry.key;
      final startIdx = entry.value;
      final row = startIdx ~/ widget.gridSize;
      final col = startIdx % widget.gridSize;
      final score = LetterScore.calculate(word);
      debugPrint('Kelime: ${toUpperCaseTR(word)} | Baş harf: ${toUpperCaseTR(word[0])} | Satır: ${row + 1} Sütun: ${col + 1} | Puan: $score');
    }

    return foundWords.length;
  }

  Future<void> _dfs(
    int index,
    String current,
    Set<int> visited,
    Map<String, int> found,
    int startIndex,
  ) async {
    final letter = _cells[index].letter ?? '';
    final word = current + letter;

    if (word.length >= 3 && WordDictionary.contains(word)) {
      if (!found.containsKey(word)) {
        found[word] = startIndex;
      }
    }

    if (word.length >= 7) return;

    final row = index ~/ widget.gridSize;
    final col = index % widget.gridSize;

    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = row + dr;
        final nc = col + dc;
        if (nr < 0 || nr >= widget.gridSize) continue;
        if (nc < 0 || nc >= widget.gridSize) continue;
        final ni = nr * widget.gridSize + nc;
        if (visited.contains(ni)) continue;
        if (_cells[ni].isEmpty) continue;
        await _dfs(ni, word, {...visited, ni}, found, startIndex);
      }
    }
  }

  Future<void> _regenerateIfNoWords() async {
    int count = await _countAvailableWords();
    int attempts = 0;
    while (count == 0 && attempts < 10) {
      _cells = LetterGenerator.generate(widget.gridSize * widget.gridSize)
          .map((e) => CellData(letter: e))
          .toList();
      count = await _countAvailableWords();
      attempts++;
    }
    setState(() => _availableWordCount = count);
  }

  void _updateWordCount() {
    _countAvailableWords().then((count) {
      if (!mounted) return;
      setState(() => _availableWordCount = count);
      if (count == 0) _regenerateIfNoWords();
    });
  }

  Future<void> _saveAndShowGameOver() async {
    if (!mounted) return;
    final durationSeconds = DateTime.now().difference(_startTime).inSeconds;
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Oyuncu';
    final currentGold = prefs.getInt('gold') ?? 50000;
    final newGold = currentGold + _score;
    await prefs.setInt('gold', newGold);

    final existing = prefs.getStringList('game_records') ?? [];
    final gameNumber = existing.length + 1;
    final record = GameRecord(
      gameNumber: gameNumber,
      username: username,
      date: DateTime.now(),
      gridSize: widget.gridSize,
      score: _score,
      wordCount: _wordCount,
      longestWord: _longestWord.isEmpty ? '-' : _longestWord,
      durationSeconds: durationSeconds,
    );
    existing.add(record.toJson());
    await prefs.setStringList('game_records', existing);

    if (!mounted) return;
    _showGameOver(durationSeconds, newGold);
  }

  void _showGameOver(int durationSeconds, int newGold) {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Oyun Bitti!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ResultRow('Toplam Puan', '$_score'),
            _ResultRow('Bulunan Kelime', '$_wordCount'),
            _ResultRow('En Uzun Kelime',
                _longestWord.isEmpty ? '-' : toUpperCaseTR(_longestWord)),
            _ResultRow('Süre', '$m dk $s sn'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text('+$_score altın! (Toplam: $newGold)',
                    style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('Ana Menü', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String get _currentWord =>
      _selectedIndices.map((i) => _cells[i].letter ?? '').join();

  Widget _buildCell(int index) {
    final cell = _cells[index];
    final isSelected = _selectedIndices.contains(index);
    final selectionOrder = isSelected ? _selectedIndices.indexOf(index) + 1 : 0;
    final fontSize = widget.gridSize == 10 ? 11.0 : 15.0;

    if (cell.isEmpty) {
      return MeasureSize(
        onChange: (size, offset) => _cellRects[index] = offset & size,
        child: const SizedBox(),
      );
    }

    final hasPower = cell.hasPower;
    final isExploding = cell.exploding;
    final isSelected2 = cell.selected2;
    final isSwapping = cell.swapping;
    final powerColor = cell.powerColor;

    return MeasureSize(
      onChange: (size, offset) => _cellRects[index] = offset & size,
      child: GestureDetector(
        onTap: () {
          if (_activeJoker == 'joker_serbest' && !_isProcessing) {
            _handleJokerCellTap(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isExploding
                ? Colors.red
                : isSwapping
                    ? Colors.green
                    : isSelected2
                        ? Colors.amber
                        : isSelected
                            ? Colors.deepPurple
                            : hasPower
                                ? powerColor.withValues(alpha: 0.15)
                                : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isExploding
                  ? Colors.red[800]!
                  : isSelected
                      ? Colors.deepPurple
                      : hasPower
                          ? powerColor
                          : Colors.deepPurple.withValues(alpha: 0.3),
              width: isExploding || isSelected || hasPower ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isExploding
                    ? Colors.red.withValues(alpha: 0.6)
                    : isSelected
                        ? Colors.deepPurple.withValues(alpha: 0.4)
                        : hasPower
                            ? powerColor.withValues(alpha: 0.3)
                            : Colors.deepPurple.withValues(alpha: 0.08),
                blurRadius: isExploding ? 10 : isSelected || hasPower ? 6 : 3,
                offset: Offset(0, isSelected ? 2 : 1),
              )
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      toUpperCaseTR(cell.displayLetter),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: isExploding
                            ? Colors.white
                            : isSelected
                                ? Colors.white
                                : hasPower
                                    ? powerColor
                                    : Colors.deepPurple,
                      ),
                    ),
                    if (hasPower && !isExploding)
                      Text(
                        cell.powerSymbol,
                        style: TextStyle(
                          fontSize: fontSize - 3,
                          color: isSelected ? Colors.white : powerColor,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected && !isExploding)
                Positioned(
                  top: 2,
                  right: 4,
                  child: Text('$selectionOrder',
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold)),
                ),
              if (!hasPower && !isExploding)
                Positioned(
                  bottom: 2,
                  right: 4,
                  child: Text(
                    '${LetterScore.calculate(cell.displayLetter)}',
                    style: TextStyle(
                      fontSize: 8,
                      color: isSelected
                          ? Colors.white60
                          : Colors.deepPurple.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_dictionaryLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final itemWidth = (MediaQuery.of(context).size.width - 32) / 6;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Oyundan Çık'),
            content: const Text('Çıkmak istediğinize emin misiniz? Mevcut sonucunuz kaydedilecek.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hayır'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Evet', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          await _saveAndShowGameOver();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text('${widget.gridSize}x${widget.gridSize} Grid'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text('$_score',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _jokerList.map((joker) {
                  final key = joker['key'] as String;
                  final stock = _jokerStocks[key] ?? 0;
                  final isActive = _activeJoker == key;
                  return GestureDetector(
                    onTap: () {
                      if (stock <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${joker['name']} stoğunuz yok!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        return;
                      }
                      if (key == 'joker_balik') {
                        _useBalik();
                        return;
                      }
                      if (key == 'joker_karistirma') {
                        _useHarfKaristirma();
                        return;
                      }
                      if (key == 'joker_parti') {
                        _usePartiGuclendiricisi();
                        return;
                      }
                      setState(() {
                        _activeJoker = isActive ? null : key;
                        _serbestFirstIndex = null;
                        _lastMessage = key == 'joker_tekerlek'
                            ? 'Satır/sütununu temizlemek istediğiniz harfi seçin'
                            : key == 'joker_lolipop'
                                ? 'Silmek istediğiniz harfi seçin'
                                : 'Değiştirmek istediğiniz 1. harfi seçin';
                        _messageColor = Colors.purple;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: itemWidth,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.deepPurple
                            : stock > 0
                                ? Colors.white
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isActive
                              ? Colors.deepPurple
                              : stock > 0
                                  ? Colors.deepPurple.withValues(alpha: 0.3)
                                  : Colors.grey,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Opacity(
                              opacity: stock > 0 ? 1.0 : 0.4,
                              child: Image.asset(
                                joker['image'] as String,
                                width: itemWidth * 0.6,
                                height: itemWidth * 0.6,
                              ),
                            ),
                          ),
                          if (stock > 0)
                            Positioned(
                              top: 2,
                              right: 4,
                              child: Text(
                                '$stock',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? Colors.white : Colors.deepPurple,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('🔄 Hamle: $_remainingMoves',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                    Text('⭐ Puan: $_score',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                    Text('📝 Kelime: $_wordCount',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _selectedIndices.isEmpty
                      ? (_lastMessage.isEmpty ? 'Harf seçmeye başlayın...' : _lastMessage)
                      : toUpperCaseTR(_currentWord),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: _selectedIndices.isEmpty
                        ? (_lastMessage.isEmpty ? Colors.grey : _messageColor)
                        : Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PowerHint('4hrf', '⇆', Colors.blue),
                  _PowerHint('5hrf', '✹', Colors.orange),
                  _PowerHint('6hrf', '⇅', Colors.green),
                  _PowerHint('7+hrf', '✪', Colors.red),
                ],
              ),
              const SizedBox(height: 4),
              if (kShowWordCount)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _availableWordCount == 0 ? Colors.red[100] : Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _availableWordCount == 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  child: Text(
                    'Gridde Oluşturulabilir Kelime Sayısı: $_availableWordCount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _availableWordCount == 0 ? Colors.red : Colors.green[800],
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Expanded(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.gridSize,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: widget.gridSize * widget.gridSize,
                    itemBuilder: (context, index) => _buildCell(index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PowerHint extends StatelessWidget {
  final String label;
  final String symbol;
  final Color color;

  const _PowerHint(this.label, this.symbol, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        const SizedBox(width: 2),
        Text(symbol, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ],
      ),
    );
  }
}

typedef OnWidgetSizeChange = void Function(Size size, Offset globalOffset);

class MeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const MeasureSize({super.key, required this.onChange, required this.child});

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final size = renderBox.size;
        final offset = renderBox.localToGlobal(Offset.zero);
        widget.onChange(size, offset);
      }
    });
    return widget.child;
  }
}

class GameRecord {
  final int gameNumber;
  final String username;
  final DateTime date;
  final int gridSize;
  final int score;
  final int wordCount;
  final String longestWord;
  final int durationSeconds;

  GameRecord({
    required this.gameNumber,
    required this.username,
    required this.date,
    required this.gridSize,
    required this.score,
    required this.wordCount,
    required this.longestWord,
    required this.durationSeconds,
  });

  Map<String, dynamic> toMap() => {
        'gameNumber': gameNumber,
        'username': username,
        'date': date.toIso8601String(),
        'gridSize': gridSize,
        'score': score,
        'wordCount': wordCount,
        'longestWord': longestWord,
        'durationSeconds': durationSeconds,
      };

  factory GameRecord.fromMap(Map<String, dynamic> map) => GameRecord(
        gameNumber: map['gameNumber'],
        username: map['username'] ?? 'Oyuncu',
        date: DateTime.parse(map['date']),
        gridSize: map['gridSize'],
        score: map['score'],
        wordCount: map['wordCount'],
        longestWord: map['longestWord'],
        durationSeconds: map['durationSeconds'],
      );

  String toJson() => jsonEncode(toMap());
  factory GameRecord.fromJson(String source) =>
      GameRecord.fromMap(jsonDecode(source));
}

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  List<GameRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('game_records') ?? [];
    setState(() {
      _records = data
          .map((e) => GameRecord.fromJson(e))
          .toList()
          .reversed
          .toList();
    });
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m dk $s sn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Skor Tablosu'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _records.isEmpty
          ? const Center(
              child: Text('Henüz oyun oynamadınız.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Geçmiş Oyunlar',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                const SizedBox(height: 12),
                ..._records.map((record) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.deepPurple.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 16, color: Colors.deepPurple),
                                    const SizedBox(width: 4),
                                    Text(record.username,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple)),
                                    const SizedBox(width: 8),
                                    Text('· Oyun ${record.gameNumber}',
                                        style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                                Text(
                                  '${record.date.day.toString().padLeft(2, '0')}.${record.date.month.toString().padLeft(2, '0')}.${record.date.year}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                            const Divider(),
                            _RecordRow('Grid', '${record.gridSize}x${record.gridSize}'),
                            _RecordRow('Puan', '${record.score}'),
                            _RecordRow('Kelime Sayısı', '${record.wordCount}'),
                            _RecordRow('En Uzun Kelime', toUpperCaseTR(record.longestWord)),
                            _RecordRow('Süre', _formatDuration(record.durationSeconds)),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final String label;
  final String value;
  const _RecordRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _gold = 0;
  Map<String, int> _stocks = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final stocks = <String, int>{};
    for (final joker in _jokers) {
      stocks[joker['key'] as String] = prefs.getInt(joker['key'] as String) ?? 0;
    }
    setState(() {
      _gold = prefs.getInt('gold') ?? 50000;
      _stocks = stocks;
    });
  }

  final List<Map<String, dynamic>> _jokers = const [
    {'name': 'Balık', 'key': 'joker_balik', 'description': 'Rastgele 6 harfi yok eder', 'image': 'assets/images/balik.png', 'cost': 100},
    {'name': 'Tekerlek', 'key': 'joker_tekerlek', 'description': 'Seçilen harfin satır ve sütununu temizler', 'image': 'assets/images/tekerlek.png', 'cost': 200},
    {'name': 'Lolipop Kırıcı', 'key': 'joker_lolipop', 'description': 'Seçilen tek harfi yok eder', 'image': 'assets/images/lolipop_kirici.png', 'cost': 75},
    {'name': 'Serbest Değiştirme', 'key': 'joker_serbest', 'description': 'Komşu 2 harfi yer değiştirir', 'image': 'assets/images/serbest_degistirme.png', 'cost': 125},
    {'name': 'Harf Karıştırma', 'key': 'joker_karistirma', 'description': 'Grideki harfleri karıştırır', 'image': 'assets/images/harf_karistirma.png', 'cost': 300},
    {'name': 'Parti Güçlendiricisi', 'key': 'joker_parti', 'description': 'Tüm grid sıfırlanır', 'image': 'assets/images/parti_guclendiricisi.png', 'cost': 400},
  ];

  Future<void> _buyJoker(Map<String, dynamic> joker) async {
    if (_gold < joker['cost']) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yeterli altınınız yok!')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final newGold = _gold - joker['cost'] as int;
    final key = joker['key'] as String;
    final newStock = (_stocks[key] ?? 0) + 1;
    await prefs.setInt('gold', newGold);
    await prefs.setInt(key, newStock);
    setState(() {
      _gold = newGold;
      _stocks[key] = newStock;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${joker['name']} satın alındı! (Stok: $newStock)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Market'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 6),
                Text('$_gold',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.amber[700], borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mevcut Altın',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text('$_gold',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Jokerler',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 12),
          ..._jokers.map((joker) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(12)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                joker['image'] as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if ((_stocks[joker['key']] ?? 0) > 0)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.deepPurple, shape: BoxShape.circle),
                                child: Text(
                                  '${_stocks[joker['key']] ?? 0}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(joker['name'] as String,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple)),
                            Text(joker['description'] as String,
                                style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('${joker['cost']} Altın',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _buyJoker(joker),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Al'),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}