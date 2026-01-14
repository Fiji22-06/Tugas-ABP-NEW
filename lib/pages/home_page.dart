import 'package:flutter/material.dart';
import 'category_page.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'detail_page.dart';
import 'cart_page.dart';
import 'about_page.dart';
import '../utils/format_util.dart';

// Halaman utama aplikasi
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BookService servisBuku = BookService();
  final TextEditingController kontrolCari = TextEditingController();
  
  List<Book> listBuku = [];
  bool lagiLoading = true;
  String kataKunci = 'self improvement';

  final List<String> daftarKategori = [
    'Fiction',
    'Philosophy',
    'Fantasy',
    'Business',
    'Technology',
  ];

  @override
  void initState() {
    super.initState();
    ambilDataBuku();
  }

  // Fungsi buat ambil data buku dari API
  Future<void> ambilDataBuku() async {
    setState(() => lagiLoading = true);
    try {
      final hasil = await servisBuku.fetchBooks(kataKunci);
      setState(() {
        listBuku = hasil;
        lagiLoading = false;
      });
    } catch (e) {
      setState(() => lagiLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waduh, gagal ambil data. Cek koneksi ya!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookTime Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()))
              .then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ambilDataBuku,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom Pencarian
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: kontrolCari,
                  decoration: InputDecoration(
                    hintText: 'Cari buku apa hari ini?',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSubmitted: (val) {
                    if (val.isNotEmpty) {
                      setState(() => kataKunci = val);
                      ambilDataBuku();
                    }
                  },
                ),
              ),

              // Banner promo / info
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.brown[400],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Google Books API',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: constraints.maxWidth > 600 ? 24 : 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const Text(
                          'Cari jutaan buku favoritmu di sini.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }
              ),
              const SizedBox(height: 24),

              // Bagian Kategori
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Kategori', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: daftarKategori.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ActionChip(
                        label: Text(daftarKategori[idx]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CategoryPage(category: daftarKategori[idx])),
                          ).then((_) => setState(() {}));
                        },
                        backgroundColor: Colors.brown[50],
                        labelStyle: const TextStyle(color: Colors.brown, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Daftar Buku
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Hasil cari: "$kataKunci"', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              lagiLoading
                  ? const Center(child: Padding(padding: EdgeInsets.all(50.0), child: CircularProgressIndicator()))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: listBuku.length,
                        itemBuilder: (context, index) {
                          final buku = listBuku[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DetailPage(book: buku)),
                              ).then((_) => setState(() {}));
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        image: DecorationImage(
                                          image: NetworkImage(buku.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          buku.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          buku.author,
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              FormatUtil.formatCurrency(buku.price),
                                              style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.star, color: Colors.orange, size: 14),
                                                Text(buku.rating.toString(), style: const TextStyle(fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    kontrolCari.dispose();
    super.dispose();
  }
}
