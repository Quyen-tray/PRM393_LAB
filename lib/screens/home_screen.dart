import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../favorites_model.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';

/// Màn hình Home: thanh tìm kiếm + danh sách phim cuộn được.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    // Lọc phim theo từ khoá tìm kiếm (không phân biệt hoa thường)
    final movies = sampleMovies
        .where((m) => m.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('🎬 Movies')),
      body: Column(
        children: [
          // ----- Search bar -----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ----- Danh sách phim -----
          Expanded(
            child: movies.isEmpty
                ? const Center(child: Text('No movies found'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) =>
                  _MovieCard(movie: movies[index]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card hiển thị poster, tiêu đề, rating của một phim.
class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Điều hướng sang Detail và TRUYỀN đối tượng Movie
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailScreen(movie: movie),
            ),
          );
        },
        child: Row(
          children: [
            // Poster (Hero để tạo hiệu ứng chuyển cảnh sang Detail)
            Hero(
              tag: 'poster-${movie.id}',
              child: Image.network(
                movie.posterUrl,
                width: 90,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 90,
                  height: 130,
                  child: Icon(Icons.movie, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${movie.year} • ${movie.genres.take(2).join(", ")}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
            // Icon tim tự cập nhật nhờ AnimatedBuilder lắng nghe favorites
            AnimatedBuilder(
              animation: favorites,
              builder: (_, __) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  favorites.isFavorite(movie.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favorites.isFavorite(movie.id) ? Colors.red : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}