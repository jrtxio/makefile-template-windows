#include "fnet_socket.h"
#include "fnet_prot.h"

/************************************************************************
*     Global Data Structures
*************************************************************************/
static fnet_socket_if_t *fnet_socket_desc[FNET_CFG_SOCKET_MAX];


/************************************************************************
*     Function Prototypes
*************************************************************************/
static fnet_socket_t _fnet_socket_desc_alloc(void);
static void _fnet_socket_desc_free(fnet_socket_t desc);
static fnet_socket_if_t *_fnet_socket_desc_find(fnet_socket_t desc);
static void _fnet_socket_desc_set(fnet_socket_t desc, fnet_socket_if_t *sock);

/************************************************************************
* DESCRIPTION: This function creates a socket and returns
*              the descriptor to the application.
*************************************************************************/
fnet_socket_t fnet_socket_create(int protocol, fnet_socket_if_t *sock)
{
    fnet_prot_if_t *prot;
    fnet_socket_t res;

    if ((prot = _fnet_prot_find(protocol)) == 0)
    {
        return FNET_NULL;
    }

    res = _fnet_socket_desc_alloc();
    
    _fnet_socket_desc_set(res, sock);
    _fnet_socket_list_add(&prot->head, sock);

    return res;
}

/************************************************************************
* DESCRIPTION: This function release all resources allocated for the socket.
*************************************************************************/
void fnet_socket_release(int protocol, fnet_socket_if_t *sock)
{
    fnet_prot_if_t *prot;
    fnet_prot_if_t **head;

    if ((prot = _fnet_prot_find(protocol)) == 0)
    {
        return;
    }

    _fnet_socket_desc_free(sock->descriptor);
    _fnet_socket_list_del(&prot->head, sock);
}

/************************************************************************
* DESCRIPTION: This function adds socket into the queue.
*************************************************************************/
void _fnet_socket_list_add(fnet_socket_if_t **head, fnet_socket_if_t *s)
{
    s->next = *head;

    if (s->next != 0)
    {
       s->next->prev = s; 
    }
    s->prev = 0;
    *head = s;
}

/************************************************************************
* DESCRIPTION: This function removes socket from the queue
*************************************************************************/
void _fnet_socket_list_del(fnet_socket_if_t **head, fnet_socket_if_t *s)
{
    if (s->prev == 0)
    {
        *head = s->next;
    }
    else
    {
        s->prev->next = s->next;
    }

    if (s->next != 0)
    {
        s->next->prev = s->prev;
    }
}

/************************************************************************
* DESCRIPTION: This function reserves socket descriptor.
*************************************************************************/
static fnet_socket_t _fnet_socket_desc_alloc(void)
{
    int i = 0;
    fnet_socket_t res = FNET_NULL;

    for (i = 0; i < FNET_CFG_SOCKET_MAX; i++) /* Find the empty descriptor. */
    {
        if (fnet_socket_desc[i] == 0)
        {
            fnet_socket_desc[i] = (fnet_socket_if_t *)FNET_SOCKET_DESC_RESERVED;
            res = &fnet_socket_desc[i];
            break;
        }
    }

    return res;
}

/************************************************************************
* DESCRIPTION: This function looking for socket structure
*              associated with the socket descriptor.
*************************************************************************/
static void _fnet_socket_desc_free(fnet_socket_t desc)
{
    if (desc)
    {
        *(fnet_prot_if_t **)desc = FNET_NULL;
    }
}

/************************************************************************
* DESCRIPTION: This function assigns the socket descriptor to the socket.
*************************************************************************/
static void _fnet_socket_desc_set(fnet_socket_t desc, fnet_socket_if_t *sock)
{
    *(fnet_socket_if_t **)desc = sock;
    sock->descriptor = desc;
}