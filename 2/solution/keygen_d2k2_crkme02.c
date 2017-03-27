#include <stdio.h>
#include <conio.h>
#include <string.h>

char name[8 + 1];
char serial[16 + 1];
char constkey[16] = {'S', 'J', 'K', 'A', 'Z', 'B', 'V', 'T', 'E', 'C', 'G', 'I', 'D', 'F', 'N', 'G'};
char buf[8 + 1];

void main()
{
	for (int i = 0; i < sizeof(serial) - 1; i++)
		serial[i] = constkey[i];

	printf_s("Enter your name(8 chars max and 1 chars min): ");
	fgets(name, sizeof(name), stdin);

	int nl = strlen(name) - 1;
	if (name[nl] == '\n')
		name[nl] = '\x00';
	else
		nl++;

	int j = 0;
	for (int i = 0; i < nl; i++)
	{
		if (name[i] < 0x41)
		{
			name[i] += 0x20;
			if (name[i] < 0x41)
				name[i] = 0x46;
		}

		if (name[i] > 0x5a)
		{
			name[i] -= 0x20;
			if (name[i] > 0x5a)
				name[i] = 0x47;

			if (name[i] < 0x41)
				name[i] = 0x53;
		}

		serial[j] = name[i];
		j += 2;
	}

	int s = 0;
	for (int i = 0; i < sizeof(serial) - 1; i++)
		s += serial[i];

	j = nl * 0xff;
	s *= j;
	s ^= 0xacebdfab;
	s = ((s & 0x000000ff) << 24) |
		((s & 0x0000ff00) << 8) |
		((s & 0x00ff0000) >> 8) |
		((s & 0xff000000) >> 24); //bswap edx

	sprintf_s(buf, sizeof(buf), "%lX", s);

	for (int i = 0; i < sizeof(buf) - 1; i++)
		if (buf[i] < 0x3a)
			buf[i] += 0x11;

	j = 0;
	for (int i = 0; i < sizeof(serial) - 1; i += 2)
	{
		serial[i + 1] = buf[j];
		j++;
	}

	for (int i = 0; i < sizeof(serial) - 1; i += 2)
		serial[i + 1] += 0x05;

	printf_s("Your serial: %s\n", serial);
	_getch();
}
