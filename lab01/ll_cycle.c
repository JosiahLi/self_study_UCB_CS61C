#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if (!head) return 0; 
    
    node* tortoise, *hare;
    tortoise = hare = head;

    while (hare)
    {
        /* advance hare by 2 steps */
        hare = hare->next;
        if (hare) hare = hare->next;
        /* advance tortoise by 1 step */
        tortoise = tortoise->next;
        /* there is a cycle */
        if (hare == tortoise) return 1;
    }

    return 0;
}