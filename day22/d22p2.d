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

	immutable int faces = 6;
	alias Face = Tuple !(int, q{sRow}, int, q{sCol},
	    int [4], q{dest}, int [4], q{rot});
	auto face = new Face [faces];
	face[0] = Face (  0,  50, [5, 3, 2, 1], [3, 2, 0, 0]);
	face[1] = Face (  0, 100, [5, 0, 2, 4], [0, 0, 3, 2]);
	face[2] = Face ( 50,  50, [0, 3, 4, 1], [0, 1, 0, 1]);
	face[3] = Face (100,   0, [2, 0, 5, 4], [3, 2, 0, 0]);
	face[4] = Face (100,  50, [2, 3, 5, 1], [0, 0, 3, 2]);
	face[5] = Face (150,   0, [3, 0, 1, 4], [0, 1, 0, 1]);
	immutable int size = 50;

	void rotateCCW90 (ref int row, ref int col, const int times)
	{
		foreach (i; 0..times)
		{
			int nRow = size - col - 1;
			int nCol = row;
			row = nRow;
			col = nCol;
		}
	}

	void jump (const int row, const int col, const int dir,
	    ref int nRow, ref int nCol, ref int nDir)
	{
		nRow = (nRow + size) % size;
		nCol = (nCol + size) % size;
		auto f = face.countUntil !(p =>
		    p.sRow / size == row / size &&
		    p.sCol / size == col / size).to !(int);
		rotateCCW90 (nRow, nCol, face[f].rot[dir]);
		nDir = (dir + face[f].rot[dir] + dirs) % dirs;
		auto g = face[f].dest[dir];
		nRow += face[g].sRow;
		nCol += face[g].sCol;
	}

	void step (const int row, const int col, const int dir,
	    ref int nRow, ref int nCol, ref int nDir)
	{
		nRow = row + dRow[dir];
		nCol = col + dCol[dir];
		nDir = dir;
		if (nRow < 0 || rows <= nRow ||
		    nCol < 0 || cols <= nCol ||
		    board[nRow][nCol] == ' ')
		{
			jump (row, col, dir, nRow, nCol, nDir);
		}
	}

	foreach (row; 0..rows)
	{
		foreach (col; 0..cols)
		{
			if (board[row][col] == ' ')
			{
				continue;
			}
			foreach (dir; 0..dirs)
			{
				int nRow, kRow;
				int nCol, kCol;
				int nDir, kDir;
				step (row, col, dir, nRow, nCol, nDir);
				if (board[nRow][nCol] == '#')
				{
					continue;
				}
				nDir ^= 2;
				step (nRow, nCol, nDir, kRow, kCol, kDir);
				kDir ^= 2;
				if (kRow != row || kCol != col || kDir != dir)
				{
					writeln (row, " ", col, " ", dir);
					writeln (nRow, " ", nCol, " ", nDir);
					writeln (kRow, " ", kCol, " ", kDir);
					assert (false);
				}
			}
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
				int nRow;
				int nCol;
				int nDir;
				step (row, col, dir, nRow, nCol, nDir);
				writeln ("to ", nRow, " ", nCol, " ", nDir);
				if (board[nRow][nCol] == '#')
				{
					break;
				}
				row = nRow;
				col = nCol;
				dir = nDir;
				assert (board[row][col] != ' ');
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
