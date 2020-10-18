import 'dart:convert';

class PostedImageData {
  final List<PostedImage> data;

  PostedImageData({this.data});

  factory PostedImageData.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List;
    List<PostedImage> imagesList = list.map((e) => PostedImage.fromJson(e)).toList();
    return PostedImageData(data: imagesList);
  }
}

class PostedImage {
  final String url;
  final String title;
  final bool isAnimated;

  PostedImage({this.url, this.isAnimated, this.title});

  factory PostedImage.fromJson(Map<String, dynamic> json) {
    return PostedImage(
      url: json['link'] as String,
      title: json['title'] as String,
      isAnimated: json['animated'] as bool);
  }
}

PostedImageData parsePostedImageData(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return (new PostedImageData.fromJson(parsed));
}
