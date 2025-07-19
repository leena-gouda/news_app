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

  getNews([String? query]) async {
    emit(HomeLoading());
    try {
      final apiNews = await newsApiRepo.fetchNews(query ?? "sports");
      emit(HomeSuccess(apiNews));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  getNewsByCategory(String category) async {
    emit(HomeLoading());
    try {
      final apiNews = await newsApiRepo.fetchNewsByCategory(category);
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
}