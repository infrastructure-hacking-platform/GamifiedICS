PROGRAM EV_Charger_Comms
  VAR
    Voltage AT %IW100 : INT;
    Increasing AT %IX100.2 : BOOL;
    Explosion_Threshold AT %IW101 : INT;
    Cycle_Count AT %IW102 : INT;
    Inverter_Compromised AT %IX100.0 : BOOL;
    Explosion AT %IX100.1 : BOOL;
  END_VAR

  (*Cycle_Count := Cycle_Count + 1; *)







  IF Inverter_Compromised THEN

    Voltage := Voltage + 1; (* Gradually increase voltage until explosion threshold is reached *)
    
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : EV_Charger_Comms;
  END_RESOURCE
END_CONFIGURATION
