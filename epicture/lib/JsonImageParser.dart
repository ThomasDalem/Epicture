import 'dart:convert';

class Data {
  final List<ImageData> data;

  Data({this.data});

  factory Data.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List;
    List<ImageData> imagesList = list.map((e) => ImageData.fromJson(e)).toList();
    return Data(data: imagesList);
  }
}

class ImageData {
  final String accountUsername;
  final String title;
  final List<MyImage> imagesInfos;
  final int upVotes;
  final int downVotes;

  ImageData({this.accountUsername, this.title, this.imagesInfos, this.upVotes, this.downVotes});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    final list = json['images'] as List;
    List<MyImage> myImages = [];

    if (list != null && list.length > 0) {
      myImages = list.map((e) => MyImage.fromJson(e)).toList();
    }
    return ImageData(
        accountUsername: json['account_url'] as String,
        title: json['title'] as String,
        downVotes: json['downs'] as int,
        upVotes: json['ups'] as int,
        imagesInfos: myImages);
  }
}

class MyImage {
  final String url;
  final bool isAnimated;

  MyImage({this.url, this.isAnimated});

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(url: json['link'] as String, isAnimated: json['animated'] as bool);
  }
}

Data parseData(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return (new Data.fromJson(parsed));
}
