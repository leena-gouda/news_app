
part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}
final class HomeSignOut extends HomeState {}
final class HomeRemove extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<NewsModel> news;

  HomeSuccess(this.news);
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
final class CategoryView extends HomeState {
  final String message;

  CategoryView(this.message);
}
final class BookMarkLoading extends HomeState {}

final class BookMarkLoaded extends HomeState {
  final List<NewsModel> bookmarks;
  BookMarkLoaded(this.bookmarks);
}

final class BookMarkError extends HomeState {
  final String message;
  BookMarkError(this.message);
}
