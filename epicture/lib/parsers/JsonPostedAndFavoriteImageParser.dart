import 'dart:convert';

class PostedAndFavoriteImageData {
  final List<PostedAndFavoriteImage> data;

  PostedAndFavoriteImageData({this.data});

  factory PostedAndFavoriteImageData.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List;
    List<PostedAndFavoriteImage> imagesList = list.map((e) => PostedAndFavoriteImage.fromJson(e)).toList();
    return PostedAndFavoriteImageData(data: imagesList);
  }
}

class PostedAndFavoriteImage {
  final String url;
  final String title;
  final bool isAnimated;

  PostedAndFavoriteImage({this.url, this.isAnimated, this.title});

  factory PostedAndFavoriteImage.fromJson(Map<String, dynamic> json) {
    return PostedAndFavoriteImage(
      url: json['link'] as String,
      title: json['title'] as String,
      isAnimated: json['animated'] as bool);
  }
}

PostedAndFavoriteImageData parsePostedAndFavoriteImageData(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return (new PostedAndFavoriteImageData.fromJson(parsed));
}
