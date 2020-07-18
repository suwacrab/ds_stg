#include <nds.h>
#include <filesystem.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

#include "kbox.h"
#include "images.h"
#include "arcfont.h"

#define BULLET_LEN (0x0400)

// types
typedef struct game_mem
{
	u32 time;
	u16 bg_scroll[8][192][2];
} game_mem;

// vars
game_mem game;
u32 frame_cur = 0;
u32 frame_time = 0;
u32 tekuna_width = 8;
u32 tekuna_height = 8;
u32 tekuna_size;

// funcs
void init_sys();
void init_gfx();
void init_video();

void updt_bgscroll();

int main(int argc, char **argv) 
{
	tekuna_size = tekuna_width * tekuna_height;
	init_sys();
	game.time = 0;
	// create objs
	while(1) {
		dmaset(3,NULL,NULL,0);
		scanKeys();
		u32 keydown = keysDown();
		//u32 keyheld = keysHeld();

		if(keydown&KEY_START) break;
		if(game.time >= 90)
		{
			arcfont_clear_sub();
			char *buf1 = "ARCFONT test\n\nsample text\nSAMPLE TEXT\n\nthe quick brown fox\njumped over the lazy dog.";
			arcfont_draw_sub(buf1,0,0);
		}
		// draw tecna
		{
			// get GFX offset
			FILE *f = fopen("dat/tekuna/tekuna.anim.bin","rb");
			u32 frame_cnt = 0; fread(&frame_cnt,1,sizeof(u32),f);
			u16 frame_dat[frame_cnt]; fread(frame_dat,frame_cnt,sizeof(u16),f);
			fclose(f);
			// move frame
			u32 delay_cur = frame_dat[frame_cur];
			if(frame_time > delay_cur)
			{
				frame_cur++;
				frame_time = 0;
				if(frame_cur >= frame_cnt) { frame_time = 0; frame_cur = 0; }
			}
			frame_time++;
			// copy gfx to ram
			f = fopen("dat/tekuna/tekuna.img.bin","rb");
			fseek(f,(sizeof(CHAR4)*tekuna_size)*frame_cur,SEEK_SET);
			fread(BG_CHAR_MAIN(0) + 0x20,tekuna_size,sizeof(CHAR4),f);
			fclose(f);
			// draw to screen
			char txtbuf[0x100];
			const char *fmt = "game mem size: %08lX\ntime: %ld\nframe cnt: %ld\nframe cur: %ld";
			sprintf(txtbuf,fmt,(u32)sizeof(game_mem),game.time,frame_cnt,frame_cur);
			arcfont_draw_sub(txtbuf,0,8);
		}
		// update bg scroll
		updt_bgscroll();
		// vsync
		game.time++;
		swiWaitForVBlank();
	}

	return 0;
}

void updt_bgscroll()
{
	// update colors, first
	FILE *f = fopen("dat/tekuna/tekuna.pal.bin","rb");
	// > get colors
	CLR16 pal[0x10];
	fread(pal,0x10,sizeof(CLR16),f);
	fclose(f);
	// > lerp colors
	CLR16 bgclr = pal[7];
	pal[0] = bgclr;
	for(u32 i=0; i<16; i++)
	{
		pal[i] = clr15_bez(RGB15(31,31,31),bgclr,pal[i],CLAMP(game.time<<5,0,0x3FF));
		BG_PAL_MAIN[0][i] = pal[i];
	}
	// now update the scroll
	s16 (*scroll)[2] = (s16(*)[2])game.bg_scroll[0];
	s32 width = CLAMP(64 - mulf32(game.time,0x0800),0,64);
	const s32 signlut[2] = { -1,1 };
	dmaFillHalfWords(0,scroll,sizeof(u16)*2*SCREEN_HEIGHT);
	for(u32 y=0; y<192; y++)
	{
		scroll[y][0] = (s16)( (width * sinLerp((y + game.time)<<8))>>12);
		scroll[y][1] = (-4) + (s16)( (2 * cosLerp(mulf32(y + game.time,0x64000)))>>12);
		scroll[y][0] *= signlut[(game.time+y)&1];
	}
	dmacpy(3,scroll,&BG_OFFSET[0],sizeof(u16)*2);
	u32 mode = 2 | DMA_ENABLE | DMA_START_HBL | DMA_REPEAT | DMA_DST_RESET;
	dmaset(3,scroll,&BG_OFFSET[0],mode);
}

void init_sys()
{
	/*---- フィオール ---------*/
	nitroFSInit(NULL);
	/*---- インタラプト -------*/
	irqInit();
	irqEnable(IRQ_VBLANK | IRQ_HBLANK);
	/*---- console ------------*/
	consoleDebugInit(DebugDevice_NOCASH);
	/*---- ヴィデオ -----------*/
	init_video();
}
void init_gfx()
{
	FILE *filebuf = NULL;
	// load arcfont to bottom screen
	filebuf = fopen("dat/arcfont/arcfont.img.bin","rb");
	fread(BG_CHAR_SUB(2),0x100,sizeof(CHAR4),filebuf); fclose(filebuf);
	filebuf = fopen("dat/arcfont/arcfont.pal.bin","rb");
	fread(BG_PAL_SUB[0],0x10,sizeof(CLR16),filebuf); fclose(filebuf);
	// tecna
	filebuf = fopen("dat/tekuna/tekuna.img.bin","rb");
	fread(BG_CHAR_MAIN(0) + 0x20,tekuna_size,sizeof(CHAR4),filebuf); fclose(filebuf);
	filebuf = fopen("dat/tekuna/tekuna.pal.bin","rb");
	fread(BG_PAL_MAIN[0],0x10,sizeof(CLR16),filebuf); fclose(filebuf);
	BG_PAL_MAIN[0][0] = BG_PAL_MAIN[0][0x7];
	{
		u32 ox = 0x20 - tekuna_width;
		u32 oy = 0x18 - tekuna_height;
		for(u32 y=0; y<tekuna_height; y++)
		{
			for(u32 x=0; x<tekuna_width; x++)
			{
				BG_MAP_MAIN(0)[(x+ox) + (y+oy)*32] = 32 + (x+y*tekuna_width);
			}
		}
	}
}
void init_video()
{
	REG_DISPCNT = MODE_2_2D;
	REG_DISPCNT_SUB = MODE_1_2D | BG_ENABLE(true,true,true,true);
	vramSetBankA(VRAM_A_MAIN_BG);
	vramSetBankB(VRAM_B_MAIN_SPRITE);
	vramSetBankC(VRAM_C_SUB_BG);
	vramSetBankD(VRAM_D_SUB_SPRITE);

	// init main backgrounds
	bgInit(0,BgType_Text4bpp,BgSize_T_512x512,4,0);
	bgInit(1,BgType_Text4bpp,BgSize_T_512x512,12,1);
	bgInit(2,BgType_Rotation,BgSize_R_512x512,20,2);
	bgInit(3,BgType_Rotation,BgSize_R_512x512,28,3);
	// init sub backgrounds
	REG_BG0CNT_SUB = BG_64x64 | BG_MAP_BASE(4) | BG_TILE_BASE(0);
	REG_BG1CNT_SUB = BG_64x64 | BG_MAP_BASE(12) | BG_TILE_BASE(1);
	REG_BG2CNT_SUB = BG_64x32 | BG_MAP_BASE(20) | BG_TILE_BASE(2);
	REG_BG3CNT_SUB = BG_RS_64x64 | BG_MAP_BASE(28) | BG_TILE_BASE(3);
	// draw test message
	char text[] = "arcfont initialized!\neverything's ready. mostly.";
	strupr(text);
	arcfont_draw_sub(text,0,0);
	// load graphics
	init_gfx();
}

