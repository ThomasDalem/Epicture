class CommentsData {
  final List<CommentAndAuthor> data;

  CommentsData({this.data});

  factory CommentsData.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List;
    List<CommentAndAuthor> commentList = list.map((e) => CommentAndAuthor.fromJson(e)).toList();
    return CommentsData(data: commentList);
  }
}

class CommentAndAuthor {
  final String comment;
  final String author;

  CommentAndAuthor({
    this.comment,
    this.author,
  });

  factory CommentAndAuthor.fromJson(Map<String, dynamic> json) {
    return CommentAndAuthor(
      comment: json['comment'] as String,
      author: json['author'] as String,
    );
  }
}