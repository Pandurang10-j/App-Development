import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/story_model.dart';
import '../models/comic_model.dart';
import '../models/news_model.dart';
import '../models/manga_model.dart';
import '../models/quote_model.dart';
import '../models/article_model.dart';
import '../models/joke_model.dart';
import '../models/fact_model.dart';
import '../models/book_model.dart';

class ApiService {
  // -------------------- STORIES (Manual) --------------------
  Future<List<StoryModel>> fetchStories() async {
    return [
      StoryModel(
        id: 1,
        author: "John Smith",
        title: "The Lost Forest",
        imageUrl: "https://picsum.photos/400/300?random=1",
        description: "A magical adventure in an ancient forest.",
      ),
      StoryModel(
        id: 2,
        author: "Emily Clark",
        title: "Shadow Knight",
        imageUrl: "https://picsum.photos/400/300?random=2",
        description: "A dark hero rises to fight evil.",
      ),
      StoryModel(
        id: 3,
        author: "Sophia Lee",
        title: "Ocean Whisper",
        imageUrl: "https://picsum.photos/400/300?random=9",
        description: "Story of a girl who communicates with the sea.",
      ),
      StoryModel(
        id: 4,
        author: "Michael Brown",
        title: "Golden Empire",
        imageUrl: "https://picsum.photos/400/300?random=10",
        description: "A lost empire full of ancient mysteries.",
      ),
    ];
  }

  // -------------------- COMICS (Manual) --------------------
  Future<List<ComicModel>> fetchComics() async {
    return [
      ComicModel(
        title: "Spider-Man",
        imageUrl: "https://picsum.photos/400/300?random=3",
      ),
      ComicModel(
        title: "Batman",
        imageUrl: "https://picsum.photos/400/300?random=4",
      ),
      ComicModel(
        title: "Superman",
        imageUrl: "https://picsum.photos/400/300?random=11",
      ),
      ComicModel(
        title: "Iron Man",
        imageUrl: "https://picsum.photos/400/300?random=12",
      ),
    ];
  }

  // -------------------- NEWS (LIVE API) --------------------
  Future<List<NewsModel>> fetchNews() async {
    try {
      final url = Uri.parse(
        "https://saurav.tech/NewsAPI/top-headlines/category/technology/in.json",
      );
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data["articles"] ?? [];
        return list.map((e) => NewsModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("NEWS API ERROR → Using empty list");
    }

    return [];
  }

  // -------------------- QUOTES (Manual) --------------------
  Future<List<QuoteModel>> fetchQuotes() async {
    return [
      QuoteModel(text: "Dream big, work hard.", author: "Unknown"),
      QuoteModel(text: "Success comes to those who persevere.", author: "A.P.J. Abdul Kalam"),
      QuoteModel(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
      QuoteModel(text: "Stay positive, work hard, make it happen.", author: "Unknown"),
    ];
  }

  // -------------------- BOOKS (Manual) --------------------
  Future<List<BookModel>> fetchBooks() async {
    return [
      BookModel(
        title: "Harry Potter",
        author: "J.K. Rowling",
        imageUrl: "https://picsum.photos/400/300?random=7",
      ),
      BookModel(
        title: "The Hobbit",
        author: "J.R.R. Tolkien",
        imageUrl: "https://picsum.photos/400/300?random=8",
      ),
      BookModel(
        title: "The Alchemist",
        author: "Paulo Coelho",
        imageUrl: "https://picsum.photos/400/300?random=15",
      ),
      BookModel(
        title: "Atomic Habits",
        author: "James Clear",
        imageUrl: "https://picsum.photos/400/300?random=16",
      ),
    ];
  }

  // -------------------- MANGA (API + Manual Fallback) --------------------
  Future<List<MangaModel>> fetchManga() async {
    try {
      final response = await http.get(Uri.parse('https://api.jikan.moe/v4/manga'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'] ?? [];
        return list.map((e) => MangaModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("MANGA API ERROR → Using manual data");
    }

    return [
      MangaModel(id: 1, title: "Naruto", imageUrl: "https://picsum.photos/400/300?random=17"),
      MangaModel(id: 2, title: "One Piece", imageUrl: "https://picsum.photos/400/300?random=18"),
      MangaModel(id: 3, title: "Attack on Titan", imageUrl: "https://picsum.photos/400/300?random=19"),
      MangaModel(id: 4, title: "Death Note", imageUrl: "https://picsum.photos/400/300?random=20"),
    ];
  }

  // -------------------- ARTICLES (API + Manual) --------------------
  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.spaceflightnewsapi.net/v4/articles"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['results'] ?? [];
        return list.map((e) => ArticleModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("ARTICLES API ERROR → Using manual data");
    }

    return [
      ArticleModel(
        id: 1,
        title: "NASA Discovers New Planet",
        imageUrl: "https://picsum.photos/400/300?random=21",
        summary: "A new habitable-zone planet found.",
      ),
      ArticleModel(
        id: 2,
        title: "Black Hole Mystery Solved",
        imageUrl: "https://picsum.photos/400/300?random=22",
        summary: "Scientists make breakthrough discovery.",
      ),
      ArticleModel(
        id: 3,
        title: "Space Tourism Rising",
        imageUrl: "https://picsum.photos/400/300?random=23",
        summary: "More companies entering the space race.",
      ),
      ArticleModel(
        id: 4,
        title: "Moon Base Plans Announced",
        imageUrl: "https://picsum.photos/400/300?random=24",
        summary: "NASA proposes permanent lunar base.",
      ),
    ];
  }

  // -------------------- JOKES (API + Manual) --------------------
  Future<List<JokeModel>> fetchJokes() async {
    try {
      final response =
          await http.get(Uri.parse('https://v2.jokeapi.dev/joke/Any?amount=10'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jokes = data['jokes'] ?? [];
        return jokes.map((e) => JokeModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("JOKES API ERROR → Using manual data");
    }

    return [
      JokeModel(id: 1, type: "single", joke: "Why don’t skeletons fight each other? They don’t have the guts."),
      JokeModel(id: 2, type: "single", joke: "I told my computer I needed a break, and it said 'No problem — I'll go to sleep.'"),
      JokeModel(id: 3, type: "single", joke: "Why was the math book sad? It had too many problems."),
      JokeModel(id: 4, type: "single", joke: "Parallel lines have so much in common. It's a shame they’ll never meet."),
    ];
  }

  // -------------------- FACTS (API + Manual) --------------------
  Future<List<FactModel>> fetchFacts() async {
    List<FactModel> facts = [];

    try {
      for (int i = 0; i < 4; i++) {
        final response = await http.get(
          Uri.parse("https://uselessfacts.jsph.pl/api/v2/facts/random?language=en"),
        );

        if (response.statusCode == 200) {
          facts.add(FactModel.fromJson(json.decode(response.body)));
        }
      }

      if (facts.isNotEmpty) return facts;
    } catch (e) {
      print("FACTS API ERROR → Using manual data");
    }

    return [
      FactModel(text: "Honey never spoils."),
      FactModel(text: "Bananas are berries, but strawberries aren’t."),
      FactModel(text: "Octopuses have three hearts."),
      FactModel(text: "A day on Venus is longer than a year on Venus."),
    ];
  }

  // -------------------- COMBINED FEED --------------------
  Future<Map<String, dynamic>> fetchAllContent() async {
    final results = await Future.wait([
      fetchStories(),
      fetchComics(),
      fetchNews(),
      fetchManga(),
      fetchQuotes(),
      fetchArticles(),
      fetchBooks(),
      fetchJokes(),
      fetchFacts(),
    ]);

    return {
      'stories': results[0],
      'comics': results[1],
      'news': results[2],
      'manga': results[3],
      'quotes': results[4],
      'articles': results[5],
      'books': results[6],
      'jokes': results[7],
      'facts': results[8],
    };
  }
}
