# -*- coding: utf-8 -*-
"""
Created on Tue Jan 19 22:31:22 2021

@author: Mohan
"""



def checkRow(curr_row,n):
    for i in range(0,length):
        if sudokuArray[curr_row][i] == n: 
            return False  
    #print('it is safe')
    return True

def checkCol(curr_col,n):
    for i in range(0,length):
        if sudokuArray[i][curr_col] == n: return False
    return True

def getRange(x):
    if x <= 2: return 0
    elif x <= 5: return 3
    else: return 6


def checkGrid(curr_row,curr_col,n):
    row_range = getRange(curr_row)
    col_range = getRange(curr_col)
    #print(row_range,col_range,sep=' ')
    for i in range(row_range,row_range+3):
        for j in range(col_range,col_range+3):
            if n==sudokuArray[i][j]: 
                #print('returning false')
                return False
    
    return True

def emptyPlace(loc):
    
    for i in range(0,9):
        for j in range(0,9):
            if sudokuArray[i][j]==0:
                loc[0] = i
                loc[1] = j
                return True
    return False


def safe(r,c,n):
    #print((checkGrid(r, c, n) and sudokuArray[r][c]==0 and checkRow(r,n) and checkCol(c,n) ))
    return (checkGrid(r, c, n) and sudokuArray[r][c]==0 and checkRow(r,n) and checkCol(c,n) )

def printSudoku():
    for i in range(0,9):
        for j in range(0,9):
            print(sudokuArray[i][j],end=' ')
        print()

def backtrack(): 
    loc = [0,0]
    if not emptyPlace(loc):
        return True
    
    row = loc[0]
    col = loc[1]
    
    for n in range(1,10):
        if(safe(row,col,n)):
            sudokuArray[row][col]=n
            #printSudoku()
            if backtrack():
                return True
            
            sudokuArray[row][col] = 0
            
    return False

length = 9
sudokuArray = [[0 for x in range(9)]for y in range(9)]
     
backtrack()
printSudoku()
            