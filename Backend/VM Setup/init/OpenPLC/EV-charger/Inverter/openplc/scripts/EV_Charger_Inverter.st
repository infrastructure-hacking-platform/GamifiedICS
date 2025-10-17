PROGRAM EV_Charger_Inverter
  VAR
    Voltage AT %QW20 : INT := 210;
    Is_Authenticated AT %QX10.0 : BOOL := FALSE;
    Max_Voltage AT %QW24 : INT := 230;
    Increasing AT %QX10.1 : BOOL := TRUE;
    Min_Voltage AT %QW26 : INT := 190;
    Threshold_Exceeded AT %IX10.2 : BOOL := FALSE;
    Explosion_Threshold AT %QW22 : INT := 400;
  END_VAR

  IF Increasing AND NOT Is_Authenticated THEN
    
    Voltage := Voltage + 1;
    
    IF Voltage >= Max_Voltage THEN
        
      Increasing := FALSE;
        
    END_IF;
      
  ELSIF NOT Increasing AND NOT Is_Authenticated THEN
    
    Voltage := Voltage - 1;
    
    IF Voltage <= Min_Voltage THEN
          
      Increasing := TRUE;
          
    END_IF;
      
  ELSIF Increasing AND Is_Authenticated THEN
    
    Voltage := Voltage + 1;
    
    IF Voltage >= Max_Voltage THEN (* user will need to manually set Max_Voltage to >400 so that it will exceed the threshold before Increasing is set back to false *)

        

      Increasing := FALSE;
      
    END_IF;
      
    IF Voltage >= Explosion_Threshold THEN
      
      Threshold_Exceeded := TRUE;

        

    END_IF;
    
  ELSE (* if none of the above 'if's are true, then this 'else' must logically mean that Increasing is false and Is_Authenticated is true *)
    
    Voltage := Voltage - 1;

    

    IF Voltage <= Min_Voltage THEN

          

      Increasing := TRUE;

          

    END_IF;
      
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : EV_Charger_Inverter;
  END_RESOURCE
END_CONFIGURATION

(*DBG:char md5[] = "afc5bb343c800c30e9c17d498b37da04";*)
(*DBG:/**)
(*DBG: * This file is part of OpenPLC Runtime*)
(*DBG: **)
(*DBG: * Copyright (C) 2023 Autonomy, GP Orcullo*)
(*DBG: * Based on the work by GP Orcullo on Beremiz for uC*)
(*DBG: **)
(*DBG: * This program is free software; you can redistribute it and/or*)
(*DBG: * modify it under the terms of the GNU General Public License*)
(*DBG: * as published by the Free Software Foundation; either version 2*)
(*DBG: * of the License, or (at your option) any later version.*)
(*DBG: **)
(*DBG: * This program is distributed in the hope that it will be useful,*)
(*DBG: * but WITHOUT ANY WARRANTY; without even the implied warranty of*)
(*DBG: * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the*)
(*DBG: * GNU General Public License for more details.*)
(*DBG: **)
(*DBG: * You should have received a copy of the GNU General Public License*)
(*DBG: * along with this program; If not, see <http://www.gnu.org/licenses/>.*)
(*DBG: **)
(*DBG: */*)
(*DBG:*)
(*DBG:#include <stdbool.h>*)
(*DBG:*)
(*DBG:#include "iec_types_all.h"*)
(*DBG:#include "POUS.h"*)
(*DBG:*)
(*DBG:#define SAME_ENDIANNESS      0*)
(*DBG:#define REVERSE_ENDIANNESS   1*)
(*DBG:*)
(*DBG:uint8_t endianness;*)
(*DBG:*)
(*DBG:*)
(*DBG:extern EV_CHARGER_INVERTER RES0__INSTANCE0;*)
(*DBG:*)
(*DBG:static const struct {*)
(*DBG:    void *ptr;*)
(*DBG:    __IEC_types_enum type;*)
(*DBG:} debug_vars[] = {*)
(*DBG:    {&(RES0__INSTANCE0.VOLTAGE), INT_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.IS_AUTHENTICATED), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.MAX_VOLTAGE), INT_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INCREASING), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.MIN_VOLTAGE), INT_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.THRESHOLD_EXCEEDED), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.EXPLOSION_THRESHOLD), INT_O_ENUM},*)
(*DBG:};*)
(*DBG:*)
(*DBG:#define VAR_COUNT               7*)
(*DBG:*)
(*DBG:uint16_t get_var_count(void)*)
(*DBG:{*)
(*DBG:    return VAR_COUNT;*)
(*DBG:}*)
(*DBG:*)
(*DBG:size_t get_var_size(size_t idx)*)
(*DBG:{*)
(*DBG:    if (idx >= VAR_COUNT)*)
(*DBG:    {*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case BOOL_O_ENUM:*)
(*DBG:    case BOOL_P_ENUM:*)
(*DBG:        return sizeof(BOOL);*)
(*DBG:    case INT_O_ENUM:*)
(*DBG:        return sizeof(INT);*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void *get_var_addr(size_t idx)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case BOOL_O_ENUM:*)
(*DBG:    case BOOL_P_ENUM:*)
(*DBG:        return (void *)((((__IEC_BOOL_p *) ptr)->flags & __IEC_FORCE_FLAG) *)
(*DBG:                        ? &(((__IEC_BOOL_p *) ptr)->fvalue) *)
(*DBG:                        : ((__IEC_BOOL_p *) ptr)->value);*)
(*DBG:    case INT_O_ENUM:*)
(*DBG:        return (void *)((((__IEC_INT_p *) ptr)->flags & __IEC_FORCE_FLAG) *)
(*DBG:                        ? &(((__IEC_INT_p *) ptr)->fvalue) *)
(*DBG:                        : ((__IEC_INT_p *) ptr)->value);*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void force_var(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    if (forced) {*)
(*DBG:        size_t var_size = get_var_size(idx);*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case BOOL_O_ENUM: {*)
(*DBG:            memcpy((((__IEC_BOOL_p *) ptr)->value), val, var_size);*)
(*DBG:            //*(((__IEC_BOOL_p *) ptr)->value) = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_p *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case BOOL_P_ENUM: {*)
(*DBG:            memcpy(&((__IEC_BOOL_p *) ptr)->fvalue, val, var_size);*)
(*DBG:            //((__IEC_BOOL_p *) ptr)->fvalue = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_p *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case INT_O_ENUM: {*)
(*DBG:            memcpy((((__IEC_INT_p *) ptr)->value), val, var_size);*)
(*DBG:            //*(((__IEC_INT_p *) ptr)->value) = *((INT *) val);*)
(*DBG:            ((__IEC_INT_p *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    } else {*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case BOOL_O_ENUM:*)
(*DBG:        case BOOL_P_ENUM:*)
(*DBG:            ((__IEC_BOOL_p *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        case INT_O_ENUM:*)
(*DBG:            ((__IEC_INT_p *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void swap_bytes(void *ptr, size_t size) *)
(*DBG:{*)
(*DBG:    uint8_t *bytePtr = (uint8_t *)ptr;*)
(*DBG:    size_t i;*)
(*DBG:    for (i = 0; i < size / 2; ++i) *)
(*DBG:    {*)
(*DBG:        uint8_t temp = bytePtr[i];*)
(*DBG:        bytePtr[i] = bytePtr[size - 1 - i];*)
(*DBG:        bytePtr[size - 1 - i] = temp;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void trace_reset(void)*)
(*DBG:{*)
(*DBG:    for (size_t i=0; i < VAR_COUNT; i++) *)
(*DBG:    {*)
(*DBG:        force_var(i, false, 0);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_trace(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    if (idx >= 0 && idx < VAR_COUNT) *)
(*DBG:    {*)
(*DBG:        if (endianness == REVERSE_ENDIANNESS)*)
(*DBG:        {*)
(*DBG:            // Aaaaarghhhh... Stupid AVR is Big Endian.*)
(*DBG:            swap_bytes(val, get_var_size(idx));*)
(*DBG:        }*)
(*DBG:*)
(*DBG:        force_var(idx, forced, val);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_endianness(uint8_t value)*)
(*DBG:{*)
(*DBG:    if (value == SAME_ENDIANNESS || value == REVERSE_ENDIANNESS)*)
(*DBG:    {*)
(*DBG:        endianness = value;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)