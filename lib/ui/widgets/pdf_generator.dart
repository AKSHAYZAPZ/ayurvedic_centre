import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generatePatientPdf(Map<String, dynamic> fields,
      List<Map<String, dynamic>> treatmentsList, String patientName,
      {required String branchName}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(width: 50, height: 50),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(branchName,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            'Cheepunkal P.O. Kumarakom, Kottayam, Kerala - 686563'),
                        pw.Text('e-mail: unknown@gmail.com'),
                        pw.Text('Mob: +91 9876543210 | +91 9786543210'),
                        pw.Text('GST No: 32AABCU9603R1ZW',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Text('Patient Details',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green)),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Name: ${fields['name'] ?? ''}'),
                        pw.Text('Address: ${fields['address'] ?? ''}'),
                        pw.Text('WhatsApp Number: ${fields['phone'] ?? ''}'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Booked On: ${fields['date_nd_time'] ?? ''}'),
                        pw.Text(
                            'Treatment Date: ${fields['treatment_date'] ?? ''}'),
                        pw.Text(
                            'Treatment Time: ${fields['treatment_time'] ?? ''}'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                if (treatmentsList.isNotEmpty)
                  pw.Table.fromTextArray(
                    headers: ['Treatment', 'Price', 'Male', 'Female', 'Total'],
                    data: treatmentsList
                        .map((t) => [
                              t['name'] ?? '',
                              '${t['price'] ?? 0}',
                              t['male'] ?? 0,
                              t['female'] ?? 0,
                              '${t['total'] ?? 0}',
                            ])
                        .toList(),
                    border: pw.TableBorder.all(),
                    headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, color: PdfColors.green),
                    cellAlignment: pw.Alignment.centerLeft,
                    columnWidths: {
                      0: pw.FixedColumnWidth(200), // Treatment column
                      1: pw.FlexColumnWidth(),
                      2: pw.FlexColumnWidth(),
                      3: pw.FlexColumnWidth(),
                      4: pw.FlexColumnWidth(),
                    },
                  ),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total Amount:'),
                            pw.SizedBox(width: 8),
                            pw.Text('${fields['total_amount'] ?? 0}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Discount:'),
                            pw.SizedBox(width: 8),
                            pw.Text('${fields['discount_amount'] ?? 0}'),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Advance:'),
                            pw.SizedBox(width: 8),
                            pw.Text('${fields['advance_amount'] ?? 0}'),
                          ],
                        ),
                        pw.Divider(),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Balance:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('${fields['balance_amount'] ?? 0}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Center(
                  child: pw.Text('Thank you for choosing us',
                      style: pw.TextStyle(color: PdfColors.green)),
                ),
                pw.SizedBox(height: 8),
                pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text('Signature')),
              ],
            ),
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final tmpDir = await getTemporaryDirectory();
    final filePath =
        '${tmpDir.path}/${patientName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final f = File(filePath);
    await f.writeAsBytes(bytes);

    await Printing.sharePdf(bytes: bytes, filename: f.path.split('/').last);
  }
}
