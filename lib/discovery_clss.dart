class Discoveryitems {
  final String imageUrl;
  final String name;
  final String rate;
  bool isLiked;
  Discoveryitems(
      {required this.imageUrl,
      required this.name,
      required this.rate,
      this.isLiked = false});
  void clickliked() {
    isLiked = !isLiked;
  }
}
