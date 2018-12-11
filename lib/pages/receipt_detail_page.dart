import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/delete_dialog.dart';
import 'package:passless_android/widgets/semi_divider.dart';
import 'package:rxdart/rxdart.dart';

/// A page that shows receipt details.
class ReceiptDetailPage extends StatefulWidget {
  final Receipt _receipt;
  final String _title;
  ReceiptDetailPage(this._receipt, this._title);

  @override
  State<StatefulWidget> createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends State<ReceiptDetailPage> {
  @override
  Widget build(BuildContext context) {   
    return Hero(
      tag: "receipt${widget._receipt.id}",
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget._title),
          centerTitle: true,
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.note), 
            //   tooltip: "Notes",
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => 
            //           // TODO: Focus on comments.
            //           ReceiptDetailPage(
            //             widget._receipt, 
            //             widget._receipt.vendor.name)
            //       )
            //     );
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.delete), 
              tooltip: "Delete",
              onPressed: () async {
                bool shouldDelete = await DeleteDialog.show(context, 1);

                if (shouldDelete) {
                  await Repository.of(context).delete(widget._receipt);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Card(
                child: Column(
                  children: <Widget>[
                    _VendorContainer(widget._receipt),
                    SemiDivider(),
                    _ItemsContainer(widget._receipt),
                    SemiDivider(),
                    _TotalContainer(widget._receipt),
                    _CommentContainer(widget._receipt)
                  ],
                )
              )
            )
          )
        ),
      )
    );
  }
}

class _VendorContainer extends StatelessWidget {
  final Receipt _receipt;
  _VendorContainer(this._receipt);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(_receipt.vendor.name),
        Text(_receipt.vendor.address),
        Text(_receipt.vendor.telNumber),
      ]
    );
  }
}

class _ItemsContainer extends StatelessWidget {
  final Receipt _receipt;
  _ItemsContainer(this._receipt);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _receipt.items.map((i) => Text("${i.quantity}")).toList(),
        ),
        Container(
          padding: EdgeInsets.only(left: 1),
          child: Column(
            children: _receipt.items.map((i) {
              String text;
              if (i.unit.toLowerCase() == "pc") {
                text = "";
              }
              else {
                text = i.unit;
              }

              return Text(text);
            }).toList(),
          )
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 8),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _receipt.items.map((i) => Text(i.name)).toList(),
            )
          )
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _receipt.items.map((i) => Text("${i.subTotal}")).toList(),
        ),
      ]
    );
  }
}

class _TotalContainer extends StatelessWidget {
  final Receipt _receipt;
  _TotalContainer(this._receipt);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text("Total", style: theme.textTheme.headline,)
            ),
            Text(
              "${_receipt.currency} ${_receipt.total}", 
              style: theme.textTheme.headline,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text("Tax")
            ),
            Text("${_receipt.currency} ${_receipt.tax}"),
          ],
        ),
      ]
      
    );
  }
}

class _CommentContainer extends StatefulWidget {
  final Receipt _receipt;
  _CommentContainer(this._receipt);
  @override
  _CommentContainerState createState() => _CommentContainerState();
}

class _CommentContainerState extends State<_CommentContainer> {
  Repository _repository;
  BehaviorSubject<String> _commentSubject;
  TextEditingController _controller;
  bool _isLoading = true;
  bool _isEditing = false;
  String comments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initState();
  }

  Future _initState() async {
    _repository = Repository.of(context);
    comments = await _repository.getComments(widget._receipt);
    _controller = TextEditingController(text: comments);
    
    _commentSubject = BehaviorSubject<String>();
    _commentSubject.debounce(Duration(milliseconds: 750))
      .listen((c) => _repository.updateComments(widget._receipt, c));
    _controller.addListener(() => _commentSubject.add(_controller.text));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_commentSubject != null) {
      _commentSubject.close();
      _commentSubject = null;
    }

    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }

    _repository = null;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> actions;
    Widget noteField;
    if (_isEditing) {
      noteField = TextField(
        autofocus: true,
        controller: _controller,
      );
      actions = [
        IconButton(
          icon: Icon(Icons.save),
          tooltip: "Save notes",
          onPressed: () {
            // NOTE: The comments are saved automagically.
            setState(() {
              comments = _controller.text;
              _isEditing = false;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.clear),
          tooltip: "Cancel edit",
          onPressed: () {
            setState(() {
              _controller.text = comments;
              _isEditing = false;
            });
          },
        ),
      ];
    }
    else if (comments == null || comments.isEmpty) {
      noteField = Text("");
      actions = [
        IconButton(
          icon: Icon(Icons.note_add,),
          tooltip: "Add notes",
          onPressed: () {
            setState(() => _isEditing = true);
          },
        )
      ];
    }
    else {
      noteField = Text(comments, softWrap: true);
      actions = [
        IconButton(
          icon: Icon(Icons.edit),
          tooltip: "Edit notes",
          onPressed: () {
            setState(() => _isEditing = true);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: "Delete notes",
          onPressed: () {
            setState(() {
              _controller.text = "";
              comments = null;    
              _isEditing = false; 
            });
          },
        ),
      ];
    }

    return Column(
      children: <Widget>[
        SemiDivider(),
        Row(
          children: <Widget>[
            Expanded(
              child: Text("Notes", style: Theme.of(context).textTheme.subhead),
            ),
            Row(
              children: actions,
            )
          ],
        ),
        noteField
      ],
    );
  }
}

