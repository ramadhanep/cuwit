import 'user.dart';

class Post {
  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;
  String? updatedAt;

  Post({
    this.id,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
    this.updatedAt,
  });

// map json to post model

  factory Post.fromJson(Map<String, dynamic> json) {
    String convertToAgo(DateTime input){
      Duration diff = DateTime.now().difference(input);
      
      if(diff.inDays >= 1){
        return '${diff.inDays} hari';
      } else if(diff.inHours >= 1){
        return '${diff.inHours} jam';
      } else if(diff.inMinutes >= 1){
        return '${diff.inMinutes} menit';
      } else if (diff.inSeconds >= 1){
        return '${diff.inSeconds} detik';
      } else {
        return 'baru saja';
      }
    }
    DateTime updatedAtAgo = DateTime.parse(json['updated_at']);

    return Post(
        id: json['id'],
        body: json['body'],
        image: json['image'],
        likesCount: json['likes_count'],
        commentsCount: json['comments_count'],
        selfLiked: json['likes'].length > 0,
        updatedAt: convertToAgo(updatedAtAgo),
        user: User(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']));
  }
}
