import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyjl/app/theme/app_theme.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/domain/plan_slot.dart';
import 'package:cyjl/shared/widgets/capsule_nav.dart';
import 'package:cyjl/shared/widgets/nutrient_bar.dart';
import 'package:cyjl/shared/widgets/pop_button.dart';

void main() {
  testWidgets('胶囊导航渲染 5 个 Tab 且可切换', (tester) async {
    var index = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => CapsuleNav(
              index: index,
              onChanged: (i) => setState(() => index = i),
            ),
          ),
        ),
      ),
    );
    expect(find.text('今日'), findsOneWidget);
    expect(find.text('营养'), findsOneWidget);
    expect(find.text('记录'), findsOneWidget);
    expect(find.text('药箱'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);

    await tester.tap(find.text('记录'));
    await tester.pumpAndSettle();
    expect(index, 2);
  });

  testWidgets('营养双刻度条渲染名称与状态', (tester) async {
    const intake = NutrientIntake(
      nutrient: NutrientRow(
        code: 'vd',
        name: '维生素D',
        unit: 'μg',
        category: 'vitamin',
        rniMale: 10,
        rniFemale: 10,
        aiValue: null,
        ulValue: 50,
        emoji: '☀️',
      ),
      amount: 25,
      sources: [NutrientSource(name: '维生素D3', emoji: '🌞', amount: 25)],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(body: NutrientBar(intake: intake, femaleProfile: false)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('维生素D'), findsWidgets);
    expect(find.textContaining('已达推荐摄入量'), findsOneWidget);
    expect(find.text('RNI'), findsOneWidget);
  });

  testWidgets('胶囊按钮可点击', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: CapsuleButton(label: '已服用', onPressed: () => tapped = true),
        ),
      ),
    );
    await tester.tap(find.text('已服用'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
