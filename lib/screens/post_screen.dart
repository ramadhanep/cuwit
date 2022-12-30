import 'package:cuwit/constant.dart';
import 'package:cuwit/models/api_response.dart';
import 'package:cuwit/models/post.dart';
import 'package:cuwit/screens/comment_screen.dart';
import 'package:cuwit/screens/post_form.dart';
import 'package:cuwit/screens/welcome.dart';
import 'package:cuwit/services/post_service.dart';
import 'package:cuwit/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }))
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }))
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // post like dislik
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }))
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrievePosts();
            },
            child: ListView.builder(
                itemCount: _postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _postList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: new BoxDecoration(
                                      color: ThemeColorOverlay,
                                      borderRadius: new BorderRadius.all(Radius.circular(100.0))
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${post.user!.name!.substring(0,2)!.toUpperCase()}', style: ThemeStyleFontAvatar)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${post.user!.name}',
                                        style: ThemeStyleFontCardTitle,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        '|',
                                        style: ThemeStyleFontParagraphDisable,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        '${post.updatedAt}',
                                        style: ThemeStyleFontParagraphDisable,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            post.user!.id == userId
                                ? PopupMenuButton(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          FontAwesomeIcons.ellipsisVertical,
                                          color: ThemeColorBlack,
                                          size: 18.0,
                                        )),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: Text('Edit',
                                              style: ThemeStyleFontCardOption),
                                          value: 'edit'),
                                      PopupMenuItem(
                                          child: Text('Hapus',
                                              style: ThemeStyleFontCardOption),
                                          value: 'delete')
                                    ],
                                    onSelected: (val) {
                                      if (val == 'edit') {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => PostForm(
                                                      title: 'Edit Cuwit',
                                                      post: post,
                                                    )));
                                      } else {
                                        _handleDeletePost(post.id ?? 0);
                                      }
                                    },
                                  )
                                : SizedBox()
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(60.5, 0, 15.0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${post.body}',
                                  style: ThemeStyleFontParagraph),
                              post.image != null
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200.0,
                                      margin: EdgeInsets.only(top: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage('${post.image}'),
                                              fit: BoxFit.cover)),
                                    )
                                  : SizedBox(height: 10.0),
                              Row(
                                children: [
                                  kLikeAndComment(
                                      post.likesCount ?? 0,
                                      post.selfLiked == true
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      post.selfLiked == true
                                          ? ThemeColorRed
                                          : ThemeColorBlack, () {
                                    _handlePostLikeDislike(post.id ?? 0);
                                  }),
                                  SizedBox(width: 30.0),
                                  kLikeAndComment(
                                      post.commentsCount ?? 0,
                                      FontAwesomeIcons.comment,
                                      ThemeColorBlack, () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                                  postId: post.id,
                                                )));
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.5,
                          color: ThemeColorOverlay,
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}
