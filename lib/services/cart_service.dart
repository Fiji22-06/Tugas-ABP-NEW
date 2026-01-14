import '../models/book.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Book> _items = [];

  List<Book> get items => _items;

  void addToCart(Book book) {
    _items.add(book);
  }

  void removeFromCart(Book book) {
    _items.removeWhere((item) => item.id == book.id);
  }

  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price);
  }

  void clearCart() {
    _items.clear();
  }
}
