import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/news_model.dart';
import '../../data/repos/news_api_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final NewsApiRepo newsApiRepo;

  HomeCubit(this.newsApiRepo) : super(HomeInitial());

  Future<void> init() async {
    await loadBookmarks();
    getNews();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  List<String> categories = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology",
  ];

  bool showCategoryView = false;

  getNews([String? query]) async {
    emit(HomeLoading());
    try {
      final apiNews = await newsApiRepo.fetchNews(query ?? "business");
      emit(HomeSuccess(apiNews));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  int currentIndex = 0;

  String get selectedCategory => categories[currentIndex];

  getNewsByCategory(String category,int index) async {
    emit(HomeLoading());
    try {
      final apiNews = await newsApiRepo.fetchNewsByCategory(category);
      currentIndex = index;
      emit(HomeSuccess(apiNews));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  getTrendingNews() async {
    emit(HomeLoading());
    try {
      final apiNews = await newsApiRepo.fetchTrendingNews();
      emit(HomeSuccess(apiNews));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }


  void signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    auth.signOut();
    prefs.clear();
    emit(HomeSignOut());
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      getToken();
    }
  }

  getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("fcmToken", fcmToken);
      print("Saved FCM Token: ${prefs.getString("fcmToken")}");
    } else {
      print("Failed to get FCM token");
    }
  }

  void getDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(HomeLoading());
    final user = auth.currentUser;
    print("user :${user?.email}");
    if (user != null) {
      await prefs.setString("email", user.email.toString());
      print("prefs : ${prefs.getString("email")}");
      // emit(HomeSuccess(user));
    } else {
      emit(HomeError('User not found'));
    }
  }

  void enableCategoryView(String category, int index) {
    showCategoryView = true;
    currentIndex = index;
    getNewsByCategory(category, index);
    emit(CategoryView('Showing news for $category'));
  }
  void disableCategoryView() {
    showCategoryView = false;
    emit(CategoryView('Showing all news'));
    getNews();
  }

  final List<NewsModel> _bookmarkedArticles = [];

  List<NewsModel> get bookmarkedArticles =>List.unmodifiable(_bookmarkedArticles);

  Future<void> loadBookmarks() async {
    emit(BookMarkLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('bookmarkedArticles') ?? [];

      _bookmarkedArticles
        ..clear()
        ..addAll(saved.map((jsonStr) => NewsModel.fromJson(jsonDecode(jsonStr))));

      emit(BookMarkLoaded(List.unmodifiable(_bookmarkedArticles)));
    } catch (e) {
      emit(BookMarkError(e.toString()));
    }
  }
  Future<void> addBookmark(NewsModel news) async {
    if (!_bookmarkedArticles.any((a) => a.title == news.title)) {
      _bookmarkedArticles.add(news);
      await _saveBookmarks();
    }
    emit(BookMarkLoaded(List.unmodifiable(_bookmarkedArticles)));
  }
  Future<void> removeBookmark(NewsModel news) async {
    try {
      _bookmarkedArticles.removeWhere((a) => a.title == news.title);
      await _saveBookmarks();
      emit(BookMarkLoaded(List.unmodifiable(_bookmarkedArticles)));
    } catch (e) {
      emit(BookMarkError('Failed to remove bookmark'));
      rethrow;
    }
  }
  Future<void> toggleBookmark(NewsModel news) async {
    final exists = _bookmarkedArticles.any((a) => a.title == news.title);
    if (exists) {
      _bookmarkedArticles.removeWhere((a) => a.title == news.title);
    } else {
      _bookmarkedArticles.add(news);
    }
    await _saveBookmarks();
    emit(BookMarkLoaded(List.unmodifiable(_bookmarkedArticles)));
  }
  bool isBookmarked(NewsModel news) {
    return _bookmarkedArticles.any((a) => a.title == news.title);
  }
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = _bookmarkedArticles
        .map((article) => jsonEncode(article.toJson()))
        .toList();
    await prefs.setStringList('bookmarkedArticles', saved);
  }
  Future<void> searchBookmarks(String query) async {
    emit(BookMarkLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('bookmarkedArticles') ?? [];

      final allBookmarks = saved.map((jsonStr) => NewsModel.fromJson(jsonDecode(jsonStr))).toList();

      final filtered = allBookmarks.where((article) {
        final titleMatch = article.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final descMatch = article.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final sourceMatch = article.source?.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return titleMatch || descMatch || sourceMatch;
      }).toList();

      _bookmarkedArticles
        ..clear()
        ..addAll(filtered);

      emit(BookMarkLoaded(List.unmodifiable(_bookmarkedArticles)));
    } catch (e) {
      emit(BookMarkError('Failed to search bookmarks'));
    }
  }
}