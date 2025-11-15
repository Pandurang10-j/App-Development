import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/firestore_service.dart';

class ReaderScreen extends StatefulWidget {
  final String title;
  final String author;
  final String content;

  const ReaderScreen({
    super.key,
    required this.title,
    required this.author,
    required this.content,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  double _fontSize = 16.0;
  bool _isBookmarked = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isGuest = userProvider.isGuest;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: isGuest
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign in to bookmark content'),
                      ),
                    );
                  }
                : () {
                    setState(() => _isBookmarked = !_isBookmarked);
                    if (_isBookmarked) {
                      _firestoreService.addBookmark(
                        userProvider.currentUser!.uid,
                        {
                          'title': widget.title,
                          'author': widget.author,
                          'type': 'story',
                          'timestamp': DateTime.now().toIso8601String(),
                        },
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks',
                        ),
                      ),
                    );
                  },
          ),
          PopupMenuButton<double>(
            icon: const Icon(Icons.format_size),
            onSelected: (value) {
              setState(() => _fontSize = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 14.0, child: Text('Small')),
              const PopupMenuItem(value: 16.0, child: Text('Medium')),
              const PopupMenuItem(value: 18.0, child: Text('Large')),
              const PopupMenuItem(value: 20.0, child: Text('Extra Large')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${widget.author}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              widget.content,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}