import 'package:drift/drift.dart';
import 'package:cyjl/core/enums.dart';
import 'package:cyjl/core/id.dart';
import 'package:cyjl/data/database/app_database.dart';
import 'package:cyjl/data/database/daos.dart';
import 'package:cyjl/domain/services.dart';

/// 事件写操作：确认/跳过/撤销/补记/按需单记
class EventRepository {
  EventRepository(this.dao, this.stock);

  final AppDao dao;
  final StockService stock;

  Future<void> markTaken(String eventId) async {
    final event = await dao.eventById(eventId);
    if (event == null || event.status != EventStatus.pending.code) return;
    final med = await dao.getMed(event.medicationId);
    final dose = event.planDose;
    await dao.updateEventStatus(
      eventId,
      EventStatus.taken.code,
      actualAt: DateTime.now().millisecondsSinceEpoch,
      actualDose: dose,
    );
    if (med != null) await stock.deductOnTaken(med, dose);
  }

  Future<void> markSkipped(String eventId) async {
    final event = await dao.eventById(eventId);
    if (event == null || event.status != EventStatus.pending.code) return;
    await dao.updateEventStatus(
      eventId,
      EventStatus.skipped.code,
      actualAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// 撤销已确认事件 → 回到 pending，库存回补
  Future<void> undo(String eventId) async {
    final event = await dao.eventById(eventId);
    if (event == null || event.status == EventStatus.pending.code) return;
    final med = await dao.getMed(event.medicationId);
    if (event.status == EventStatus.taken.code && med != null) {
      final dose = event.actualDose ?? event.planDose;
      await stock.restoreOnUndo(med, dose);
    }
    await dao.updateEventStatus(eventId, EventStatus.pending.code, actualAt: null, actualDose: null);
  }

  /// 补记：漏服药改为已服用（保留计划剂量，可备注）
  Future<void> fixMissed(String eventId, {String? note}) async {
    final event = await dao.eventById(eventId);
    if (event == null) return;
    if (event.status != EventStatus.taken.code &&
        event.status != EventStatus.skipped.code) {
      final dose = event.planDose;
      final med = await dao.getMed(event.medicationId);
      await dao.updateEventStatus(
        eventId,
        EventStatus.taken.code,
        actualAt: DateTime.now().millisecondsSinceEpoch,
        actualDose: dose,
      );
      if (med != null) await stock.deductOnTaken(med, dose);
    }
    if (note != null && note.isNotEmpty) {
      await dao.setEventNote(eventId, note);
    }
  }

  /// 按需服用：直接记一笔
  Future<void> logAsNeeded({
    required String medId,
    required double dose,
    String? note,
  }) async {
    final now = DateTime.now();
    await dao.insertEventCompanion(
      IntakeEventsCompanion.insert(
        id: newId(),
        medicationId: medId,
        scheduleId: 'as_needed',
        planDate: _ymd(now),
        planTime: _hm(now),
        planDose: dose,
        status: EventStatus.taken.code,
        actualAt: Value(now.millisecondsSinceEpoch),
        actualDose: Value(dose),
        note: Value(note),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final med = await dao.getMed(medId);
    if (med != null) await stock.deductOnTaken(med, dose);
  }
}

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _hm(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
