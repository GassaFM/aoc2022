import std;

long from5 (string s)
{
	long cur = 0;
	long p = 1;
	foreach (ref c; s)
	{
		cur *= 5;
		cur += "=-012".countUntil (c).to !(int) - 2;
		p *= 5;
	}
	return cur;
}

string to5 (long x)
{
	int [] v;
	while (x > 0)
	{
		v ~= x % 5;
		x /= 5;
	}
	foreach (i; 0..v.length)
	{
		if (v[i] > 2)
		{
			v[i] -= 5;
			if (i + 1 >= v.length)
			{
				v ~= 0;
			}
			v[i + 1] += 1;
		}
	}
	string s;
	foreach (ref y; v)
	{
		s ~= "=-012"[y + 2];
	}
	return s.retro.text;
}

void main ()
{
	long [] a;
	foreach (s; stdin.byLineCopy ())
	{
		a ~= from5 (s);
	}

	long res = a.sum;
	writeln (to5 (res));
}
