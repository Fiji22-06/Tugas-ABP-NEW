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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Pembayaran',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
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
              ),
              const SizedBox(height: 30),
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  bool isSelected = selectedMethod == method['id'];
                  return Card(
                    color: isSelected ? Colors.brown[50] : null,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? Colors.brown : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(method['icon'], color: isSelected ? Colors.brown : Colors.grey),
                      title: Text(method['name'], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      onTap: () {
                        setState(() {
                          selectedMethod = method['id'];
                        });
                        // Langsung proses pembayaran untuk menghindari exception dialog QRIS
                        _processPayment();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      
      Navigator.pushReplacement(
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
