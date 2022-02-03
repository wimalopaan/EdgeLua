#pragma once

#define __hash #
#define __identity(x) x
#define ADD(table, v) table[__identity(__hash)table + 1] = v
#define INC(value) value = value + 1
#define DEC(value) value = value - 1
#define INCMOD(value, table) if (value == __identity(__hash)table) then value = 1; else INC(value); end
#define DECMOD(value, table) if (value == 1) then value = __identity(__hash)table; else DEC(value); end
#define APPEND(str, app) str = str .. app

#ifdef DEBUG
# define TRACELEVEL 0 // 0, 1, 2, 3
# define ASSERT(x) if not(x) then print("Assertion error:" .. #x) end
# define TRACE(...) print("TRACE: " __VA_OPT__(,) __VA_ARGS__ )
#if (TRACELEVEL == 0)
# define TRACE1(...)
# define TRACE2(...)
# define TRACE3(...)
#elif   (TRACELEVEL <= 1)
# define TRACE1(...) print("TRACE -L1- :  "__VA_OPT__(,) __VA_ARGS__ )
# define TRACE2(...)
# define TRACE3(...)
#elif (TRACELEVEL <= 2) 
# define TRACE1(...) print("TRACE -L1- : " __VA_OPT__(,) __VA_ARGS__ )
# define TRACE2(...) print("TRACE -L2- : " __VA_OPT__(,) __VA_ARGS__ )
# define TRACE3(...)
#elif (TRACELEVEL <= 3)
# define TRACE1(...) print("TRACE -L1- : " __VA_OPT__(,) __VA_ARGS__ )
# define TRACE2(...) print("TRACE -L2- : " __VA_OPT__(,) __VA_ARGS__ )
# define TRACE3(...) print("TRACE -L3- : " __VA_OPT__(,) __VA_ARGS__ )
#else
# define TRACE1(...)
# define TRACE2(...)
# define TRACE3(...)
#endif 
#else
# define ASSERT(X)
# define TRACE(...)
# define TRACE1(...)
# define TRACE2(...)
# define TRACE3(...)
#endif