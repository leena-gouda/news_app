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

  HomeCubit(this.newsApiRepo) : super(HomeInitial()){
    loadBookmarks();
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

  final List<NewsModel> bookmarkedArticles = [];

  void toggleBookmark(NewsModel news) {
    if (bookmarkedArticles.contains(news)) {
      emit(BookMarkRemove("Bookmark removed"));
      bookmarkedArticles.remove(news);
    } else {
      emit(BookMarkAdd("Bookmark added"));
      bookmarkedArticles.add(news);
    }
    emit(BookMarkToggle());
  }

  bool isBookmarked(NewsModel news) {
    if(bookmarkedArticles.isEmpty) {
      emit(BookMarkEmpty("No bookmarks found"));
    }else{
      emit(BookMarkLoaded());
    }
    return bookmarkedArticles.contains(news);
  }

  void removeBookmark(NewsModel news) {
    bookmarkedArticles.remove(news);
    emit(BookMarkRemove("Bookmark removed"));
  }

  List<String?> get allBookmarkedIds =>
      bookmarkedArticles.map((article) => article.title).toList();


  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = bookmarkedArticles.map((article) => jsonEncode(article.toJson())).toList();
    await prefs.setStringList('bookmarkedArticles', saved);
    emit(BookMarkSuccess(bookmarkedArticles));
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarkedArticles') ?? [];
    bookmarkedArticles.clear();
    for (var jsonStr in saved) {
      final article = NewsModel.fromJson(jsonDecode(jsonStr));
      bookmarkedArticles.add(article);
    }
    for (var jsonStr in saved) {
      final decoded = jsonDecode(jsonStr);
      print('Decoded type: ${decoded.runtimeType}');
    }
    emit(BookMarkLoaded());
  }
}