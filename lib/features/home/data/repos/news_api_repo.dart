
import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/news_model.dart';

class NewsApiRepo {
  final dio = DioClient();
  String apiKey = "1a0ac09f5f074de4abe53a2af46bcac1";

  Future<List<NewsModel>> fetchNews(String query) async {
    final response = await dio.get(
      EndpointConstants.everything,
      queryParameters: {
        "q": query,
        "from": DateTime.now().subtract(Duration(days: 1)).toString().split(' ')[0],
        "sortBy": "publishedAt",
        "apiKey": apiKey,
      },
    );
    return (response.data['articles'] as List)
        .map((e) => NewsModel.fromJson(e))
        .toList();
  }


  Future<List<NewsModel>> fetchNewsByCategory(String category) async {
    final response = await dio.get(
      EndpointConstants.topHeadlines,
      queryParameters: {
        "country": "us",
        "category": category,
        "apiKey": apiKey,
      },
    );
    return (response.data['articles'] as List)
        .map((e) => NewsModel.fromJson(e))
        .toList();
  }
}