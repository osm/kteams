/*

QuakeWorld server nail hack
- allows Qizmo to compress nail data 3 times tighter
- in most cases uses less bandwidth even without Qizmo
- nails fly around smoother and point to the right direction
- sng and ng nails look different, like in regular Quake

For maximum effect set sv_mintic to 0.014 in qwsv console.
(sv_mintic controls how often qwsv updates non-player entities
(rockets, nails, everything else that moves). The default is 0.03,
which amounts to 33fps (1/0.03s). 0.014 (72fps) will get you updated
entities for every qwcl frame -> as smooth as regular Quake. Note
that upping the server fps also ups the cpu load.)

Usage: nailhack qwsvfilename

Should work on any qwsv executable.
Rerun to restore original.

Author: Juha Kujala <jmkujala@cc.jyu.fi>

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

void die(char *msg)
{
	if (errno) perror(msg);
	else printf("%s\n", msg);
	exit(-1);
}

int main(int argc, char **argv)
{
	FILE *f;
	char *buf;
	int	len, i, n = 2;
	if (argc != 2) die("Usage: nailhack qwsvfilename");
	f = fopen(argv[1], "r+b");
	if (!f) die(argv[1]);
	if (fseek(f, 0, SEEK_END)) die("fseek");
	len = ftell(f);
	if (len == -1L) die("ftell");
	buf = malloc(len);
	if (!buf) die("Out of memory");
	if (fseek(f, 0, SEEK_SET)) die("fseek");
	if (fread(buf, 1, len, f) != len) die("fread");
	for (i = 0; i < len - 18; i++)
	{
		if (!memcmp(buf + i + 1, "rogs/s", 6) && buf[i + 8] != 'e')
		{
			if (buf[i] && buf[i] != 'p') break;
			buf[i] ^= 'p';
			if (!--n) break;
		}
	}
	if (n) die("Not a qwsv executable.");
	if (fseek(f, 0, SEEK_SET)) die("fseek");
	if (fwrite(buf, 1, len, f) != len) die("fwrite");
	printf("Nailhack %s.\n", buf[i] ? "removed" : "applied");
	return 0;
}

