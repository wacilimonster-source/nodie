import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cyjl/main.dart' as app;

/// 真机/模拟器全量冒烟：驱动真实 App（真实 DB、真实通知插件）
///
/// 注意：App 根界面含「植物摇摆」无限动画，`pumpAndSettle` 永不返回，
/// 因此统一用固定帧推进。
Future<void> pumpFrames(WidgetTester tester, {int frames = 12, int ms = 100}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(Duration(milliseconds: ms));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('全量冒烟：启动→5 Tab→新增保健品向导→药箱', (tester) async {
    // 1) 启动（回归：黑屏 bug 修复后应能渲染出底部导航）
    await app.main();
    await pumpFrames(tester, frames: 20);

    expect(find.text('今日'), findsWidgets);
    expect(find.text('营养'), findsWidgets);
    expect(find.text('记录'), findsWidgets);
    expect(find.text('药箱'), findsWidgets);
    expect(find.text('设置'), findsWidgets);

    // 2) 营养 Tab（标题始终存在）
    await tester.tap(find.text('营养').last);
    await pumpFrames(tester);
    expect(find.text('营养摄入'), findsOneWidget);

    // 3) 记录 Tab（日历）
    await tester.tap(find.text('记录').last);
    await pumpFrames(tester);
    expect(find.text('当日明细'), findsOneWidget);

    // 4) 设置 Tab（顶部的营养参考项，避免依赖需滚动的底部免责声明）
    await tester.tap(find.text('设置').last);
    await pumpFrames(tester);
    expect(find.textContaining('人群档案'), findsOneWidget);

    // 5) 药箱 Tab → 打开新增向导
    await tester.tap(find.text('药箱').last);
    await pumpFrames(tester);
    // 空态按钮 或 顶部 + 按钮
    final emptyAdd = find.text('＋ 添加');
    if (emptyAdd.evaluate().isNotEmpty) {
      await tester.tap(emptyAdd.first);
    } else {
      await tester.tap(find.byIcon(Icons.add).first);
    }
    await pumpFrames(tester);
    expect(find.text('保健品'), findsOneWidget);

    // 选择类型（默认保健品）→ 下一步
    await tester.tap(find.text('下一步'));
    await pumpFrames(tester);

    // 基本信息：填名称 → 下一步
    await tester.enterText(find.byType(TextFormField).first, '维生素D3');
    await pumpFrames(tester, frames: 4);
    await tester.tap(find.text('下一步'));
    await pumpFrames(tester);

    // 营养成分（跳过）→ 频率 → 时间 → 库存（连续下一步）
    await tester.tap(find.text('下一步'));
    await pumpFrames(tester);
    expect(find.text('每天'), findsOneWidget);
    await tester.tap(find.text('下一步'));
    await pumpFrames(tester);
    await tester.tap(find.text('下一步'));
    await pumpFrames(tester);

    // 完成创建
    await tester.tap(find.text('✓ 完成'));
    await pumpFrames(tester, frames: 20);

    // 回到药箱并出现新条目
    expect(find.textContaining('维生素D3'), findsWidgets);
  });
}
