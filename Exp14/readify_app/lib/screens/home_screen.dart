import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/api_service.dart';

// Models kept
import '../models/manga_model.dart';
import '../models/article_model.dart';
import '../models/joke_model.dart';
import '../models/fact_model.dart';

// Cards kept
import '../widgets/manga_card.dart';
import '../widgets/article_card.dart';
import '../widgets/joke_card.dart';
import '../widgets/fact_card.dart';

// Screens
import 'library_screen.dart';
import 'profile_screen.dart';
import 'admin_dashboard.dart';
import 'vip_subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  // Only keeping 4 lists
  List<MangaModel> _manga = [];
  List<ArticleModel> _articles = [];
  List<JokeModel> _jokes = [];
  List<FactModel> _facts = [];

  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _apiService.fetchManga(),
        _apiService.fetchArticles(),
        _apiService.fetchJokes(),
        _apiService.fetchFacts(),
      ]);

      setState(() {
        _manga = results[0] as List<MangaModel>;
        _articles = results[1] as List<ArticleModel>;
        _jokes = results[2] as List<JokeModel>;
        _facts = results[3] as List<FactModel>;

        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final isGuest = user.isGuest;
    final isAdmin = user.isAdmin;
    final isVIP = user.isVIP;

    final List<Widget> screens = [
      _buildHomeContent(isGuest, isVIP),
      const LibraryScreen(),
      if (isAdmin) const AdminDashboard(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6A11CB),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Library'),
          if (isAdmin)
            const BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      floatingActionButton: (!isGuest && !isVIP)
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFFFFD700),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VIPSubscriptionScreen()),
                );
              },
              label: const Text(
                'Upgrade to VIP',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.star, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHomeContent(bool isGuest, bool isVIP) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [Color(0xFF6A11CB), Colors.white],
          stops: [0.0, 0.3],
        ),
      ),
      child: Column(
        children: [
          // HEADER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  const Text(
                    'Readify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isVIP) _vipBadge(),
                  if (isGuest) _guestBadge(),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadAllData,
                  ),
                ],
              ),
            ),
          ),

          _buildTabBar(),
          const SizedBox(height: 16),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      isGuest
                          ? _buildLockedContent("Manga")
                          : _gridOrEmpty(_manga, (m) => MangaCard(manga: m)),
                      _listOrEmpty(_articles, (a) => ArticleCard(article: a)),
                      _listOrEmpty(_jokes, (j) => JokeCard(joke: j)),
                      _listOrEmpty(_facts, (f) => FactCard(fact: f)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF6A11CB),
        unselectedLabelColor: Colors.grey,
        isScrollable: true,
        indicator: BoxDecoration(
          color: const Color(0xFF6A11CB).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        tabs: const [
          Tab(text: 'Manga'),
          Tab(text: 'Articles'),
          Tab(text: 'Jokes'),
          Tab(text: 'Facts'),
        ],
      ),
    );
  }

  Widget _listOrEmpty<T>(List<T> data, Widget Function(T) builder) {
    if (data.isEmpty) return const Center(child: Text("No data available"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (_, i) => builder(data[i]),
    );
  }

  Widget _gridOrEmpty<T>(List<T> data, Widget Function(T) builder) {
    if (data.isEmpty) return const Center(child: Text("No data available"));
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => builder(data[i]),
    );
  }

  Widget _vipBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.star, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            "VIP",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _guestBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Guest",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLockedContent(String label) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock,
                  size: 60, color: Color(0xFFFFD700)),
            ),
            const SizedBox(height: 24),
            const Text(
              "Premium Content",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Sign in to unlock $label",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Please sign in from the Profile tab")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
              ),
              child: const Text("Sign In"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
