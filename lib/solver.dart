import 'package:SudokuSolver/main.dart';

class sudokuSolver {
  int len = 9;
  var newsudoku = List.generate(9, (i) => List.generate(9,(j) => 0), growable: false);

  void Solver(sudoku)  {
    for (int r = 0; r < len; r++) {
      for (int c = 0; c < len; c++) {
        if (sudoku[r][c] != null) {
          newsudoku[r][c] = sudoku[r][c];
        }
      }
    }
    //print(rowdigits);
    //print(columndigits);

    solve();
    print(newsudoku);
  }

  bool checkRow(r,n){
    for(int i  = 0;i<len;i++){
      if(newsudoku[r][i]==n)return false;
    }
    return true;
  }
  bool checkCol(c,n){
    for(int i  = 0;i<len;i++){
      if(newsudoku[i][c]==n)return false;
    }
    return true;
  }
  int getRange(x){
    if (x <= 2) return 0;
    else if (x <= 5) return 3;
    else return 6;
  }
  bool checkGrid(int curr_row,int curr_col,int n){
    int row_range = getRange(curr_row);
    int col_range = getRange(curr_col);

    for(int i = row_range;i<row_range+3;i++){
      for(int j = col_range;j<col_range+3;j++){
          if(n == newsudoku[i][j]){
            return false;
          }
      }
    }

    return true;
  }
  List<int> loc = [0, 0];
  bool emptyPlace(){
    for(int i = 0;i<len;i++){
      for(int j=0;j<len;j++){
        if(newsudoku[i][j] == 0 ){
          loc[0] = i;
          loc[1] = j;
          return true;
        }
      }
    }
    return false;
  }
  bool safe(int r,int c,int n){

    return checkCol(c, n) &&
    checkGrid(r, c, n) &&
    checkRow(r, n) &&
    newsudoku[r][c] == 0;

  }
  bool solve() {
        loc = [0,0];
        if(!emptyPlace()){
          return true;
        }
        int r,c;
        r = loc[0];
        c = loc[1];
        for(int n = 1;n<=len;n++){
          if(safe(r, c, n)){
            newsudoku[r][c] = n;
            if(solve()) return true;
            newsudoku[r][c] = 0;
          }
        }

        return false;
  }
}
