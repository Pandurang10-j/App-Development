import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/book_model.dart';
import '../widgets/empty_state.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return FutureBuilder<List<BookModel>>(
      future: api.fetchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty) {
          return const EmptyState(message: 'No books available.');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal scroller for featured books
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final b = books[index];
                    return SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                b.imageUrl ?? '',
                                width: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, st) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            b.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            b.author ?? 'Unknown',
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Vertical list of books
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final b = books[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          b.imageUrl ?? '',
                          width: 56,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, st) => Container(
                            width: 56,
                            height: 84,
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      title: Text(b.title),
                      subtitle: Text(b.author ?? 'Unknown'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
