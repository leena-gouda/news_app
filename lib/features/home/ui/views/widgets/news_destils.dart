import 'package:flutter/material.dart';

import '../../../data/models/news_model.dart';
import 'package:intl/intl.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailsScreen({super.key, required this.news});

  String formatDate(String? isoDate) {
    if (isoDate == null) return "";
    final date = DateTime.tryParse(isoDate);
    return date != null ? "${DateFormat('jm').format(date)} ago" : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title ?? "News Details"),
        centerTitle: true,
      ),
      body: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان العلوي
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/bbc.png"), // أو NetworkImage إذا متوفرة
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news.source?.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        formatDate(news.publishedAt),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Following",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // صورة الخبر
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: news.urlToImage != null
                  ? Image.network(
                news.urlToImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50),
              ),
            ),

            // تفاصيل الخبر
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Europe",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text(
                    news.title ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // الإعجابات والتعليقات والحفظ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink, size: 20),
                  const SizedBox(width: 4),
                  const Text("24.5K", style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline, size: 20),
                  const SizedBox(width: 4),
                  const Text("1K", style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  const Icon(Icons.bookmark_border, size: 22),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}