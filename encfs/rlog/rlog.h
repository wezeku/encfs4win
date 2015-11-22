/**
*	Note: this is a temporary placeholder for rlog, since the windows port
*	is ancient and I cannot get it to compile with modern VS platforms.
*
*	In the future, either replace this with a better logging infrastructure
*	(for instance, Boost.log) or make it slightly more flexible by 
*	defining helper functions. 
*/


#ifndef _RLOG_H
#define _RLOG_H

#include <iostream>
#include <string>
#include <cstdarg>

namespace rlog {

// always print to terminal if things go wrong 
#define rAssert( cond ) \
    do { \
	if( ((cond) == false) ) \
	{ \
	printf("ASSERT FAILED\n"); \
	throw( "Assert failed!" ); \
	} \
    } while(0)

#define rError( format, ... ) \
    do { \
	printf("ERROR: "); \
	printf(format, ##__VA_ARGS__ ); \
	printf("\n"); \
    } while(0)



// If debugging, print to terminal, otherwise they are a no-op 
#ifdef DEBUG

#define rWarning( format, ... ) \
    do { \
	printf("WARN: "); \
	printf(format, ##__VA_ARGS__ ); \
	printf("\n"); \
    } while(0)

#define rDebug( format, ... ) \
    do { \
	printf("DEBUG: "); \
	printf(format, ##__VA_ARGS__ ); \
	printf("\n"); \
    } while(0)

#define rLog( type, format, ... ) \
    do { \
	printf("LOG: "); \
	printf(format, ##__VA_ARGS__ ); \
	printf("\n"); \
    } while(0)

#define rInfo( format, ... ) \
    do { \
	printf("INFO: "); \
	printf(format, ##__VA_ARGS__ ); \
	printf("\n"); \
    } while(0)

#else

#define rWarning( format, ... ) \
    do {} while(0)

#define rDebug( format, ... ) \
    do {} while(0)

#define rLog( type, format, ... ) \
    do {} while(0)

#define rInfo( format, ... ) \
    do {} while(0)

#endif

}

#endif /* _RLOG_H */