import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({super.key});

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  String _selectedType = 'story';
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addContent() async {
    if (_titleController.text.trim().isEmpty) {
      _showMessage('Please enter a title', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> data = {
        'title': _titleController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      switch (_selectedType) {
        case 'story':
          data['author'] = _authorController.text.trim();
          data['genre'] = _genreController.text.trim();
          data['description'] = _descriptionController.text.trim();
          break;
        case 'comic':
          data['publisher'] = _authorController.text.trim();
          data['coverImage'] = _imageUrlController.text.trim();
          break;
        case 'news':
          data['source'] = _authorController.text.trim();
          data['description'] = _descriptionController.text.trim();
          data['urlToImage'] = _imageUrlController.text.trim();
          data['publishedAt'] = DateTime.now().toIso8601String();
          break;
        case 'quote':
          data['text'] = _descriptionController.text.trim();
          data['author'] = _authorController.text.trim();
          break;
        case 'book':
          data['author'] = _authorController.text.trim();
          data['country'] = _genreController.text.trim();
          data['pages'] = int.tryParse(_descriptionController.text.trim()) ?? 0;
          break;
      }

      await _firestore.collection('${_selectedType}s').add(data);

      _showMessage('${_selectedType.toUpperCase()} added successfully!', isError: false);

      _clearFields();
    } catch (e) {
      _showMessage('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearFields() {
    _titleController.clear();
    _authorController.clear();
    _descriptionController.clear();
    _genreController.clear();
    _imageUrlController.clear();
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Content'),
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content Type Selector
            const Text(
              'Select Content Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildTypeChip('story', 'Story', Icons.auto_stories),
                _buildTypeChip('comic', 'Comic', Icons.book),
                _buildTypeChip('news', 'News', Icons.newspaper),
                _buildTypeChip('quote', 'Quote', Icons.format_quote),
                _buildTypeChip('book', 'Book', Icons.menu_book),
              ],
            ),
            const SizedBox(height: 32),

            // Title Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),

            // Author/Publisher/Source Field
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: _getSecondFieldLabel(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // Genre/Country Field (for story and book)
            if (_selectedType == 'story' || _selectedType == 'book')
              Column(
                children: [
                  TextField(
                    controller: _genreController,
                    decoration: InputDecoration(
                      labelText: _selectedType == 'story' ? 'Genre' : 'Country',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Description/Text/Pages Field
            if (_selectedType != 'comic')
              TextField(
                controller: _descriptionController,
                maxLines: _selectedType == 'quote' ? 5 : 3,
                decoration: InputDecoration(
                  labelText: _getThirdFieldLabel(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
              ),

            // Image URL Field (for comic and news)
            if (_selectedType == 'comic' || _selectedType == 'news')
              Column(
                children: [
                  if (_selectedType != 'comic') const SizedBox(height: 16),
                  TextField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.image),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 32),

            // Add Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A11CB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add ${_selectedType.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF6A11CB)),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedType = type;
          _clearFields();
        });
      },
      selectedColor: const Color(0xFF6A11CB),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF6A11CB),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _getSecondFieldLabel() {
    switch (_selectedType) {
      case 'story':
      case 'book':
      case 'quote':
        return 'Author';
      case 'comic':
        return 'Publisher';
      case 'news':
        return 'Source';
      default:
        return 'Author';
    }
  }

  String _getThirdFieldLabel() {
    switch (_selectedType) {
      case 'story':
      case 'news':
        return 'Description';
      case 'quote':
        return 'Quote Text';
      case 'book':
        return 'Pages (number)';
      default:
        return 'Description';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _genreController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}