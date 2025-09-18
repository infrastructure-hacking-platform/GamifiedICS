#ifndef __POUS_H
#define __POUS_H

#include "accessor.h"
#include "iec_std_lib.h"

// PROGRAM EV_CHARGER_COMMS
// Data part
typedef struct {
  // PROGRAM Interface - IN, OUT, IN_OUT variables

  // PROGRAM private variables - TEMP, private and located variables
  __DECLARE_LOCATED(INT,VOLTAGE)
  __DECLARE_LOCATED(BOOL,INCREASING)
  __DECLARE_LOCATED(INT,EXPLOSION_THRESHOLD)
  __DECLARE_LOCATED(INT,CYCLE_COUNT)
  __DECLARE_LOCATED(BOOL,INVERTER_COMPROMISED)
  __DECLARE_LOCATED(BOOL,EXPLOSION)

} EV_CHARGER_COMMS;

void EV_CHARGER_COMMS_init__(EV_CHARGER_COMMS *data__, BOOL retain);
// Code part
void EV_CHARGER_COMMS_body__(EV_CHARGER_COMMS *data__);
#endif //__POUS_H
