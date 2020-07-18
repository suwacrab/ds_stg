#ifndef ARCFONT_H
#define ARCFONT_H

#include "kbox.h"
#define ARCFONT_MAP_SUB (BG_MAP_SUB(2))

INLINE void arcfont_clear_sub()
{
	dmaFillHalfWords(0x0000,ARCFONT_MAP_SUB,sizeof(u16)*64*32);
}
INLINE void arcfont_draw_sub(const char *txt,u32 x,u32 y)
{
	u32 ox = 0;
	u32 oy = 0;
	u32 len = (u32)strlen(txt);
	for(u32 i = 0; i<len; i++)
	{
		char c = txt[i];
		if(c=='\n')
		{ ox = 0; oy++; }
		else if((c&0x7F)>0x1F)
		{
			ARCFONT_MAP_SUB[(x+ox) + (y+oy)*32] = c;
			ox++;
		}
		else { ox++; }
	}
}

#endif
