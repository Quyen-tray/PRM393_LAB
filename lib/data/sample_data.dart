import '../models/movie.dart';

/// Dữ liệu mẫu tĩnh (không gọi API).
/// Ảnh lấy từ picsum.photos (có seed để ảnh luôn cố định).
String _img(String seed, int w, int h) =>
    'https://picsum.photos/seed/$seed/$w/$h';

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Inception',
    year: 2010,
    rating: 8.8,
    genres: const ['Sci-Fi', 'Action', 'Thriller'],
    posterUrl: _img('inception', 600, 900),
    overview:
    'Một tên trộm chuyên đánh cắp bí mật từ giấc mơ nhận nhiệm vụ cuối cùng: '
        'cấy một ý tưởng vào tâm trí của một người thừa kế. Để làm được điều đó, '
        'anh và nhóm của mình phải đi sâu qua nhiều tầng giấc mơ, nơi mọi sai lầm '
        'đều có thể phải trả giá bằng cả tâm trí.',
    trailers: [
      Trailer(
          title: 'Official Trailer',
          duration: '2:28',
          thumbnailUrl: _img('inc-t1', 300, 170)),
      Trailer(
          title: 'Behind the Scenes',
          duration: '4:10',
          thumbnailUrl: _img('inc-t2', 300, 170)),
    ],
  ),
  Movie(
    id: 2,
    title: 'Interstellar',
    year: 2014,
    rating: 8.7,
    genres: const ['Sci-Fi', 'Drama', 'Adventure'],
    posterUrl: _img('interstellar', 600, 900),
    overview:
    'Khi Trái Đất dần cạn kiệt tài nguyên, một nhóm phi hành gia đi qua lỗ sâu '
        'để tìm kiếm ngôi nhà mới cho nhân loại. Hành trình vượt thời gian và không '
        'gian đặt họ trước những lựa chọn khó khăn giữa sứ mệnh và gia đình.',
    trailers: [
      Trailer(
          title: 'Official Trailer',
          duration: '3:01',
          thumbnailUrl: _img('int-t1', 300, 170)),
      Trailer(
          title: 'Teaser',
          duration: '1:15',
          thumbnailUrl: _img('int-t2', 300, 170)),
      Trailer(
          title: 'Featurette',
          duration: '5:42',
          thumbnailUrl: _img('int-t3', 300, 170)),
    ],
  ),
  Movie(
    id: 3,
    title: 'The Dark Knight',
    year: 2008,
    rating: 9.0,
    genres: const ['Action', 'Crime', 'Drama'],
    posterUrl: _img('darkknight', 600, 900),
    overview:
    'Batman cùng Jim Gordon và Harvey Dent tìm cách triệt hạ tội phạm ở '
        'Gotham, nhưng một kẻ hỗn loạn mang tên Joker xuất hiện và đẩy thành phố '
        'vào cuộc thử thách lớn nhất về đạo đức và lòng can đảm.',
    trailers: [
      Trailer(
          title: 'Official Trailer',
          duration: '2:32',
          thumbnailUrl: _img('dk-t1', 300, 170)),
    ],
  ),
  Movie(
    id: 4,
    title: 'Parasite',
    year: 2019,
    rating: 8.5,
    genres: const ['Thriller', 'Comedy', 'Drama'],
    posterUrl: _img('parasite', 600, 900),
    overview:
    'Gia đình nghèo Ki-taek lần lượt len lỏi vào cuộc sống của một gia đình '
        'giàu có. Mối quan hệ ký sinh tưởng chừng hoàn hảo dần trở nên khó '
        'kiểm soát với những biến cố bất ngờ.',
    trailers: [
      Trailer(
          title: 'Official Trailer',
          duration: '2:20',
          thumbnailUrl: _img('par-t1', 300, 170)),
      Trailer(
          title: 'Clip: The Plan',
          duration: '1:48',
          thumbnailUrl: _img('par-t2', 300, 170)),
    ],
  ),
];