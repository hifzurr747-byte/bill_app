import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'bill_model.dart';
import 'bill_storage.dart';

class BillPreviewScreen extends StatelessWidget {
  final Bill bill;

  const BillPreviewScreen({super.key, required this.bill});

  static const Color primaryRed = Color(0xFFC0392B);
  static const PdfColor pdfRed = PdfColor.fromInt(0xFFC0392B);
  static const PdfColor pdfLightRed = PdfColor.fromInt(0xFFFFEBEB);
  static const PdfColor pdfCream = PdfColor.fromInt(0xFFFAF6F1);
  static const PdfColor pdfGrey = PdfColor.fromInt(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        title: Text(
          bill.isUrdu ? 'بل کا جائزہ' : 'Bill Preview',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: bill.isUrdu ? 'پرنٹ کریں' : 'Print',
            onPressed: () => _printBill(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: bill.isUrdu ? 'شیئر کریں' : 'Share',
            onPressed: () => _shareBill(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: _buildBillWidget(context),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit, color: primaryRed),
                    label: Text(
                      bill.isUrdu ? 'ترمیم کریں' : 'Edit',
                      style: const TextStyle(color: primaryRed),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryRed),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _printBill(context),
                    icon: const Icon(Icons.print),
                    label: Text(
                      bill.isUrdu ? 'پرنٹ کریں' : 'Print Bill',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillWidget(BuildContext context) {
    final isUrdu = bill.isUrdu;
    final dateStr = DateFormat('dd/MM/yyyy').format(bill.date);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.red.shade200, width: 1.5),
      ),
      color: const Color(0xFFFAF6F1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Directionality(
          textDirection: isUrdu ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Company Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Text(
                      isUrdu ? CompanyInfo.nameUrdu : CompanyInfo.nameEnglish,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUrdu ? CompanyInfo.addressUrdu : CompanyInfo.addressEnglish,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUrdu ? CompanyInfo.proprietorUrdu : CompanyInfo.proprietorEnglish,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 2,
                      children: CompanyInfo.phones.map((p) => Text(
                        p,
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      )).toList(),
                    ),
                    const SizedBox(height: 2),
                    if (isUrdu)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CompanyInfo.hamzaNumber,
                            textDirection: ui.TextDirection.ltr,
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                          Text(
                            ' :${CompanyInfo.hamzaName}',
                            textDirection: ui.TextDirection.rtl,
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      )
                    else
                      Text(
                        '${CompanyInfo.hamzaNameEn}: ${CompanyInfo.hamzaNumber}',
                        textDirection: ui.TextDirection.ltr,
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Clean bill number + date row
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.red.shade300),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.red.shade50),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            isUrdu ? 'نمبر' : 'Bill No',
                            style: TextStyle(fontSize: 11, color: Colors.red.shade700, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            bill.billNumber,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRed),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            isUrdu ? 'تاریخ' : 'Date',
                            style: TextStyle(fontSize: 11, color: Colors.red.shade700, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            dateStr,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // Customer name row - matches original bill
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.red.shade300),
                  ),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          color: primaryRed,
                          child: Text(
                            isUrdu ? 'نام خریدار' : 'Customer',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text(
                            bill.customerName.isEmpty
                                ? (isUrdu ? '---' : '---')
                                : bill.customerName,
                            textDirection: isUrdu ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Table
              _buildTable(isUrdu),
              const SizedBox(height: 8),
              // Total
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isUrdu ? 'میزان' : 'Total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Rs. ${_formatAmount(bill.total)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUrdu ? 'بھول چوک لین دین' : 'Subject to errors',
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isUrdu ? 'دستخط' : 'Signature',
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 80,
                        height: 1,
                        color: Colors.grey.shade400,
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

  Widget _infoChip(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: primaryRed,
          ),
        ),
      ],
    );
  }

  Widget _buildTable(bool isUrdu) {
    return Table(
      border: TableBorder.all(color: Colors.red.shade200, width: 0.8),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        // Header
        TableRow(
          decoration: const BoxDecoration(color: primaryRed),
          children: [
            _tableHeader(isUrdu ? 'تفصیل' : 'Description'),
            _tableHeader(isUrdu ? 'تعداد' : 'Qty'),
            _tableHeader(isUrdu ? 'نرخ' : 'Rate'),
            _tableHeader(isUrdu ? 'رقم' : 'Amount'),
          ],
        ),
        // Items
        ...bill.items.map((item) => TableRow(
          decoration: BoxDecoration(
            color: bill.items.indexOf(item) % 2 == 0
                ? Colors.white
                : const Color(0xFFFFF5F5),
          ),
          children: [
            _tableCell(item.description, align: TextAlign.start),
            _tableCell(
              item.quantity == item.quantity.truncate()
                  ? item.quantity.toInt().toString()
                  : item.quantity.toString(),
            ),
            _tableCell(_formatAmount(item.rate)),
            _tableCell(
              _formatAmount(item.amount),
              bold: true,
              color: primaryRed,
            ),
          ],
        )),
        // Empty rows for visual space (like original bill)
        ...List.generate(
          (5 - bill.items.length).clamp(0, 5),
          (_) => TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: [
              _tableCell(''),
              _tableCell(''),
              _tableCell(''),
              _tableCell(''),
            ],
          ),
        ),
      ],
    );
  }

  TableCell _tableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  TableCell _tableCell(
    String text, {
    TextAlign align = TextAlign.center,
    bool bold = false,
    Color color = Colors.black87,
  }) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.truncate()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();
    final isUrdu = bill.isUrdu;
    final dateStr = DateFormat('dd/MM/yyyy').format(bill.date);

    // Load Urdu font if needed
    pw.Font? urduFont;
    pw.Font? urduBoldFont;
    if (isUrdu) {
      try {
        // Try loading a system font - on Windows, Arial Unicode may work
        // For production, bundle an Urdu font like NotoNastaliqUrdu
        // urduFont = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf'));
      } catch (_) {}
    }

    final baseTextStyle = pw.TextStyle(
      fontSize: 10,
      font: urduFont,
    );
    final boldTextStyle = pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
      font: urduBoldFont ?? urduFont,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(20),
        textDirection: isUrdu ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        build: (ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: pw.BoxDecoration(
                  color: pdfRed,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      isUrdu ? CompanyInfo.nameUrdu : CompanyInfo.nameEnglish,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: urduBoldFont ?? urduFont,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      isUrdu
                          ? CompanyInfo.addressUrdu.replaceAll('\n', ' | ')
                          : CompanyInfo.addressEnglish.replaceAll('\n', ' | '),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: const PdfColor(0.9, 0.9, 0.9),
                        fontSize: 9,
                        font: urduFont,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      isUrdu ? CompanyInfo.proprietorUrdu : CompanyInfo.proprietorEnglish,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                        font: urduFont,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      CompanyInfo.phones.join('  |  '),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(color: const PdfColor(0.9, 0.9, 0.9), fontSize: 8),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      isUrdu
                          ? '${CompanyInfo.hamzaNumber} :${CompanyInfo.hamzaName}'
                          : '${CompanyInfo.hamzaNameEn}: ${CompanyInfo.hamzaNumber}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: const PdfColor(0.9, 0.9, 0.9),
                        fontSize: 8,
                        font: urduFont,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              // Bill info
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: const PdfColor(0.9, 0.7, 0.7), width: 0.8),
                  color: PdfColors.white,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      isUrdu ? 'نام خریدار: ${bill.customerName}' : 'Customer: ${bill.customerName}',
                      style: boldTextStyle,
                    ),
                    pw.Row(children: [
                      pw.Text(
                        '${isUrdu ? "نمبر" : "No."}: ${bill.billNumber}  |  ${isUrdu ? "تاریخ" : "Date"}: $dateStr',
                        style: baseTextStyle,
                      ),
                    ]),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),
              // Table
              pw.Table(
                border: pw.TableBorder.all(color: const PdfColor(0.9, 0.7, 0.7), width: 0.8),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: pdfRed),
                    children: [
                      _pdfHeaderCell(isUrdu ? 'تفصیل' : 'Description', urduFont),
                      _pdfHeaderCell(isUrdu ? 'تعداد' : 'Qty', urduFont),
                      _pdfHeaderCell(isUrdu ? 'نرخ' : 'Rate', urduFont),
                      _pdfHeaderCell(isUrdu ? 'رقم' : 'Amount', urduFont),
                    ],
                  ),
                  // Items
                  ...bill.items.asMap().entries.map((e) => pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: e.key % 2 == 0 ? PdfColors.white : pdfLightRed,
                    ),
                    children: [
                      _pdfCell(e.value.description, baseTextStyle, pw.TextAlign.left),
                      _pdfCell(
                        e.value.quantity == e.value.quantity.truncate()
                            ? e.value.quantity.toInt().toString()
                            : e.value.quantity.toString(),
                        baseTextStyle,
                      ),
                      _pdfCell(_formatAmount(e.value.rate), baseTextStyle),
                      _pdfCell(
                        _formatAmount(e.value.amount),
                        pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: pdfRed,
                          font: urduFont,
                        ),
                      ),
                    ],
                  )),
                  // Extra empty rows
                  ...List.generate(
                    (6 - bill.items.length).clamp(0, 6),
                    (_) => pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.white),
                      children: [
                        _pdfCell('', baseTextStyle),
                        _pdfCell('', baseTextStyle),
                        _pdfCell('', baseTextStyle),
                        _pdfCell('', baseTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              // Total
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const pw.BoxDecoration(color: pdfRed),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      isUrdu ? 'میزان' : 'Total',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        font: urduFont,
                      ),
                    ),
                    pw.Text(
                      'Rs. ${_formatAmount(bill.total)}',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              // Footer
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    isUrdu ? 'بھول چوک لین دین' : 'Subject to errors',
                    style: pw.TextStyle(fontSize: 8, color: const PdfColor(0.4, 0.4, 0.4), font: urduFont),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        isUrdu ? 'دستخط' : 'Signature',
                        style: pw.TextStyle(fontSize: 8, color: const PdfColor(0.4, 0.4, 0.4), font: urduFont),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Container(
                        width: 70,
                        height: 0.5,
                        color: const PdfColor(0.6, 0.6, 0.6),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _pdfHeaderCell(String text, pw.Font? font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
          font: font,
        ),
      ),
    );
  }

  pw.Widget _pdfCell(String text, pw.TextStyle style, [pw.TextAlign align = pw.TextAlign.center]) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(text, textAlign: align, style: style),
    );
  }

  Future<void> _printBill(BuildContext context) async {
    try {
      await BillStorage.saveBill(bill); // save to history
      final pdf = await _generatePdf();
      await Printing.layoutPdf(
        onLayout: (_) => pdf.save(),
        name: 'Bill_${bill.billNumber}_${bill.customerName}',
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bill.isUrdu ? 'بل محفوظ ہو گیا' : 'Bill saved to history'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _shareBill(BuildContext context) async {
    try {
      await BillStorage.saveBill(bill); // save to history
      final pdf = await _generatePdf();
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'Bill_${bill.billNumber}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
