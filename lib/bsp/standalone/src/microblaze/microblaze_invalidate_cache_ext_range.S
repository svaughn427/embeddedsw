/******************************************************************************
*
* Copyright (C) 2008 - 2018 Xilinx, Inc. All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*
*
******************************************************************************/
/******************************************************************************
*
* microblaze_invalidate_cache_ext_range (unsigned int cacheaddr, unsigned int len)
*
*Invalidate an L2 cache range
*
*Parameters:
*	'cacheaddr' - address in the L2 cache where invalidation begins
*	'len    '   - length (in bytes) worth of Dcache to be invalidated
*
*******************************************************************************/

#include "xparameters.h"
#include "microblaze_instructions.h"

#define XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN	16

	.text
	.globl	microblaze_invalidate_cache_ext_range
	.ent	microblaze_invalidate_cache_ext_range
	.align	2

microblaze_invalidate_cache_ext_range:
#if ((XPAR_MICROBLAZE_INTERCONNECT==3) && (XPAR_MICROBLAZE_USE_DCACHE==1))
	beqi	r6, Loop_done

	ADD	r6, r5, r6
	ADDIK	r6, r6, -1

	ANDI	r6, r6, -(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)
	ANDI	r5, r5, -(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)

	RSUBK	r6, r5, r6

Loop_start:
	wdc.ext.clear r5, r6
#if defined (__arch64__ )
	addlik	r6, r6, -(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)
	beagei r6, Loop_start
#else
	bneid	r6, Loop_start
	addik	r6, r6, -(4 * XPAR_MICROBLAZE_EXT_CACHE_LINE_LEN)
#endif

Loop_done:
#endif
	rtsd	r15, 8
	nop

	.end	microblaze_invalidate_cache_ext_range
