import 'package:cuwit/models/api_response.dart';
import 'package:cuwit/models/comment.dart';
import 'package:cuwit/screens/welcome.dart';
import 'package:cuwit/services/comment_service.dart';
import 'package:cuwit/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:cuwit/constant.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;

  CommentScreen({this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  TextEditingController _txtCommentController = TextEditingController();

  // Get comments
  Future<void> _getComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);

    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // create comment
  void _createComment() async {
    ApiResponse response =
        await createComment(widget.postId ?? 0, _txtCommentController.text);

    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }))
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // edit comment
  void _editComment() async {
    ApiResponse response =
        await editComment(_editCommentId, _txtCommentController.text);

    if (response.error == null) {
      _editCommentId = 0;
      _txtCommentController.clear();
      _getComments();
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

  // Delete comment
  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComment(commentId);

    if (response.error == null) {
      _getComments();
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
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 24,
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: ThemeColorBlack,
            size: 20.0,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Komentar',
          style: ThemeStyleFontHeader,
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () {
                        return _getComments();
                      },
                      child: ListView.builder(
                          itemCount: _commentsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Comment comment = _commentsList[index];
                            return Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: ThemeColorOverlay, width: 0.5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
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
                                                Text('${comment.user!.name!.substring(0,2)!.toUpperCase()}', style: ThemeStyleFontAvatar)
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${comment.user!.name}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                      comment.user!.id == userId
                                          ? PopupMenuButton(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.black,
                                                  )),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    child: Text('Edit'),
                                                    value: 'edit'),
                                                PopupMenuItem(
                                                    child: Text('Delete'),
                                                    value: 'delete')
                                              ],
                                              onSelected: (val) {
                                                if (val == 'edit') {
                                                  setState(() {
                                                    _editCommentId =
                                                        comment.id ?? 0;
                                                    _txtCommentController.text =
                                                        comment.comment ?? '';
                                                  });
                                                } else {
                                                  _deleteComment(
                                                      comment.id ?? 0);
                                                }
                                              },
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('${comment.comment}')
                                ],
                              ),
                            );
                          }))),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: ThemeColorOverlay, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: kInputDecoration('Komentar'),
                        controller: _txtCommentController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_txtCommentController.text.isNotEmpty) {
                          setState(() {
                            _loading = true;
                          });
                          if (_editCommentId > 0) {
                            _editComment();
                          } else {
                            _createComment();
                          }
                        }
                      },
                    )
                  ],
                ),
              )
            ]),
    );
  }
}
