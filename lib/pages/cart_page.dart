import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../utils/format_util.dart';
import 'payment_page.dart';
import '../models/book.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = CartService();

  @override
  Widget build(BuildContext context) {
    final daftarBuku = cart.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2), // Warna background lebih soft
      appBar: AppBar(
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: daftarBuku.isEmpty
          ? _tampilanKosong()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: daftarBuku.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = daftarBuku[index];
                return _itemKeranjang(item);
              },
            ),
      bottomNavigationBar: daftarBuku.isEmpty ? null : _panelCheckout(daftarBuku),
    );
  }

  Widget _tampilanKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart_rounded, 
            size: 100, 
            color: Colors.brown.withOpacity(0.2)
          ),
          const SizedBox(height: 20),
          const Text(
            'Wah, keranjangmu masih kosong nih!',
            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _itemKeranjang(Book buku) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            buku.imageUrl,
            width: 60,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: 60,
              color: Colors.brown[50],
              child: const Icon(Icons.book_rounded, color: Colors.brown),
            ),
          ),
        ),
        title: Text(
          buku.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            FormatUtil.formatCurrency(buku.price),
            style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.w600),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              cart.removeFromCart(buku);
            });
          },
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _panelCheckout(List<Book> listBuku) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Belanja', style: TextStyle(color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  FormatUtil.formatCurrency(cart.totalPrice),
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.brown
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            height: 50,
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      totalAmount: cart.totalPrice,
                      items: List<Book>.from(listBuku),
                    ),
                  ),
                ).then((value) => setState(() {}));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Bayar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
