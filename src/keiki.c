#include "keiki.h"

mayumi *keiki_init(
	mayumi *may,haniwa *objs,u32 len
)
{
	/*---- setup keiki ----------*/
	may->len = len&0xFFFF;
	may->last = 0;
	may->alive = 0;
	may->objs = objs;
	/*---- setup objects --------*/
	for(u32 i=0; i<len; i++)
	{
		memset(&objs[i],0,sizeof(haniwa));
		objs[i].next = i+1; objs[i].dead = true;
		objs[i].mode = 0; objs[i].id = i;
	}
	objs[len-1].next = 0xFFFF;
	return may;
}

haniwa *keiki_add(mayumi *may,keiki_func *cb)
{
	// don't use too many objects
	if(may->alive == may->len) return NULL;
	// add new object
	haniwa *hani = &may->objs[may->last];
	hani->dead = false;
	if(cb != NULL) (*cb)(may,may->last,hani);
	// remove from free list
	may->last = hani->next;
	may->alive++;
	return hani;
}
haniwa *keiki_del(mayumi *may,u32 id,keiki_func *cb)
{
	// delete object
	haniwa *hani = &may->objs[id];
	hani->dead = true;
	if(cb != NULL) (*cb)(may,may->last,hani);
	// add to free list
	hani->next = may->last;
	may->last = id;
	may->alive--;
	return hani;
}

