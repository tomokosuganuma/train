import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SimpleTrainingApp()));
}

class Sample {
  final String imagePath; // assets のパス
  final String answer;    // 都市名
  Sample(this.imagePath, this.answer);

  factory Sample.fromList(List<String> list) {
    return Sample(list[0], list[1]);
  }
}

class SimpleTrainingApp extends StatefulWidget {
  const SimpleTrainingApp({super.key});

  @override
  State<SimpleTrainingApp> createState() => _SimpleTrainingAppState();
}

const String appTitle = '都市判別トレーニング';

class _SimpleTrainingAppState extends State<SimpleTrainingApp> {
  // 3問だけ
  final List<List<String>> data = [
    ['assets/cities/tokyo.jpg', '東京'],
    ['assets/cities/seoul.jpg', 'ソウル'],
    ['assets/cities/rome.jpg', 'ローマ'],
  ];

  late final List<Sample> _samples;
  int _index = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _samples = data.map((e) => Sample.fromList(e)).toList();
    _samples.shuffle(Random());
  }

  void _onTap() {
    setState(() {
      if (_showAnswer) {
        _showAnswer = false;

        // 最後まで行ったら再シャッフルして先頭へ
        if (_index == _samples.length - 1) {
          _samples.shuffle(Random());
          _index = 0;
        } else {
          _index++;
        }
      } else {
        _showAnswer = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_samples.isEmpty) {
      return const Scaffold(body: Center(child: Text('データがありません')));
    }

    final sample = _samples[_index];

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                sample.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('画像を読み込めません（assets設定とパスを確認してください）'),
                ),
              ),
            ),

            if (_showAnswer)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    sample.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 10,
              right: 10,
              child: _hint(_showAnswer ? 'タップで次へ' : 'タップで正解表示'),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: _hint('${_index + 1}/${_samples.length}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
