import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الخبر
          news.urlToImage != null
              ? CachedNetworkImage(
            imageUrl: news.urlToImage!,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorWidget:
                (context, url, error) => CachedNetworkImage(
              imageUrl:
              "https://img.freepik.com/free-photo/woman-beach-with-her-baby-enjoying-sunset_52683-144131.jpg?size=626&ext=jpg",

              fit: BoxFit.cover,
            ),
          )
              : Container(
            height: 180,
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.image, size: 50)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان الخبر
                Text(
                  news.title ?? "No title",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // المصدر والتاريخ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      news.source?.name ?? "Unknown Source",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      news.publishedAt ?? "",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}