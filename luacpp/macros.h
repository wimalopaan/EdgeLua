#pragma once

#define __hash #
#define __identity(x) x
#define ADD(table, v) table[__identity(__hash)table + 1] = v

#ifdef DEBUG
# define ASSERT(x) if not(x) then print("Assertion error:" .. #x) end
# define TRACE(...) print("TRACE: "__VA_OPT__(,) __VA_ARGS__ )
#else
# define ASSERT(X)
# define TRACE(x)
#endif