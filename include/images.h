#ifndef IMAGES_H
#define IMAGES_H

#include "kbox.h"

#define IMG_LEN (0x0100)

/*---- enums ------------------*/
typedef enum img_name
{
	IMG_ARCFONT
} img_name;

/*---- externs ----------------*/
extern u16 *IMG_LUT[IMG_LEN];

#endif
