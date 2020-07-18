#ifndef KEIKI_H
#define KEIKI_H

#include "kbox.h"

/*---- types ------------------*/
typedef struct haniwa
{
	u8 data[0x40];
	u16 id,mode;
	u16 next,dead;
} haniwa;

typedef struct mayumi
{
	u32 len,last,alive;
	haniwa *objs;
} mayumi;

typedef void (*keiki_func)(mayumi*,u32,haniwa*);

/*---- functions --------------*/
extern mayumi *keiki_init(mayumi *list,haniwa *objs,u32 len);
extern haniwa *keiki_add(mayumi *list,keiki_func *cb);
extern haniwa *keiki_del(mayumi *list,u32 id,keiki_func *cb);

#endif

