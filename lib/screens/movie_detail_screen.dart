import 'package:flutter/material.dart';

import '../favorites_model.dart';
import '../models/movie.dart';

/// Màn hình chi tiết phim, nhận đối tượng [Movie] qua constructor.
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  double? _userRating; // điểm người dùng tự chấm

  Movie get movie => widget.movie;

  // Hiển thị dialog chấm điểm bằng Slider
  Future<void> _rate() async {
    double temp = _userRating ?? 5;
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate this movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(temp.toStringAsFixed(1),
                  style: Theme.of(ctx).textTheme.headlineMedium),
              Slider(
                value: temp,
                min: 0,
                max: 10,
                divisions: 20,
                onChanged: (v) => setLocal(() => temp = v),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, temp),
                child: const Text('Save')),
          ],
        ),
      ),
    );
    if (result != null) setState(() => _userRating = result);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Body cuộn được: dùng CustomScrollView với SliverAppBar làm banner
      body: CustomScrollView(
        slivers: [
          // ----- Hero banner: poster + gradient -----
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'poster-${movie.id}',
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.movie, size: 80)),
                    ),
                  ),
                  // Gradient làm tối phía dưới để chữ dễ đọc
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ----- Nội dung chi tiết -----
          SliverToBoxAdapter(
            // Giới hạn chiều rộng để responsive trên màn hình lớn
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating + năm
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${movie.rating.toStringAsFixed(1)} / 10',
                              style: textTheme.titleMedium),
                          const SizedBox(width: 16),
                          Text('${movie.year}', style: textTheme.titleMedium),
                          if (_userRating != null) ...[
                            const SizedBox(width: 16),
                            Text('Your rating: ${_userRating!.toStringAsFixed(1)}'),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Genres hiển thị bằng Wrap + Chip
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: movie.genres
                            .map((g) => Chip(label: Text(g)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Overview
                      Text('Overview', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(movie.overview, style: textTheme.bodyLarge),
                      const SizedBox(height: 16),

                      // Action buttons: Favorite / Rate / Share
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Favorite: lắng nghe model để đổi icon
                          AnimatedBuilder(
                            animation: favorites,
                            builder: (_, __) {
                              final fav = favorites.isFavorite(movie.id);
                              return _ActionButton(
                                icon: fav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                label: 'Favorite',
                                color: fav ? Colors.red : null,
                                onTap: () {
                                  favorites.toggle(movie.id);
                                  _showMessage(fav
                                      ? 'Removed from favorites'
                                      : 'Added to favorites');
                                },
                              );
                            },
                          ),
                          _ActionButton(
                            icon: Icons.star_border,
                            label: 'Rate',
                            onTap: _rate,
                          ),
                          _ActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () =>
                                _showMessage('Shared "${movie.title}"'),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // Danh sách trailer
                      Text('Trailers', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      // shrinkWrap + NeverScrollable vì đã nằm trong vùng cuộn
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: movie.trailers.length,
                        itemBuilder: (context, i) {
                          final t = movie.trailers[i];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    t.thumbnailUrl,
                                    width: 110,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                    const SizedBox(width: 110, height: 70),
                                  ),
                                  const Icon(Icons.play_circle_fill,
                                      color: Colors.white, size: 32),
                                ],
                              ),
                              title: Text(t.title),
                              subtitle: Text(t.duration),
                              onTap: () => _showMessage('Playing ${t.title}...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nút hành động gồm icon + nhãn bên dưới.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, color: color), iconSize: 32, onPressed: onTap),
        Text(label),
      ],
    );
  }
}