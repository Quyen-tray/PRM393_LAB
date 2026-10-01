/// Model đại diện cho một đoạn trailer của phim.
class Trailer {
  final String title;
  final String duration; // ví dụ: "2:30"
  final String thumbnailUrl;

  const Trailer({
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
  });
}

/// Model đại diện cho một bộ phim.
/// Đối tượng này được truyền từ Home sang Detail khi điều hướng.
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating; // thang điểm 10
  final int year;
  final List<Trailer> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.year,
    required this.trailers,
  });
}