import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'bill_model.dart';
import 'bill_storage.dart';
import 'bill_preview_screen.dart';

class BillHistoryScreen extends StatefulWidget {
  final bool isUrdu;

  const BillHistoryScreen({super.key, required this.isUrdu});

  @override
  State<BillHistoryScreen> createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  static const Color primaryRed = Color(0xFFC0392B);

  List<Bill> _bills = [];
  List<Bill> _filtered = [];
  bool _loading = true;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBills();
    _searchCtrl.addListener(_onSearch);
  }

  Future<void> _loadBills() async {
    setState(() => _loading = true);
    final bills = await BillStorage.getAllBills();
    setState(() {
      _bills = bills;
      _filtered = bills;
      _loading = false;
    });
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _bills
          : _bills.where((b) =>
              b.customerName.toLowerCase().contains(q) ||
              b.billNumber.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _deleteBill(Bill bill) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.isUrdu ? 'بل حذف کریں' : 'Delete Bill'),
        content: Text(
          widget.isUrdu
              ? 'کیا آپ بل نمبر ${bill.billNumber} حذف کرنا چاہتے ہیں؟'
              : 'Delete Bill No. ${bill.billNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(widget.isUrdu ? 'نہیں' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              widget.isUrdu ? 'حذف کریں' : 'Delete',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && bill.id != null) {
      await BillStorage.deleteBill(bill.id!);
      _loadBills();
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.isUrdu ? 'سب حذف کریں' : 'Clear All'),
        content: Text(
          widget.isUrdu
              ? 'کیا آپ تمام بل حذف کرنا چاہتے ہیں؟'
              : 'Delete all saved bills?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(widget.isUrdu ? 'نہیں' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              widget.isUrdu ? 'سب حذف کریں' : 'Clear All',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await BillStorage.clearAll();
      _loadBills();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = widget.isUrdu;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      appBar: AppBar(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        title: Text(
          isUrdu ? 'بل کی تاریخ' : 'Bill History',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (_bills.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: isUrdu ? 'سب حذف کریں' : 'Clear All',
              onPressed: _clearAll,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBills,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              decoration: InputDecoration(
                hintText: isUrdu ? 'نام یا نمبر سے تلاش کریں...' : 'Search by name or bill no...',
                prefixIcon: const Icon(Icons.search, color: primaryRed),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: primaryRed),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Stats bar
          if (_bills.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statChip(
                    isUrdu ? 'کل بل' : 'Total Bills',
                    '${_bills.length}',
                  ),
                  _statChip(
                    isUrdu ? 'کل رقم' : 'Total Amount',
                    'Rs. ${_bills.fold(0.0, (s, b) => s + b.total).toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Bills list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: primaryRed))
                : _filtered.isEmpty
                    ? _buildEmptyState(isUrdu)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filtered.length,
                        itemBuilder: (ctx, i) => _buildBillCard(_filtered[i], isUrdu),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState(bool isUrdu) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: Colors.red.shade200),
          const SizedBox(height: 12),
          Text(
            isUrdu ? 'کوئی بل محفوظ نہیں' : 'No bills saved yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Text(
            isUrdu ? 'بل بنانے کے بعد محفوظ کریں' : 'Save bills after creating them',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(Bill bill, bool isUrdu) {
    final dateStr = DateFormat('dd/MM/yyyy').format(bill.date);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.red.shade100),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BillPreviewScreen(bill: bill),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  // Bill number badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${bill.billNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.customerName.isEmpty
                              ? (isUrdu ? '(نام نہیں)' : 'No name')
                              : bill.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 11, color: Colors.grey.shade500),
                            const SizedBox(width: 3),
                            Text(
                              dateStr,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.shopping_bag_outlined,
                                size: 11, color: Colors.grey.shade500),
                            const SizedBox(width: 3),
                            Text(
                              '${bill.items.length} ${isUrdu ? "آئٹم" : "items"}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Total amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${bill.total.toStringAsFixed(bill.total.truncateToDouble() == bill.total ? 0 : 2)}',
                        style: const TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isUrdu ? 'کل رقم' : 'Total',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 12),
              // Item preview
              Row(
                children: [
                  Expanded(
                    child: Text(
                      bill.items
                          .take(2)
                          .map((e) => e.description)
                          .where((d) => d.isNotEmpty)
                          .join(', '),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BillPreviewScreen(bill: bill),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility_outlined,
                            color: primaryRed, size: 20),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        tooltip: isUrdu ? 'دیکھیں' : 'View',
                      ),
                      IconButton(
                        onPressed: () => _deleteBill(bill),
                        icon: Icon(Icons.delete_outline,
                            color: Colors.grey.shade400, size: 20),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        tooltip: isUrdu ? 'حذف کریں' : 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
