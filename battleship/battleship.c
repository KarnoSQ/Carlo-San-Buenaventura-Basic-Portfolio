/*
Title: A Game of BattleShip 
Description: 
A very simple and unintuitive game of battleship made for CCDSTRU during my first year. 
This display a simple logic on how battleship games work. Specs were made with regards
to CCDSTRU specs.

Game Design: Carlo San Buenaventura

*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ROWS 3
#define COLS 3
// used for reference sake

/*
function: draw_board = draws board to be visualized
parameters:
    board = board to be visualized for reference
*/
void draw_board(char board[3][3]){
	printf("\n");
    printf("\n-----------");
    for(int i=0;i<COLS;i++){
        printf("\n %c | %c | %c ",board[i][0] +'0',board[i][1] +'0',board[i][2]+'0');
        printf("\n-----------"); // draw box
    }
        
}
/*
function: PlayTurn = Lets player play their turn
parameters:
    battle = battle board to be visualized for reference when player attacks opponent player
    board = opponent players board that contains the location of the ships
return:
    1 if player hit or missed and 0 if hit already used piece
*/
int playTurn(char battle[3][3],char board[3][3],char player){
    int result;
    do
    {
        printf("\nSelect a Move where you would like to play Player %c: ", player);
        scanf("%d",&result);
    } while (!(result >=0 && result <= 8));
    int row = result / 3;
    int col = result % 3;
    if (battle[row][col] == 'H' || battle[row][col] == 'M'){
        printf("\n Cant place there. ");
         return 0;  
    }
    else if(board[row][col]=='M' || board[row][col]== 'K'){
        battle[row][col] = 'H';
        printf("A Hit");
        return 1;
    }
    else{
        battle[row][col] = 'k';
        printf("A Miss");
        return 1;
    }
}
int gameover(char board[3][3],char player){
    for(int i=0;i<ROWS;i++){
        if(board[i][0] == 'H' && board[i][1] == 'H' && board[i][2] == 'H'){
            return player;
        }
        else if(board[0][i] == 'H' && board[1][i] == 'H' && board[2][i] == 'H'){
            return player;
        }
    }
    return 0;
}
/*
function: rowShipBuilder = builds the a row ship in the board
parameters:
    board = board to be visualized for reference
    playerPiece = player piece to be used for building the ship
    Position = row position of row ship
return:
    returns 1 if ship is built
*/
int rowShipBuilder(char player[3][3], char playerPiece,int Position){
    for(int i=0;i<ROWS;i++)
        player[i][Position] = playerPiece;
    return 1;
}
/*
function: columnShipBuilder = builds a column ship in the board
parameters:
    board = board to be visualized for reference
    playerPiece = player piece to be used for building the ship
    Position = column position of row ship
return:
    returns 1 if ship is built
*/
int columnShipBuilder(char player[3][3], char playerPiece,int Position){
    for(int i=0;i<COLS;i++)
        player[Position][i] = playerPiece;
    return 1;
}
/*
function: create_battleground = creates the battleground for the player to build their ship
parameters:
    player = board to be visualized for reference
    playerPiece = player piece to be used for building the ship
return:
    returns 1 if ship is built
*/
int create_battleground(char player[3][3],char playerPiece){
    printf("\n * \n * \n * = column major ship type 1 or * * * row major ship type 2");
    printf("\nSelect a ship:");
    int selectShip;
    int selectPlace;
    scanf("%d",&selectShip);
    if (selectShip == 1){
        printf("Out of 1-3 which row should it be placed in: ");
        scanf("%d",&selectPlace);
        rowShipBuilder(player,playerPiece,selectPlace-1);
        draw_board(player);
        printf("\nThis is your board press Y to continue: ");
        getchar();
        getchar();
        return 1;
    }
    else if (selectShip==2){
        printf("Out of 1-3 which column should it be placed in: ");
       scanf("%d",&selectPlace);
        columnShipBuilder(player,playerPiece,selectPlace-1);
        draw_board(player);
        printf("\nThis is your board press Y to continue: ");
        getchar();
        getchar(); //made so player can see board before being deleted
        return 1;
    }
    else{
        printf("Position not Selected");
        system("cls");
        return 0;
    }
}
int main(){

    // Initialize Variables
    char game_board[3][3] = {0,1,2,3,4,5,6,7,8};
    char player1 = 'M';
    char player2 = 'K';
    int stage = 1;
    int isPlaying = 1;
    int winner = 0;
    int check;
    char board[3][3] = {0,1,2,3,4,5,6,7,8};
    char player1board[3][3] = {0,1,2,3,4,5,6,7,8};
    char player2board[3][3] = {0,1,2,3,4,5,6,7,8};
    char player1battle[3][3] = {0,1,2,3,4,5,6,7,8};
    char player2battle[3][3] = {0,1,2,3,4,5,6,7,8};

    printf("==Welcome to BattleShip=="); // Intialized ships
    printf("\n- Player 1 First\n");
        check = create_battleground(player1board,player1);
    system("cls");
    printf("\n- Player 2 Turn\n");
        check = create_battleground(player2board,player2);
    system("cls");
    //start game
    while(isPlaying){
        if(stage==1){
            draw_board(player1battle);
            do
            {
                check = playTurn(player1battle,player2board,player1); //player turn
            } while (!check);
            draw_board(player1battle);
            printf("\ntype anything to continue: ");
            winner = gameover(player1battle,player1);
            if(winner){
                isPlaying = 0;
            }
            else{
                stage = 2;
                getchar();
                getchar();
                system("cls");
        }
        }
        else{
            draw_board(player2battle);
                do
            {
                check = playTurn(player2battle,player1board,player2); //player 2 turn
            } while (!check);
            draw_board(player2battle);
            printf("\ntype anything to continue: ");
            winner = gameover(player2battle,player2);
            if(winner){
                isPlaying = 0;
            }
            else{
                stage = 1;
                getchar();
                getchar();
                system("cls");
            }
        }
    }
    printf("Player: %d IS WINNER",stage);
    
}
