import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'detail_page.dart';
import '../utils/format_util.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryBooks();
  }

  Future<void> _loadCategoryBooks() async {
    try {
      final books = await _bookService.fetchByCategory(widget.category);
      if (mounted) {
        setState(() {
          _books = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan logika responsif yang sama dengan HomePage
    final double lebarLayar = MediaQuery.of(context).size.width;
    final int jumlahKolom = lebarLayar > 900 ? 5 : (lebarLayar > 600 ? 4 : 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori: ${widget.category}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? const Center(child: Text('Tidak ada buku ditemukan'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: jumlahKolom, // Konsisten dengan HomePage
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(book: book),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                book.imageUrl,
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
                                    book.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    FormatUtil.formatCurrency(book.price),
                                    style: const TextStyle(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
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
    );
  }
}
