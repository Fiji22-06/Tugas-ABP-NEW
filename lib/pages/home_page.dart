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
  bool lagiLoading = false;
  String kataKunci = 'self improvement';

  final List<String> daftarKategori = [
    'Fiction', 'Philosophy', 'Fantasy', 'Business', 'Technology',
  ];

  @override
  void initState() {
    super.initState();
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
    // Hitung jumlah kolom berdasarkan lebar layar
    final double lebarLayar = MediaQuery.of(context).size.width;
    final int jumlahKolom = lebarLayar > 900 ? 5 : (lebarLayar > 600 ? 4 : 2);

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
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
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

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: jumlahKolom, // Dinamis sesuai lebar layar
                        childAspectRatio: 0.65, // Sedikit lebih ramping biar gak kegedean
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: listBuku.length,
                      itemBuilder: (context, index) {
                        final buku = listBuku[index];
                        return InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(book: buku))),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    buku.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(child: Icon(Icons.book, color: Colors.grey)),
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
                                        maxLines: 2, 
                                        overflow: TextOverflow.ellipsis, 
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        FormatUtil.formatCurrency(buku.price), 
                                        style: const TextStyle(color: Colors.brown, fontSize: 12, fontWeight: FontWeight.w600)
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
    );
  }

  @override
  void dispose() {
    kontrolCari.dispose();
    super.dispose();
  }
}
