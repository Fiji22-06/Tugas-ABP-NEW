class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final int price;
  final String description;
  final String imageUrl;
  final double rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};
    
    // Fallback for missing data
    String thumbnail = volumeInfo['imageLinks']?['thumbnail'] ?? '';
    if (thumbnail.startsWith('http:')) {
      thumbnail = thumbnail.replaceFirst('http:', 'https:');
    }

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      author: (volumeInfo['authors'] as List?)?.join(', ') ?? 'Unknown Author',
      category: (volumeInfo['categories'] as List?)?.first ?? 'General',
      price: (saleInfo['listPrice']?['amount']?.toInt()) ?? 125000, // Default price if not for sale
      description: volumeInfo['description'] ?? 'No description available.',
      imageUrl: thumbnail.isNotEmpty ? thumbnail : 'https://via.placeholder.com/150',
      rating: (volumeInfo['averageRating']?.toDouble()) ?? 4.0,
    );
  }
}
