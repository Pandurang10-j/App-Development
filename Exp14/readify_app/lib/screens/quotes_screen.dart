import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/quote_model.dart';
import '../widgets/empty_state.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return FutureBuilder<List<QuoteModel>>(
      future: api.fetchQuotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final quotes = snapshot.data ?? [];

        if (quotes.isEmpty) {
          return const EmptyState(message: 'No quotes found.');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            final q = quotes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '"${q.text}"',
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      q.author ?? 'Unknown',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
