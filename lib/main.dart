import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle/puzzle_piece.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Puzzle Game',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final int rows = 3;
  final int cols = 3;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  List<Widget> pieces = [];
  List<Widget> piecesCompleted = [];
  bool started = false;
  bool done = false;

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
        pieces.clear();
      });
      if (started) {
        splitImage(Image.file(image));
      }
    }
  }

  Future<Size> getImagesSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    ));

    final Size imageSize = await completer.future;
    return imageSize;
  }

  void splitImage(Image image) async {
    Size imageSize = await getImagesSize(image);

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        setState(() {
          pieces.add(PuzzlePiece(
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols,
              bringToTop: this.bringToTop,
              sendToBack: this.sendToBack));
        });
      }
    }
  }

  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
      piecesCompleted.add(widget);
      done = piecesCompleted.length != pieces.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: Center(
        child: _image == null
            ? Text('Nenhuma imagem aberta')
            : started || done
                ? Stack(
                    children: pieces,
                  )
                : Image.file(_image),
      )),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Opacity(
            opacity: _image != null ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: FloatingActionButton(
                onPressed: () {
                  if (started) {
                    pieces.clear();
                    piecesCompleted.clear();
                    started = false;
                  } else {
                    pieces.clear();
                    started = true;
                  }
                  done = false;
                  splitImage(Image.file(_image));
                },
                mini: true,
                backgroundColor: Colors.yellow,
                child: Icon(
                  started ? Icons.sync : Icons.shuffle,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.camera),
                            title: Text('Câmera'),
                            onTap: () {
                              getImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Galeria'),
                            onTap: () {
                              getImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )));
            },
            tooltip: 'Nova imagem',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
