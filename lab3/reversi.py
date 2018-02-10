import os
class state(object): #to maintain a global state of the game
	def __init__(self):
		self.board=[]
		self.player='O'
def display_board():
	print ' ',
	for c in range(8):
		print c,
	print 	
	r=0
	for i in gameState.board:
		print r,
		for j in i:
			print j,
		r+=1
		print
	print gameState.player+' to move'
	return
gameState=state();

def valid_move(x,y): #check if entered move by player is valid
	return gameState.board[x][y]=='-' and (check_north(x,y)[0] or check_south(x, y)[0] or check_east(x, y)[0] or check_west(x, y)[0] or check_north_east(x, y)[0] or check_north_west(x, y)[0] or check_south_east(x, y)[0] or check_south_west(x, y)[0])

def get_next_move():
	input_coord = raw_input().split()
	x_coord , y_coord = [int (val) for val in input_coord]
	return x_coord,y_coord


def check_north(x,y): #if matching piece in north direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if x==0: return (False,)
	if gameState.board[x-1][y]!=invert[gameState.player] : return (False,)
	i=2
	while(x-i>=0):
		if gameState.board[x-i][y]==gameState.player: return (True,(x-i,y))
		elif gameState.board[x-i][y]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)


def check_east(x,y): #if matching piece in north-east direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if y==7: return (False,)
	if gameState.board[x][y+1]!=invert[gameState.player] : return (False,)
	i=2
	while(y+i<=7):
		if gameState.board[x][y+i]==gameState.player: return (True,(x,y+i))
		elif gameState.board[x][y+i]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)

def check_west(x,y): #if matching piece in north-west direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if y==0: return (False,)
	if gameState.board[x][y-1]!=invert[gameState.player] : return (False,)
	i=2
	while(y-i>=0):
		if gameState.board[x][y-i]==gameState.player: return (True,(x,y-i))
		elif gameState.board[x][y-i]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)

def check_south(x,y): #if matching piece in south-east direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if x==7: return (False,)
	if gameState.board[x+1][y]!=invert[gameState.player] : return (False,)
	i=2
	while(x+i<=7):
		if gameState.board[x+i][y]==gameState.player: return (True,(x+i,y))
		elif gameState.board[x+i][y]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)



def check_north_east(x,y): #if matching piece in north-east direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if x==0 or y==7: return (False,)
	if gameState.board[x-1][y+1]!=invert[gameState.player] : return (False,)
	i=2
	while(x-i>=0 and y+i<=7):
		if gameState.board[x-i][y+i]==gameState.player: return (True,(x-i,y+i))
		elif gameState.board[x-i][y+i]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)
	

def check_north_west(x,y): #if matching piece in north-west direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if x==0 or y==0: return (False,)
	if gameState.board[x-1][y-1]!=invert[gameState.player] : return (False,)
	i=2
	while(x-i>=0 and y-i>=0):
		if gameState.board[x-i][y-i]==gameState.player: return (True,(x-i,y-i))
		elif gameState.board[x-i][y-i]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)

def check_south_east(x,y): #if matching piece in south-east direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if x==7 or y==7: return (False,)
	if gameState.board[x+1][y+1]!=invert[gameState.player] : return (False,)
	i=2
	while(x+i<=7 and y+i<=7):
		if gameState.board[x+i][y+i]==gameState.player: return (True,(x+i,y+i))
		elif gameState.board[x+i][y+i]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)

def check_south_west(x,y): #if matching piece in south-east direction (with opponent's pieces in between), 
							#return (True,Coordinate of matching piece), else return (False)
	invert={'O':'X','X':'O'}
	if x==7 or y==0: return (False,)
	if gameState.board[x+1][y-1]!=invert[gameState.player] : return (False,)
	i=2
	while(x+i<=7 and y-i>=0):
		if gameState.board[x+i][y-i]==gameState.player: return (True,(x+i,y-i))
		elif gameState.board[x+i][y-i]!=invert[gameState.player]: return (False,)
		i+=1
	return (False,)

def update_board(x,y):
	next=check_west(x,y)	
	if next[0]:	#if matching piece found in west direction
		targetY=next[1][1]
		i=y
		while(i>=targetY):
			gameState.board[x][i]=gameState.player
			i-=1
	
	next=check_east(x,y)	
	if next[0]:	#if matching piece found in east direction
		targetY=next[1][1]
		i=y
		while(i<=targetY):
			gameState.board[x][i]=gameState.player
			i+=1
	
	next=check_north(x,y)
	if next[0]:	#if matching piece found in north direction
		targetX=next[1][0]
		i=x
		while(i>=targetX):
			gameState.board[i][y]=gameState.player
			i-=1
	
	next=check_south(x,y)
	if next[0]:	#if matching piece found in south direction
		targetX=next[1][0]
		i=x
		while(i<=targetX):
			gameState.board[i][y]=gameState.player
			i+=1
	
	next=check_north_east(x,y)
	if next[0]:	#if matching piece found in north-east direction
		targetX=next[1][0]
		i=x
		j=y
		while(i>=targetX):
			gameState.board[i][j]=gameState.player
			i-=1
			j+=1

	next=check_north_west(x,y)
	if next[0]:	#if matching piece found in north-west direction
		targetX=next[1][0]
		i=x
		j=y
		while(i>=targetX):
			gameState.board[i][j]=gameState.player
			i-=1
			j-=1
		
	next=check_south_east(x,y)
	if next[0]:	#if matching piece found in south-east direction
		targetX=next[1][0]
		i=x
		j=y
		while(i<=targetX):
			gameState.board[i][j]=gameState.player
			i+=1
			j+=1

	next=check_south_west(x,y)
	if next[0]:	#if matching piece found in south-west direction
		targetX=next[1][0]
		i=x
		j=y
		while(i<=targetX):
			gameState.board[i][j]=gameState.player
			i+=1
			j-=1

	return

		

def main():
	global gameState
	invert={'O':'X','X':'O'}
	for i in range(8):
		if i==3:
			gameState.board.append(['-','-','-','O','X','-','-','-'])
		elif i==4:
			gameState.board.append(['-','-','-','X','O','-','-','-'])
		else:
			gameState.board.append(['-','-','-','-','-','-','-','-'])
	while(True):
		display_board()
		move=get_next_move()
		if move[0]==-1: #Pass
			gameState.player=invert[gameState.player]
		elif valid_move(move[0],move[1]):
			update_board(move[0],move[1])
			print "CORRECT"
			gameState.player=invert[gameState.player]
		else:
			print "INVALID MOVE"
	return



if __name__=='__main__':
	main()
