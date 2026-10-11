int _counter = 0;

/// 本地 id 生成（进程内唯一 + 时间戳，空库冷启动也稳定）
String newId() => 'id-${DateTime.now().microsecondsSinceEpoch}-${_counter++}';
