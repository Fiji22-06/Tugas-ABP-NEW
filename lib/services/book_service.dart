import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  // url api google books
  final String apiUrl = 'https://www.googleapis.com/books/v1/volumes';

  // fungsi buat ambil data buku dari api
  Future<List<Book>> fetchBooks(String keyword) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?q=$keyword&maxResults=20'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> items = data['items'] ?? [];
        
        return items.map((item) => Book.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error pas ambil data: $e');
      return [];
    }
  }

  // fungsi buat filter kategori
  Future<List<Book>> fetchByCategory(String kategori) async {
    return fetchBooks('subject:$kategori');
  }
}
