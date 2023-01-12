class Movie {
  Movie({
    required this.id,
    required this.name,
    required this.image,
  });
  final String name, image;
  final int id;

  factory Movie.fromJson({
    required int id,
    required String name,
    required String image,
  }) {
    return Movie(
      id: id,
      name: name,
      image: image,
    );
  }
}
