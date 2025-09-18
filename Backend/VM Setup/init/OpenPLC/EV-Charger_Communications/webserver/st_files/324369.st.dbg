char md5[] = "793b2e5d4f4ccc510ba7bc6d8c0352f9";
/*
 * This file is part of OpenPLC Runtime
 *
 * Copyright (C) 2023 Autonomy, GP Orcullo
 * Based on the work by GP Orcullo on Beremiz for uC
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <stdbool.h>

#include "iec_types_all.h"
#include "POUS.h"

#define SAME_ENDIANNESS      0
#define REVERSE_ENDIANNESS   1

uint8_t endianness;


extern EV_CHARGER_COMMS RES0__INSTANCE0;

static const struct {
    void *ptr;
    __IEC_types_enum type;
} debug_vars[] = {
    {&(RES0__INSTANCE0.VOLTAGE), INT_P_ENUM},
    {&(RES0__INSTANCE0.INCREASING), BOOL_P_ENUM},
    {&(RES0__INSTANCE0.EXPLOSION_THRESHOLD), INT_P_ENUM},
    {&(RES0__INSTANCE0.CYCLE_COUNT), INT_P_ENUM},
    {&(RES0__INSTANCE0.INVERTER_COMPROMISED), BOOL_P_ENUM},
    {&(RES0__INSTANCE0.EXPLOSION), BOOL_P_ENUM},
};

#define VAR_COUNT               6

uint16_t get_var_count(void)
{
    return VAR_COUNT;
}

size_t get_var_size(size_t idx)
{
    if (idx >= VAR_COUNT)
    {
        return 0;
    }
    switch (debug_vars[idx].type) {
    case INT_P_ENUM:
        return sizeof(INT);
    case BOOL_P_ENUM:
        return sizeof(BOOL);
    default:
        return 0;
    }
}

void *get_var_addr(size_t idx)
{
    void *ptr = debug_vars[idx].ptr;

    switch (debug_vars[idx].type) {
    case INT_P_ENUM:
        return (void *)((((__IEC_INT_p *) ptr)->flags & __IEC_FORCE_FLAG) 
                        ? &(((__IEC_INT_p *) ptr)->fvalue) 
                        : ((__IEC_INT_p *) ptr)->value);
    case BOOL_P_ENUM:
        return (void *)((((__IEC_BOOL_p *) ptr)->flags & __IEC_FORCE_FLAG) 
                        ? &(((__IEC_BOOL_p *) ptr)->fvalue) 
                        : ((__IEC_BOOL_p *) ptr)->value);
    default:
        return 0;
    }
}

void force_var(size_t idx, bool forced, void *val)
{
    void *ptr = debug_vars[idx].ptr;

    if (forced) {
        size_t var_size = get_var_size(idx);
        switch (debug_vars[idx].type) {
        case INT_P_ENUM: {
            memcpy(&((__IEC_INT_p *) ptr)->fvalue, val, var_size);
            //((__IEC_INT_p *) ptr)->fvalue = *((INT *) val);
            ((__IEC_INT_p *) ptr)->flags |= __IEC_FORCE_FLAG;
            break;
        }
        case BOOL_P_ENUM: {
            memcpy(&((__IEC_BOOL_p *) ptr)->fvalue, val, var_size);
            //((__IEC_BOOL_p *) ptr)->fvalue = *((BOOL *) val);
            ((__IEC_BOOL_p *) ptr)->flags |= __IEC_FORCE_FLAG;
            break;
        }
        default:
            break;
        }
    } else {
        switch (debug_vars[idx].type) {
        case INT_P_ENUM:
            ((__IEC_INT_p *) ptr)->flags &= ~__IEC_FORCE_FLAG;
            break;
        case BOOL_P_ENUM:
            ((__IEC_BOOL_p *) ptr)->flags &= ~__IEC_FORCE_FLAG;
            break;
        default:
            break;
        }
    }
}

void swap_bytes(void *ptr, size_t size) 
{
    uint8_t *bytePtr = (uint8_t *)ptr;
    size_t i;
    for (i = 0; i < size / 2; ++i) 
    {
        uint8_t temp = bytePtr[i];
        bytePtr[i] = bytePtr[size - 1 - i];
        bytePtr[size - 1 - i] = temp;
    }
}

void trace_reset(void)
{
    for (size_t i=0; i < VAR_COUNT; i++) 
    {
        force_var(i, false, 0);
    }
}

void set_trace(size_t idx, bool forced, void *val)
{
    if (idx >= 0 && idx < VAR_COUNT) 
    {
        if (endianness == REVERSE_ENDIANNESS)
        {
            // Aaaaarghhhh... Stupid AVR is Big Endian.
            swap_bytes(val, get_var_size(idx));
        }

        force_var(idx, forced, val);
    }
}

void set_endianness(uint8_t value)
{
    if (value == SAME_ENDIANNESS || value == REVERSE_ENDIANNESS)
    {
        endianness = value;
    }
}
