import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'bill_model.dart';

class BillStorage {
  static const String _key = 'saved_bills';

  // Save a bill to history
  static Future<void> saveBill(Bill bill) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAllBills();

    // Assign unique id if not set
    bill.id ??= DateTime.now().millisecondsSinceEpoch.toString();

    // Remove if already exists (update case)
    existing.removeWhere((b) => b.id == bill.id);

    // Add at top (newest first)
    existing.insert(0, bill);

    final jsonList = existing.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Get all bills
  static Future<List<Bill>> getAllBills() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((s) => Bill.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  // Delete a bill by id
  static Future<void> deleteBill(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAllBills();
    existing.removeWhere((b) => b.id == id);
    final jsonList = existing.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Clear all bills
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
