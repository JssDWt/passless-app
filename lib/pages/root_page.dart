import 'package:flutter/material.dart';
import 'package:passless_android/widgets/receipt_inherited.dart';
import 'package:passless_android/widgets/receipt_listview.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootIW = ReceiptInheritedWidget.of(context);
    // //Goto Now Playing Page
    // void goToNowPlaying(Song s, {bool nowPlayTap: false}) {
    //   Navigator.push(
    //       context,
    //       new MaterialPageRoute(
    //           builder: (context) => new NowPlaying(
    //                 rootIW.songData,
    //                 s,
    //                 nowPlayTap: nowPlayTap,
    //               )));
    // }

    //Shuffle Songs and goto now playing page
    // void shuffleSongs() {
    //   goToNowPlaying(rootIW.songData.randomSong);
    // }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Passless receipts"),
        // actions: <Widget>[
        //   new Container(
        //     padding: const EdgeInsets.all(20.0),
        //     child: new Center(
        //       child: new InkWell(
        //           child: new Text("Now Playing"),
        //           onTap: () => goToNowPlaying(
        //                 rootIW.songData.songs[
        //                     (rootIW.songData.currentIndex == null ||
        //                             rootIW.songData.currentIndex < 0)
        //                         ? 0
        //                         : rootIW.songData.currentIndex],
        //                 nowPlayTap: true,
        //               )),
        //     ),
        //   )
        // ],
      ),
      // drawer: new MPDrawer(),
      body: rootIW.isLoading
          ? new Center(child: new CircularProgressIndicator())
          : new Scrollbar(child: new ReceiptListView()),
      // floatingActionButton: new FloatingActionButton(
      //     child: new Icon(Icons.shuffle), onPressed: () => shuffleSongs()),
    );
  }
}
