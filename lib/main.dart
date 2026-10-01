import 'package:flutter/material.dart';

/// Lab 6 – Responsive Movie Genre Browsing Screen
/// Toàn bộ demo nằm trong 1 file để có thể dán vào DartPad.
///  - Lab 6.1: Hero & Heading
///  - Lab 6.2: Search, Genre chips, Sort bar
///  - Lab 6.3: Responsive movie list (1 cột / 2 cột) bằng LayoutBuilder

void main() => runApp(const ResponsiveMovieApp());

// ---------------------------------------------------------------------------
// MODEL & SAMPLE DATA
// ---------------------------------------------------------------------------

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

/// Dùng picsum.photos làm ảnh placeholder (seed giúp ảnh cố định).
String _poster(String seed) => 'https://picsum.photos/seed/$seed/300/450';

final List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: const ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: _poster('inception'),
    rating: 8.8,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: const ['Sci-Fi', 'Drama'],
    posterUrl: _poster('interstellar'),
    rating: 8.7,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: const ['Action', 'Crime', 'Drama'],
    posterUrl: _poster('darkknight'),
    rating: 9.0,
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: const ['Drama', 'Comedy', 'Thriller'],
    posterUrl: _poster('parasite'),
    rating: 8.5,
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: const ['Comedy', 'Drama'],
    posterUrl: _poster('budapest'),
    rating: 8.1,
  ),
  Movie(
    title: 'Get Out',
    year: 2017,
    genres: const ['Horror', 'Thriller'],
    posterUrl: _poster('getout'),
    rating: 7.7,
  ),
];

const List<String> allGenres = [
  'Action',
  'Drama',
  'Comedy',
  'Sci-Fi',
  'Thriller',
  'Crime',
  'Horror',
];

const List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

// ---------------------------------------------------------------------------
// APP
// ---------------------------------------------------------------------------

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 - Responsive UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GenreScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// GENRE SCREEN
// ---------------------------------------------------------------------------

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';
  final TextEditingController _searchController = TextEditingController();

  /// Breakpoint: từ 800px trở lên dùng 2 cột.
  static const double tabletBreakpoint = 800;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Lọc theo search + genre, sau đó sắp xếp.
  List<Movie> get visibleMovies {
    final q = searchQuery.trim().toLowerCase();

    final list = allMovies.where((m) {
      // Search không phân biệt hoa thường theo title
      final matchesSearch = q.isEmpty || m.title.toLowerCase().contains(q);
      // Nếu có chọn genre: phim phải có ít nhất 1 genre được chọn
      final matchesGenre = selectedGenres.isEmpty ||
          m.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    switch (selectedSort) {
      case 'A-Z':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        list.sort((a, b) => b.year.compareTo(a.year)); // mới nhất trước
        break;
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating)); // cao nhất trước
        break;
    }
    return list;
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      _searchController.clear();
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    final movies = visibleMovies;
    final hasFilters = searchQuery.isNotEmpty || selectedGenres.isNotEmpty;

    return Scaffold(
      // SafeArea tránh tai thỏ / camera cutout
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeading(context, hasFilters),
              const SizedBox(height: 12),
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildGenreChips(),
              const SizedBox(height: 8),
              _buildSortBar(movies.length),
              const SizedBox(height: 8),
              // Danh sách phim chiếm phần còn lại của màn hình
              Expanded(child: _buildMovieArea(movies)),
            ],
          ),
        ),
      ),
    );
  }

  // ----- Lab 6.1: Heading -----
  Widget _buildHeading(BuildContext context, bool hasFilters) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Find a Movie',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // Bonus: nút Clear filters
        if (hasFilters)
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear),
            label: const Text('Clear'),
          ),
      ],
    );
  }

  // ----- Lab 6.2: Search bar -----
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: const InputDecoration(
          hintText: 'Search by title...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ----- Lab 6.2: Genre chips (Wrap tự xuống dòng) -----
  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: allGenres.map((genre) {
        final selected = selectedGenres.contains(genre);
        return FilterChip(
          label: Text(genre),
          selected: selected,
          onSelected: (_) {
            setState(() {
              // Đã chọn -> bỏ chọn; chưa chọn -> thêm vào
              if (selected) {
                selectedGenres.remove(genre);
              } else {
                selectedGenres.add(genre);
              }
            });
          },
        );
      }).toList(),
    );
  }

  // ----- Lab 6.2: Sort bar -----
  Widget _buildSortBar(int resultCount) {
    return Row(
      children: [
        // Bonus: badge số genre đang chọn
        if (selectedGenres.isNotEmpty) ...[
          Badge(
            label: Text('${selectedGenres.length}'),
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: Text('$resultCount results')),
        const Text('Sort: '),
        DropdownButton<String>(
          value: selectedSort,
          underline: const SizedBox.shrink(),
          items: sortOptions
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => selectedSort = value);
          },
        ),
      ],
    );
  }

  // ----- Lab 6.3: Responsive list / grid -----
  Widget _buildMovieArea(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text('No movies match your filters.'));
    }

    // LayoutBuilder đọc bề rộng thực tế của vùng chứa danh sách
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < tabletBreakpoint) {
          // Màn hình nhỏ: 1 cột
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: movies.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(height: _cardHeight, child: MovieCard(movie: movies[i])),
            ),
          );
        }

        // Màn hình rộng: 2 cột bằng GridView.count
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          // Giữ chiều cao thẻ cố định = _cardHeight
          childAspectRatio: itemWidth / _cardHeight,
          padding: const EdgeInsets.only(bottom: 16),
          children: movies.map((m) => MovieCard(movie: m)).toList(),
        );
      },
    );
  }

  static const double _cardHeight = 150;
}

// ---------------------------------------------------------------------------
// MOVIE CARD
// ---------------------------------------------------------------------------

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      // LayoutBuilder trong card: chỉnh kích thước poster theo bề rộng card
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posterWidth = (constraints.maxWidth * 0.25).clamp(80.0, 130.0);

          return Row(
            children: [
              Image.network(
                movie.posterUrl,
                width: posterWidth,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => SizedBox(
                  width: posterWidth,
                  child: const Center(child: Icon(Icons.movie, size: 36)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('${movie.year}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      // Bonus: hiển thị rating dạng số + sao
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(movie.rating.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.genres.join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}