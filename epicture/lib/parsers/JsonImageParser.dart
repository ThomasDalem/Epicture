import 'dart:convert';

class Data {
  final List<ImageData> data;

  Data({this.data});

  factory Data.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List;
    List<ImageData> imagesList =
        list.map((e) => ImageData.fromJson(e)).toList();
    return Data(data: imagesList);
  }
}

class ImageData {
  final String accountUsername;
  final String title;
  final List<MyImage> imagesInfos;
  final int upVotes;
  final int downVotes;
  final int imagesNbr;
  final String id;
  final String link;
  final bool isAlbum;
  final String type;
  final String mp4;
  String vote;

  ImageData({
    this.accountUsername,
    this.title,
    this.imagesInfos,
    this.upVotes,
    this.downVotes,
    this.imagesNbr,
    this.id,
    this.link,
    this.isAlbum,
    this.type,
    this.mp4,
    this.vote,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    final list = json['images'] as List;
    List<MyImage> myImages;

    if (list != null && list.length > 0) {
      myImages = list.map((e) => MyImage.fromJson(e)).toList();
    }
    return ImageData(
      accountUsername: json['account_url'] as String,
      title: json['title'] as String,
      downVotes: json['downs'] as int,
      upVotes: json['ups'] as int,
      imagesNbr: json['images_count'] as int,
      id: json['id'] as String,
      link: json['link'] as String,
      type: json['type'] as String,
      mp4: json['mp4'] as String,
      vote: json['vote'] as String,
      imagesInfos: myImages,
    );
  }
}

class ImageList {
  List<MyImage> images;

  ImageList({this.images});

  factory ImageList.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List;
    List<MyImage> myImages;

    if (list != null && list.length > 0) {
      myImages = list.map((e) => MyImage.fromJson(e)).toList();
    }
    return ImageList(images: myImages);
  }
}

class MyImage {
  final String url;
  final bool isAnimated;
  bool isFavorite;
  final String id;
  final String type;
  final String mp4;

  MyImage({
    this.url,
    this.isAnimated,
    this.isFavorite,
    this.id,
    this.type,
    this.mp4,
  });

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      url: json['link'] as String,
      isAnimated: json['animated'] as bool,
      isFavorite: json['favorite'] as bool,
      id: json['id'] as String,
      type: json['type'] as String,
      mp4: json['mp4'] as String,
    );
  }
}

Data parseData(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return (new Data.fromJson(parsed));
}
