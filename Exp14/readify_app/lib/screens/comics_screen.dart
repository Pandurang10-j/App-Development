import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/comic_model.dart';
import '../widgets/empty_state.dart';

class ComicsScreen extends StatelessWidget {
  const ComicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return FutureBuilder<List<ComicModel>>(
      future: api.fetchComics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final comics = snapshot.data ?? [];

        if (comics.isEmpty) {
          return const EmptyState(message: 'No comics available.');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: comics.length,
          itemBuilder: (context, index) {
            final c = comics[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        c.imageUrl ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (cxt, e, st) => Container(
                          color: Colors.grey[800],
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      c.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
