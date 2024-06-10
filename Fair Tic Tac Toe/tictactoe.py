import numpy
import math
#
# Title: Very Fair Tic Tac Toe
#
# Description:    
#               A very fair game of tic tac toe that utilizes the min max algorithm tht was learned during CSALGCM
# A fun project that I found  previously and researched in preperation for the coding exam.
# 
#   
# Game Design: Carlo San Buenaventura
# Algorithm base from : 
# https://www.geeksforgeeks.org/finding-optimal-move-in-tic-tac-toe-using-minimax-algorithm-in-game-theory/
# https://medium.com/chat-gpt-now-writes-all-my-articles/advanced-ai-alpha-beta-pruning-in-python-through-tic-tac-toe-70bb0b15db05
#
gameboard = numpy.array([[1,2,3],[4,5,6],[7,8,9]]) #intialization array
gameboard = numpy.array(gameboard).astype('str').tolist()
global stage 
global isPlaying
stage = 0
isPlaying = True
drawing_lines = "         ||         ||         "
# Draws board of the game
def DrawBoard(current_board):
    for i in range(numpy.size(current_board,0)):
        print(drawing_lines) #draw each sqaure with each numbered box
        print(f'    {current_board[i][0]}    ||    {current_board[i][1]}    ||    {current_board[i][2]}')
        print(drawing_lines)
        if i < numpy.size(current_board, 0) - 1:
            print("--------------------------------") # draw bottom line
# Initialize Game
def initGame():
    letter = ""
    while not (letter == 'X' or letter == 'O'): #pick which letter player wants to be
        letter = input("- Pick X or O? ").upper()
    
    global player
    global bot
    player = letter
    if player =="O": #if player is X then bot is O and vice versa
        bot = "X"
    else:
        bot = "O"
#player chooses where to play their piece 
def playTurn(player_piece,current_board):
    result = False
    while not result:
        num = input(f"Enter where you would like to play for {player_piece}: ")
        if num not in '0 1 2 3 4 5 6 7 8 9'.split():
            continue
        result = add_ToBox(int(num),player_piece,current_board) # will add to box on when empty aka True

# Count Num Empty               
def countNumEmpty(current_board):
    count = 0 
    for x in range(3):
        for y in range(3):
            if not(current_board[x][y] == player or current_board[x][y]== bot):
                count +=1
    return count
# Allows computer bot to play its turn
def ComputerTurn(current_board):
    global count
    count = 0
    index = miniMaxAB(current_board,0,-math.inf,math.inf,True)
    print(f"Cpu Searched for {count} and picked the optimal solution:")
    add_ToBox(index,bot,current_board)
    print(f"CPU Played an {bot} at {index}")
# Checks the nth empty box for min max purposes.
def add_ToEmpty(index, user,current_board):
    count = 0 
    for x in range(3):
        for y in range(3):
            if not(current_board[x][y] == player or current_board[x][y]== bot):
                if(count == index):
                    add_ToBox(3 * x + y + 1,user,current_board)
                    return 3 * x + y + 1
                count +=1
# Add piece to the box.
def add_ToBox(index,user,current_board):
    row = int((index - 1 )/3) # get current row number from index
    col = int(index - 1) % 3 # get current column number from index
    if current_board[row][col] == 'X' or current_board[row][col] == "0":
            return False
    else:
        current_board[row][col] = user #adding piece to array
        return True
# Intialize Start turns
def start_turns():
    global stage
    if(player == "X"): #user X goes first then O
        stage = 1
    else:
        stage = 2
def checkIfGameIsDone(current_board):
    for i in range(3):
        #check if there is a match of 3 within the horizontal rows
        if current_board[i][0] == current_board[i][1] == current_board[i][2]:
            return current_board[i][2]
        #check if there is a match of 3 within the vertical rows
        if current_board[0][i] == current_board[1][i] == current_board[2][i]:
            return current_board[2][i]

    #check for match of 3 within the diagonal rows
    if current_board[1][1] == current_board[0][0] and current_board[2][2] == current_board[1][1]:
        return current_board[1][1]
    if current_board[1][1] == current_board[0][2] and current_board[2][0] == current_board[1][1]:
        return current_board[1][1]

    #find if possible draw has happened
    for x in range(3):
        for y in range(3):
            if not(current_board[x][y] == player or current_board[x][y] == bot):
                return False # no draw or winner has been decided yet.

    return "NA"; #completed with a draw
def miniMaxAB(current_board,tree,alpha,beta,isMaximizer):
    global count #number of times ran
    winner = checkIfGameIsDone(current_board)
    if not winner == False:
        count += 1
        if winner == player:
            return -10 + tree
        elif winner == bot:
            return 10 - tree
        else:
            return 0
    if isMaximizer: 
        maxEval = -math.inf
        for i in range(countNumEmpty(current_board)):
            Copy = numpy.copy(current_board)
            index = add_ToEmpty(i, bot, Copy)
            eval = miniMaxAB(Copy,tree + 1,alpha, beta, False) # find max index
            if (eval > maxEval):
                maxEval = eval
                BestIndex = index
            alpha = max(alpha, eval) #alpha beta prunning for max
            if beta <= alpha:
                break
        if tree == 0:
            return BestIndex
        return maxEval
    else:
        minEval = math.inf
        for i in range(countNumEmpty(current_board)):
            Copy = numpy.copy(current_board)
            add_ToEmpty(i,player,Copy)
            eval = miniMaxAB(Copy, tree + 1 , alpha, beta, True) #find min index
            minEval = min(eval, minEval)
            beta = min(eval, beta) #alpha beta prunning for min
            if beta <= alpha:
                break
        return minEval

print("Welcome to Very Fair Game of Tic-Tac-Toe".center(50,"-"))
select = input("\nPress Y to Start: ").upper()
if select not in 'Y y'.split():
    quit()

initGame() #intialize game
while(isPlaying):
    if stage == 0:
        start_turns() #load player pieces
        DrawBoard(gameboard) # load early board
    elif stage == 1:
        playTurn(player,gameboard)
        DrawBoard(gameboard)
        winner = checkIfGameIsDone(gameboard) #check if player won (very unlikely)
        if not winner ==  False:
            isPlaying = False
        else:
            stage = 2  
    elif stage == 2:
        ComputerTurn(gameboard)
        DrawBoard(gameboard)
        winner = checkIfGameIsDone(gameboard) #check if bot won 
        if not winner == False:
            isPlaying = False
        else:
            stage = 1
print(f'{winner} is the winner!') # declare winner

