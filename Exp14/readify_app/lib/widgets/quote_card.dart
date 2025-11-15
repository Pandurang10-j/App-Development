import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6A11CB).withOpacity(0.1),
              const Color(0xFF2575FC).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.format_quote,
              size: 32,
              color: Color(0xFF6A11CB),
            ),
            const SizedBox(height: 12),
            Text(
              quote.text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            if (quote.author != null && quote.author!.isNotEmpty)
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 2,
                    color: const Color(0xFF6A11CB),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quote.author!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A11CB),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}