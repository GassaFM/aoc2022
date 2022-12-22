import std;

immutable int dirs = 4;
immutable int  [dirs] dRow  = [ -1,   0,  +1,   0];
immutable int  [dirs] dCol  = [  0,  -1,   0,  +1];

void main ()
{
	auto board = stdin.byLineCopy ().array;
	auto commands = board[$ - 1];
	board = board[0..$ - 2];
	auto rows = board.length.to !(int);
	auto cols = board.map !(line => line.length).maxElement.to !(int);
	foreach (ref line; board)
	{
		while (line.length < cols)
		{
			line ~= ' ';
		}
	}

	auto row = 0;
	auto col = board.front.countUntil !(q{a != ' '}).to !(int);
	auto dir = 3;

	while (!commands.empty)
	{
		if (commands.front.isDigit)
		{
			int d = 0;
			while (!commands.empty && commands.front.isDigit)
			{
				d = d * 10 + commands.front.to !(int) - '0';
				commands.popFront ();
			}
			writeln ("move ", d);
			for ( ; d > 0; d--)
			{
				auto nRow = row + dRow[dir];
				auto nCol = col + dCol[dir];
				if (nRow < 0 ||
				    (dir == 0 && board[nRow][nCol] == ' '))
				{
					nRow = rows - 1;
					while (board[nRow][nCol] == ' ')
					{
						nRow -= 1;
					}
				}
				if (nRow >= rows ||
				    (dir == 2 && board[nRow][nCol] == ' '))
				{
					nRow = 0;
					while (board[nRow][nCol] == ' ')
					{
						nRow += 1;
					}
				}
				if (nCol < 0 ||
				    (dir == 1 && board[nRow][nCol] == ' '))
				{
					nCol = cols - 1;
					while (board[nRow][nCol] == ' ')
					{
						nCol -= 1;
					}
				}
				if (nCol >= cols ||
				    (dir == 3 && board[nRow][nCol] == ' '))
				{
					nCol = 0;
					while (board[nRow][nCol] == ' ')
					{
						nCol += 1;
					}
				}
				if (board[nRow][nCol] == '#')
				{
					break;
				}
				row = nRow;
				col = nCol;
			}
		}
		else
		{
			auto add = (commands.front == 'R') ? 3 : 1;
			commands.popFront ();
			dir = (dir + add) % dirs;
			writeln ("turn " , dir);
		}
	}

	int res = 0;
	res += 1000 * (row + 1);
	res += 4 * (col + 1);
	res += 1 * (3 - dir);
	writeln (row + 1, " ", col + 1, " ", 3 - dir);
	writeln (res);
}
