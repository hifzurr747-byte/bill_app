import 'package:flutter/material.dart';
import 'bill_model.dart';
import 'bill_preview_screen.dart';
import 'bill_history_screen.dart';

class BillFormScreen extends StatefulWidget {
  final bool isUrdu;
  final VoidCallback onToggleLanguage;

  const BillFormScreen({
    super.key,
    required this.isUrdu,
    required this.onToggleLanguage,
  });

  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen> {
  final _customerNameCtrl = TextEditingController();
  final _billNumberCtrl = TextEditingController(text: '1');
  DateTime _selectedDate = DateTime.now();
  final List<Map<String, TextEditingController>> _itemControllers = [];

  static const Color primaryRed = Color(0xFFC0392B);
  static const Color bgCream = Color(0xFFFAF6F1);

  @override
  void initState() {
    super.initState();
    _addItem();
  }

  void _addItem() {
    setState(() {
      _itemControllers.add({
        'desc': TextEditingController(),
        'qty': TextEditingController(),
        'rate': TextEditingController(),
      });
    });
  }

  void _removeItem(int index) {
    if (_itemControllers.length > 1) {
      setState(() {
        _itemControllers[index].forEach((_, c) => c.dispose());
        _itemControllers.removeAt(index);
      });
    }
  }

  List<BillItem> _buildItems() {
    List<BillItem> items = [];
    for (var ctrl in _itemControllers) {
      final desc = ctrl['desc']!.text.trim();
      final qty = double.tryParse(ctrl['qty']!.text) ?? 0;
      final rate = double.tryParse(ctrl['rate']!.text) ?? 0;
      if (desc.isNotEmpty || qty > 0 || rate > 0) {
        items.add(BillItem(description: desc, quantity: qty, rate: rate));
      }
    }
    return items;
  }

  void _previewBill() {
    final items = _buildItems();
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isUrdu ? 'کم از کم ایک آئٹم شامل کریں' : 'Add at least one item'),
          backgroundColor: primaryRed,
        ),
      );
      return;
    }

    final bill = Bill(
      customerName: _customerNameCtrl.text.trim(),
      billNumber: _billNumberCtrl.text.trim(),
      date: _selectedDate,
      items: items,
      isUrdu: widget.isUrdu,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BillPreviewScreen(bill: bill),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryRed),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = widget.isUrdu;
    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUrdu ? 'عبدالمجید اینڈ کمپنی' : 'Abdul Majeed & Co.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              isUrdu ? 'بل بنائیں' : 'Create Bill',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // History button
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: isUrdu ? 'بل کی تاریخ' : 'Bill History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BillHistoryScreen(isUrdu: isUrdu),
                ),
              );
            },
          ),
          TextButton.icon(
            onPressed: widget.onToggleLanguage,
            icon: const Icon(Icons.translate, color: Colors.white, size: 18),
            label: Text(
              isUrdu ? 'English' : 'اردو',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Company Header Card
                  _buildCompanyCard(isUrdu),
                  const SizedBox(height: 16),
                  // Bill Info
                  _buildBillInfoCard(isUrdu),
                  const SizedBox(height: 16),
                  // Items
                  _buildItemsCard(isUrdu),
                ],
              ),
            ),
          ),
          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _previewBill,
              icon: const Icon(Icons.receipt_long),
              label: Text(
                isUrdu ? 'بل دیکھیں اور پرنٹ کریں' : 'Preview & Print Bill',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        tooltip: isUrdu ? 'آئٹم شامل کریں' : 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCompanyCard(bool isUrdu) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: primaryRed, width: 1.5),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              isUrdu ? CompanyInfo.nameUrdu : CompanyInfo.nameEnglish,
              textAlign: TextAlign.center,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isUrdu ? CompanyInfo.addressUrdu : CompanyInfo.addressEnglish,
              textAlign: TextAlign.center,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              isUrdu ? CompanyInfo.proprietorUrdu : CompanyInfo.proprietorEnglish,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: CompanyInfo.phones.map((p) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone, size: 13, color: primaryRed),
                  const SizedBox(width: 3),
                  Text(p, style: const TextStyle(fontSize: 12)),
                ],
              )).toList(),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone_android, size: 13, color: primaryRed),
                const SizedBox(width: 3),
                if (isUrdu) ...[
                  Text(
                    CompanyInfo.hamzaNumber,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Text(' \u200F', style: TextStyle(fontSize: 12)), // RTL mark spacer
                  Text(
                    ':${CompanyInfo.hamzaName}',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 12),
                  ),
                ] else ...[
                  Text(
                    '${CompanyInfo.hamzaNameEn}: ${CompanyInfo.hamzaNumber}',
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillInfoCard(bool isUrdu) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isUrdu ? 'بل کی تفصیل' : 'Bill Details',
              textAlign: isUrdu ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _billNumberCtrl,
                    label: isUrdu ? 'نمبر' : 'Bill No.',
                    keyboardType: TextInputType.number,
                    isUrdu: isUrdu,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: isUrdu ? 'تاریخ' : 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: primaryRed),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: primaryRed),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _customerNameCtrl,
              label: isUrdu ? 'نام خریدار' : 'Customer Name',
              isUrdu: isUrdu,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(bool isUrdu) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.list_alt, color: primaryRed, size: 20),
                const SizedBox(width: 8),
                Text(
                  isUrdu ? 'آئٹم کی فہرست' : 'Items List',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Header row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      isUrdu ? 'تفصیل' : 'Description',
                      textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isUrdu ? 'تعداد' : 'Qty',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isUrdu ? 'نرخ' : 'Rate',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isUrdu ? 'رقم' : 'Amount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Items
            ..._itemControllers.asMap().entries.map((entry) {
              final i = entry.key;
              final ctrl = entry.value;
              return _buildItemRow(i, ctrl, isUrdu);
            }),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add, color: primaryRed),
              label: Text(
                isUrdu ? 'آئٹم شامل کریں' : 'Add Item',
                style: const TextStyle(color: primaryRed),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(
    int index,
    Map<String, TextEditingController> ctrl,
    bool isUrdu,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: ctrl['desc'],
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              decoration: InputDecoration(
                hintText: isUrdu ? 'تفصیل' : 'Item',
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: primaryRed),
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextField(
              controller: ctrl['qty'],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: primaryRed),
                ),
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextField(
              controller: ctrl['rate'],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: primaryRed),
                ),
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Builder(builder: (_) {
              final qty = double.tryParse(ctrl['qty']!.text) ?? 0;
              final rate = double.tryParse(ctrl['rate']!.text) ?? 0;
              final amt = qty * rate;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Text(
                  amt == 0 ? '-' : amt.toStringAsFixed(amt.truncateToDouble() == amt ? 0 : 2),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                ),
              );
            }),
          ),
          IconButton(
            onPressed: () => _removeItem(index),
            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required bool isUrdu,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _billNumberCtrl.dispose();
    for (var ctrl in _itemControllers) {
      ctrl.forEach((_, c) => c.dispose());
    }
    super.dispose();
  }
}
