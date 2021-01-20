import 'dart:convert';
import 'dart:io';
import 'package:SudokuSolver/solver.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'button.dart';

int row = 9, col = 9, selected_row, selected_col;
var selected_unit;

var sudoku = List.generate(row, (i) => List(col), growable: false);
SudokuGrid sudokuState;

void main() {
  selected_row = null;
  selected_col = null;
  selected_unit = null;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  File file;
  final url = Uri.parse("http://192.168.31.59:8888/");

  void _choose() async {
    PickedFile imgfile;
    imgfile = (await ImagePicker().getImage(source: ImageSource.camera));
    //imgfile = (await ImagePicker().getImage(source: ImageSource.gallery));

    file = File(imgfile.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BodyState();
  }
}

class BodyState extends State<Body> {
  File file;
  final url = Uri.parse("http://192.168.31.59:8888/");
  int len = 9;
  var newsudoku =
      List.generate(9, (i) => List.generate(9, (j) => 0), growable: false);

  // Backend Utils

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _upload(context) async {
    if (file == null) return;
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path,
          filename: basename(file.path)),
    });
    await dio
        .post(url.toString(),
            data: formData,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain // or ResponseType.JSON
                ))
        .then((dynamic response) {
      Map<String, dynamic> result = jsonDecode(response.toString());
      bool sudokufound =
          result['sudokufound'].toString().toLowerCase() == 'true';
      Navigator.of(context).pop();
      if (sudokufound) {
        int pointer = 0;
        List<dynamic> numberList = new List();
        numberList = result['sudoku'];
        int r, c;
        int len = 9;
        numberList.forEach((element) {
          r = (pointer / len).floor();
          c = pointer % len;
          sudoku[r][c] = element.toString() == '0' ? null : element;
          pointer += 1;
        });
        setState(() {});
      } else {
        Toast.show('Error! could not load sudoku', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((error) => print(error));
  }

  void _imgFromCamera(context) async {
    PickedFile imgfile;
    imgfile = (await ImagePicker().getImage(source: ImageSource.camera));
    //imgfile = (await ImagePicker().getImage(source: ImageSource.gallery));

    file = File(imgfile.path);
    showLoaderDialog(context);
    _upload(context);
    // setState(() {});
  }

  void _imgFromGallery(context) async {
    PickedFile imgfile;
    imgfile = (await ImagePicker().getImage(source: ImageSource.gallery));
    //imgfile = (await ImagePicker().getImage(source: ImageSource.gallery));

    file = File(imgfile.path);
    showLoaderDialog(context);
    _upload(context);
    // setState(() {});
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // SudokuSolver Utils

  bool Solver() {
    print('Solving');
    newsudoku =
        List.generate(9, (i) => List.generate(9, (j) => 0), growable: false);
    for (int r = 0; r < len; r++) {
      for (int c = 0; c < len; c++) {
        if (sudoku[r][c] != null) {
          newsudoku[r][c] = sudoku[r][c];
        }
      }
    }
    //print(rowdigits);
    //print(columndigits);

    bool res = solve();
    return res;
  }

  bool checkRow(r, n) {
    for (int i = 0; i < len; i++) {
      if (newsudoku[r][i] == n) return false;
    }
    return true;
  }

  bool checkCol(c, n) {
    for (int i = 0; i < len; i++) {
      if (newsudoku[i][c] == n) return false;
    }
    return true;
  }

  int getRange(x) {
    if (x <= 2)
      return 0;
    else if (x <= 5)
      return 3;
    else
      return 6;
  }

  bool checkGrid(int curr_row, int curr_col, int n) {
    int row_range = getRange(curr_row);
    int col_range = getRange(curr_col);

    for (int i = row_range; i < row_range + 3; i++) {
      for (int j = col_range; j < col_range + 3; j++) {
        if (n == newsudoku[i][j]) {
          return false;
        }
      }
    }

    return true;
  }

  List<int> loc = [0, 0];

  bool emptyPlace() {
    for (int i = 0; i < len; i++) {
      for (int j = 0; j < len; j++) {
        if (newsudoku[i][j] == 0) {
          loc[0] = i;
          loc[1] = j;
          return true;
        }
      }
    }
    return false;
  }

  bool safe(int r, int c, int n) {
    return checkCol(c, n) &&
        checkGrid(r, c, n) &&
        checkRow(r, n) &&
        newsudoku[r][c] == 0;
  }

  bool solve() {
    loc = [0, 0];
    if (!emptyPlace()) {
      return true;
    }
    int r, c;
    r = loc[0];
    c = loc[1];
    for (int n = 1; n <= len; n++) {
      if (safe(r, c, n)) {
        newsudoku[r][c] = n;
        if (solve()) return true;
        newsudoku[r][c] = 0;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sudoku Solver',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left:5,right:5),
                        child: InkWell(
                            onTap: () async {
                              _showPicker(context);

                              //_upload();

                              //Navigator.pop(context);
                            },
                            child: getImportButton(context))),
                    Container(
                       margin: EdgeInsets.only(left:5,right:5),
                        child: InkWell(
                            onTap: () {
                              if (Solver()) {
                                setState(() {
                                  sudoku = newsudoku;
                                });
                              } else {
                                print('false');
                                Toast.show(
                                  'Invalid Sudoku',
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                );
                              }
                            },
                            child: getSolverButton(context))),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5)
                      ),
                      child:Stack(
                        children: [
                          Sudoku(),
                          IgnorePointer(
                            child: SudokuLayout(),
                          ),
                        ],
                      ) ,
                    )
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Buttons(),
              ],
            ),
          ),
        ));
  }
}

class Sudoku extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SudokuGrid();
  }
}
class SudokuGrid extends State<Sudoku> {
  double outerwidth = 1.5, innerborderwidth = 1.5, cell_width = 0.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sudokuState = this;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double cardWidth = MediaQuery.of(context).size.width;
    double cardHeight = MediaQuery.of(context).size.height * 0.6;
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 2, right: 2),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemBuilder: _buildItem,
        itemCount: 81,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    int r, c;
    int len = 9;

    c = (index / len).floor();
    r = index % len;
    //print('Row = > {$r} Column => {$c}');
    return GestureDetector(
        onTap: () {
          selected_col = c;
          selected_row = r;
          setState(() {});
        },
        child: (selected_col == c && selected_row == r)
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(color: Colors.black, width: cell_width)),
                child: (sudoku[r][c] == null)
                    ? Text('')
                    : Center(
                        child: Text(
                        sudoku[r][c].toString(),
                        style: TextStyle(fontSize: 20),
                      )))
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: cell_width)),
                child: sudoku[r][c] == null
                    ? Text('')
                    : Center(
                        child: Text(sudoku[r][c].toString(),
                            style: TextStyle(fontSize: 20)))));
  }
}
class SudokuLayout extends StatelessWidget {
  double outerwidth = 1.5, innerborderwidth = 1.5, cell_width = 0.5;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.5),
            ),
          );
        },
        itemCount: 9,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}

class Buttons extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ButtonsState();
  }
}
class ButtonsState extends State<Buttons> {
  var buttonList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'X'];

  int getSelectedRange(int x) {
    if (x <= 2)
      return 0;
    else if (x <= 5)
      return 3;
    else
      return 6;
  }

  bool checkGrid() {
    int r = getSelectedRange(selected_row);
    int c = getSelectedRange(selected_col);
    print('Row => {$r} Col => {$c}');
    for (int i = r; i < r + 3; i++) {
      for (int j = c; j < c + 3; j++) {
        if (selected_row != i &&
            selected_col != j &&
            sudoku[i][j] == selected_unit) {
          return false;
        }
      }
    }

    return true;
  }

  bool checkPlacement() {
    for (int r = 0; r < row; r++) {
      if (selected_row != r && sudoku[r][selected_col] == selected_unit)
        return false;
    }

    for (int c = 0; c < col; c++) {
      if (selected_col != c && sudoku[selected_row][c] == selected_unit)
        return false;
    }

    return true;
  }

  getUnit(unit) {
    if (selected_col != null && selected_row != null) {
      sudokuState.setState(() {
        if (unit == 'X') {
          selected_unit = null;
        } else {
          var previous_unit = sudoku[selected_row][selected_col];
          selected_unit = int.parse(unit);
          if (!checkPlacement() || !checkGrid()) {
            print('{$selected_unit} => returning');
            selected_unit = previous_unit;
            // return;
          }
        }
        sudoku[selected_row][selected_col] = selected_unit;
        selected_col = null;
        selected_row = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 3),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return new Center(
            child: InkWell(
                onTap: () {
                  selected_unit = getUnit(buttonList[index]);
                },
                child: Ink(
                  height: 75,
                  width: 40,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2.5,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    buttonList[index],
                    style: TextStyle(fontSize: 20),
                  )),
                )),
          );
        },
        itemCount: buttonList.length,
      ),
    );
  }
}

