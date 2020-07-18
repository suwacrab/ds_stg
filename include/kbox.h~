#ifndef KBOX_H
#define KBOX_H

#include <nds.h>
#include <string.h>

/*---- basics -----------------*/
typedef s16 FIX16;
typedef s32 FIX32;

typedef struct CLR24 { u8 r,g,b; u8 dummy; } CLR24;
typedef u16 CLR16;

#define INLINE static inline
INLINE s32 CLAMP(s32 x,s32 a,s32 b)
{
	return ( (x)<(a) ? (a) : (x)>(b) ? (b) : (x) );
}
/*---- vectors ----------------*/
typedef struct vec2_f32 { float x,y; } vec2_f32;
typedef struct vec2_fx { FIX32 x,y; } vec2_fx;
#define VEC2FX_ADD(a,b) ((vec2_fx){(a).x+(b).x,(a).y+(b).y})

/*---- fixed point ------------*/
INLINE s32 fx_lerp(s32 a,s32 b,s32 f)
{return (a*(1024-f)+b*f) >> 10; }

/*---- memory -----------------*/
// sizes
#define KBSIZE(n) ((n)*1024)
#define MBSIZE(n) (KBSIZE(1024)*(n))
#define GBSIZE(n) (MBSIZE(1024)*(n))
// background control
#define BG_ENABLE(b0,b1,b2,b3) ( ((b0) | ((b1)<<1) | ((b2)<<2) | ((b3)<<3))<<8)
#define BG_ENABLE_ALL (BG_ENABLE(true,true,true,true))
// palettes
typedef CLR16 PAL16[0x10];
#define BG_PAL_MAIN ((PAL16*)BG_PALETTE)
#define BG_PAL_SUB  ((PAL16*)BG_PALETTE_SUB)
#define FG_PAL_MAIN ((PAL16*)SPRITE_PALETTE)
#define FG_PAL_SUB  ((PAL16*)SPRITE_PALETTE_SUB)
// characters
typedef u16 CHAR4[0x10];
typedef u16 CHAR8[0x20];
#define BG_CHAR_MAIN(b) ((CHAR4*)bgGetGfxPtr((b)))
#define BG_CHAR_SUB(b) (BG_CHAR_MAIN(4+(b)))
// maps
#define BG_MAP_MAIN(b) ((u16*)bgGetMapPtr((b)))
#define BG_MAP_SUB(b) (BG_MAP_MAIN(4+(b)))
// DMA
typedef struct DMA_CH
{
	void *src;
	void *dst;
	u32 ctrl;
} DMA_CH;
#define DMA_BASE ((volatile u16*)(0x040000B0))
#define DMA_REG ((volatile DMA_CH*)(DMA_BASE))

typedef enum DMA_MODE9
{
	DMA_ON, DMA_VBL,
	DMA_HBL,DMA_DISP,
	DMA_MAINMEM,DMA_DSCART,
	DMA_GBCART,DMA_GEOFIFO
} DMA_MODE9;
/*---- colors -----------------*/
INLINE CLR16 clr15_lerp(CLR16 a,CLR16 b,s32 f)
{
	CLR16 clr = RGB15(
		fx_lerp(a&31,b&31,f),
		fx_lerp((a>>5)&31,(b>>5)&31,f),
		fx_lerp(a>>10,b>>10,f)
	);
	return clr;
}
INLINE CLR16 clr15_bez(CLR16 a,CLR16 b,CLR16 c,s32 f)
{
	CLR16 l1 = clr15_lerp(a,b,f);
	CLR16 l2 = clr15_lerp(b,c,f);
	return clr15_lerp(l1,l2,f);
}
/*---- DMA --------------------*/
INLINE void dmaset(u32 channel,const void *src,const void *dst,u32 ctrl)
{
	DMA_REG[channel].src = (void*)src;
	DMA_REG[channel].dst = (void*)dst;
	DMA_REG[channel].ctrl = (u32)ctrl;
}
INLINE void dmacpy(u32 channel,const void *src,const void *dst,u32 len)
{
	DMA_REG[channel].ctrl = 0;
	dmaset(channel,src,dst,(len>>1) | (DMA_ENABLE));
}

#endif
