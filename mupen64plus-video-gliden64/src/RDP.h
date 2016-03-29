#ifndef RDP_H
#define RDP_H

#include <stdint.h>

#include "../../Graphics/RDP/RDP_state.h"

const unsigned int maxCMDMask = MAXCMD - 1;

void RDP_Init(void);
void RDP_Half_1(uint32_t _c);
void RDP_ProcessRDPList(void);
void RDP_RepeatLastLoadBlock();
void RDP_SetScissor(uint32_t w0, uint32_t w1);

#endif

