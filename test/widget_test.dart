import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:train/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // MaterialApp で包む（Directionality / Theme / Navigator を用意）
    await tester.pumpWidget(const MaterialApp(home: SimpleTrainingApp()));

    // 最低限1フレーム進める
    await tester.pump();

    // Scaffold がある
    expect(find.byType(Scaffold), findsOneWidget);

    // AppBar のタイトル（あなたの appTitle 定数を使っている前提）
    expect(find.text(appTitle), findsOneWidget);

    // タップしてもクラッシュしない
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
  });
}
