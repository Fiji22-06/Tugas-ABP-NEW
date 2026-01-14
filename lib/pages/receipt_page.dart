import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/format_util.dart';
import 'dart:math';

class ReceiptPage extends StatelessWidget {
  final List<Book> items;
  final int totalAmount;
  final String paymentMethod;

  const ReceiptPage({
    super.key,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final transactionId = 'TRX-${Random().nextInt(900000) + 100000}';
    final date = DateTime.now().toString().split('.')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota Pembelian'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'BOOKTIME STORE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const Divider(height: 30),
                  _buildReceiptRow('ID Transaksi', transactionId),
                  _buildReceiptRow('Tanggal', date),
                  _buildReceiptRow('Metode', paymentMethod),
                  const Divider(height: 30),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            Text(FormatUtil.formatCurrency(item.price)),
                          ],
                        ),
                      )),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(
                        FormatUtil.formatCurrency(totalAmount),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Kembali ke Beranda'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // Simulasi download/share
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota berhasil disimpan ke Galeri')),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Simpan Nota'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
