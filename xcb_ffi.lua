local ffi = require("ffi")


--#define XCB_PACKED __attribute__((__packed__))
--#define XCB_TYPE_PAD(T,I) (-(I) & (sizeof(T) > 4 ? 3 : sizeof(T) - 1))

ffi.cdef[[
typedef struct xcb_connection_t xcb_connection_t;  

typedef struct {
    void *data;   /**< Data of the current iterator */
    int rem;    /**< remaining elements */
    int index;  /**< index of the current iterator */
} xcb_generic_iterator_t;


typedef struct {
    uint8_t   response_type;  /**< Type of the response */
    uint8_t  pad0;           /**< Padding */
    uint16_t sequence;       /**< Sequence number */
    uint32_t length;         /**< Length of the response */
} xcb_generic_reply_t;


typedef struct {
    uint8_t   response_type;  /**< Type of the response */
    uint8_t  pad0;           /**< Padding */
    uint16_t sequence;       /**< Sequence number */
    uint32_t pad[7];         /**< Padding */
    uint32_t full_sequence;  /**< full sequence */
} xcb_generic_event_t;


typedef struct {
    uint8_t   response_type;  /**< Type of the response */
    uint8_t   error_code;     /**< Error code */
    uint16_t sequence;       /**< Sequence number */
    uint32_t resource_id;     /** < Resource ID for requests with side effects only */
    uint16_t minor_code;      /** < Minor opcode of the failed request */
    uint8_t major_code;       /** < Major opcode of the failed request */
    uint8_t pad0;
    uint32_t pad[5];         /**< Padding */
    uint32_t full_sequence;  /**< full sequence */
} xcb_generic_error_t;


typedef struct {
    unsigned int sequence;  /**< Sequence number */
} xcb_void_cookie_t;
]]

-- Include the generated xproto header.
--#include "xproto.h"


ffi.cdef[[
typedef struct xcb_auth_info_t {
    int   namelen;  /**< Length of the string name (as returned by strlen). */
    char *name;     /**< String containing the authentication protocol name, such as "MIT-MAGIC-COOKIE-1" or "XDM-AUTHORIZATION-1". */
    int   datalen;  /**< Length of the data member. */
    char *data;   /**< Data interpreted in a protocol-specific manner. */
} xcb_auth_info_t;
]]


ffi.cdef[[
typedef struct xcb_special_event xcb_special_event_t;
typedef struct xcb_extension_t xcb_extension_t;
]]

ffi.cdef[[
int xcb_flush(xcb_connection_t *c);

uint32_t xcb_get_maximum_request_length(xcb_connection_t *c);

void xcb_prefetch_maximum_request_length(xcb_connection_t *c);

xcb_generic_event_t *xcb_wait_for_event(xcb_connection_t *c);

xcb_generic_event_t *xcb_poll_for_event(xcb_connection_t *c);

xcb_generic_event_t *xcb_poll_for_queued_event(xcb_connection_t *c);



xcb_generic_event_t *xcb_poll_for_special_event(xcb_connection_t *c,
                                                xcb_special_event_t *se);
 
xcb_generic_event_t *xcb_wait_for_special_event(xcb_connection_t *c,
                                                xcb_special_event_t *se);


xcb_special_event_t *xcb_register_for_special_xge(xcb_connection_t *c,
                                                  xcb_extension_t *ext,
                                                  uint32_t eid,
                                                  uint32_t *stamp);

void xcb_unregister_for_special_event(xcb_connection_t *c,
                                      xcb_special_event_t *se);

xcb_generic_error_t *xcb_request_check(xcb_connection_t *c, xcb_void_cookie_t cookie);

void xcb_discard_reply(xcb_connection_t *c, unsigned int sequence);

const xcb_query_extension_reply_t *xcb_get_extension_data(xcb_connection_t *c, xcb_extension_t *ext);

void xcb_prefetch_extension_data(xcb_connection_t *c, xcb_extension_t *ext);

const xcb_setup_t *xcb_get_setup(xcb_connection_t *c);

int xcb_get_file_descriptor(xcb_connection_t *c);

int xcb_connection_has_error(xcb_connection_t *c);

xcb_connection_t *xcb_connect_to_fd(int fd, xcb_auth_info_t *auth_info);

void xcb_disconnect(xcb_connection_t *c);

int xcb_parse_display(const char *name, char **host, int *display, int *screen);

xcb_connection_t *xcb_connect(const char *displayname, int *screenp);

xcb_connection_t *xcb_connect_to_display_with_auth_info(const char *display, xcb_auth_info_t *auth, int *screen);

uint32_t xcb_generate_id(xcb_connection_t *c);
]]

local Lib_XCB = ffi.load ("xcb")

local exports = {
    Lib_XCB = Lib_XCB;

    -- some constants
    X_PROTOCOL = 11;
    X_PROTOCOL_REVISION = 0;
    X_TCP_PORT = 6000;
    XCB_CONN_ERROR = 1;
    XCB_CONN_CLOSED_EXT_NOTSUPPORTED = 2;
    XCB_CONN_CLOSED_MEM_INSUFFICIENT = 3;
    XCB_CONN_CLOSED_REQ_LEN_EXCEED = 4;
    XCB_CONN_CLOSED_PARSE_ERR = 5;
    XCB_CONN_CLOSED_INVALID_SCREEN = 6;
    XCB_CONN_CLOSED_FDPASSING_FAILED = 7;

	XCB_NONE = 0;
	XCB_COPY_FROM_PARENT = 0;
	XCB_CURRENT_TIME = 0;
	XCB_NO_SYMBOL = 0;
}

return exports
