import 'package:flutter/material.dart';
import 'category_page.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'detail_page.dart';
import 'cart_page.dart';
import 'about_page.dart';
import '../utils/format_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BookService servisBuku = BookService();
  final TextEditingController kontrolCari = TextEditingController();
  
  List<Book> listBuku = [];
  bool lagiLoading = false; // Set awal ke false biar gak langsung loading item kosong
  String kataKunci = 'self improvement';

  final List<String> daftarKategori = [
    'Fiction', 'Philosophy', 'Fantasy', 'Business', 'Technology',
  ];

  @override
  void initState() {
    super.initState();
    // Panggil data setelah build pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ambilDataBuku();
    });
  }

  Future<void> ambilDataBuku() async {
    if (!mounted) return;
    setState(() => lagiLoading = true);
    
    try {
      final hasil = await servisBuku.fetchBooks(kataKunci);
      if (mounted) {
        setState(() {
          listBuku = hasil;
          lagiLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => lagiLoading = false);
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
          ),
        ],
      ),
      body: lagiLoading && listBuku.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: ambilDataBuku,
              child: ListView( // Pakai ListView sebagai parent utama biar scrollable
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: kontrolCari,
                      decoration: InputDecoration(
                        hintText: 'Cari buku...',
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

                  // Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.brown[400],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Google Books API', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Cari jutaan buku favoritmu di sini.', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Kategori
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: daftarKategori.length,
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ActionChip(
                            label: Text(daftarKategori[idx]),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(category: daftarKategori[idx])));
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Grid Buku
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: listBuku.length,
                      itemBuilder: (context, index) {
                        final buku = listBuku[index];
                        return InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(book: buku))),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      image: DecorationImage(image: NetworkImage(buku.imageUrl), fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(buku.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(FormatUtil.formatCurrency(buku.price), style: const TextStyle(color: Colors.brown, fontSize: 12)),
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
    );
  }

  @override
  void dispose() {
    kontrolCari.dispose();
    super.dispose();
  }
}
