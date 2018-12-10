import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';

class CommentPage extends StatefulWidget {
  final Receipt _receipt;
  CommentPage(this._receipt);

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  TextEditingController _controller;
  bool _isLoading = true;
  bool _isEditing = false;
  String comments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchComments();
  }

  Future _fetchComments() async {
    comments = await Repository.of(context).getComments(widget._receipt);
    _controller = TextEditingController(text: comments);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        actions: <Widget>[
          _isEditing ? 
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _controller.text = comments;
                  _isEditing = false; 
                });
              },
            ) :
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;  
                });
              },
            )
        ],
      ),
      body: _isLoading ? 
        Center(child: CircularProgressIndicator()) :
        _isEditing ? TextField(
          autofocus: true,
          controller: _controller,
        ) :
        Text(comments ?? "")
    );
  }
}