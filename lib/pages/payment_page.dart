import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/format_util.dart';
import 'receipt_page.dart';

class PaymentPage extends StatefulWidget {
  final int totalAmount;
  final List<Book> items;

  const PaymentPage({super.key, required this.totalAmount, required this.items});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {'id': 'qris', 'name': 'QRIS', 'icon': Icons.qr_code_scanner},
    {'id': 'dana', 'name': 'DANA / OVO / GoPay', 'icon': Icons.account_balance_wallet},
    {'id': 'bank', 'name': 'Transfer Bank (BCA/Mandiri)', 'icon': Icons.account_balance},
    {'id': 'card', 'name': 'Kartu Kredit', 'icon': Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pembayaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.items.length} Buku', style: const TextStyle(fontSize: 16)),
                Text(
                  FormatUtil.formatCurrency(widget.totalAmount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            const Divider(height: 40),
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  return Card(
                    color: selectedMethod == method['id'] ? Colors.brown[50] : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: selectedMethod == method['id'] ? Colors.brown : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(method['icon'], color: Colors.brown),
                      title: Text(method['name']),
                      trailing: selectedMethod == method['id'] 
                          ? const Icon(Icons.check_circle, color: Colors.brown) 
                          : const Icon(Icons.circle_outlined),
                      onTap: () {
                        setState(() {
                          selectedMethod = method['id'];
                        });
                        if (method['id'] == 'qris') {
                          _showQRISDialog();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: selectedMethod == null
                  ? null
                  : () {
                      _processPayment();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRISDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan QRIS', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                image: const DecorationImage(
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Silakan scan kode di atas untuk membayar', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    // Simulasi loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Tutup loading
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptPage(
            items: widget.items,
            totalAmount: widget.totalAmount,
            paymentMethod: paymentMethods.firstWhere((m) => m['id'] == selectedMethod)['name'],
          ),
        ),
      );
    });
  }
}
