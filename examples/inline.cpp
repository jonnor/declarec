
/* declarec json mydefs.h
{
    "type": "enum",
    "name": "MyEnum",
    "values": {
        "First": 0,
        "Second": null,
        "Third": null
    }
}
declarec */

#include "mydefs.h"
#include <stdio.h>

int
main(int argc, char *argv[]) {

    for (int i=MyEnumFirst; i<=MyEnumThird; i++) {
        printf("%s\n", MyEnum_names[i]);
    }
}
