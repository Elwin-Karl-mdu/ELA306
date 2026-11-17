TYPE
  LOGLEVEL : (CRITICAL, WARNING, INFO, DEBUG) := INFO;
END_TYPE

FUNCTION_BLOCK LOGGER
  VAR_INPUT
    TRIG : BOOL;
    MSG : STRING;
    LEVEL : LOGLEVEL := INFO;
  END_VAR
  VAR
    TRIG0 : BOOL;
  END_VAR

  IF TRIG AND NOT TRIG0 THEN
  {{
   LogMessage(GetFbVar(LEVEL),(char*)GetFbVar(MSG, .body),GetFbVar(MSG, .len));
  }}
  END_IF;
  TRIG0:=TRIG;
END_FUNCTION_BLOCK


PROGRAM Main
  VAR
    Button AT %IX0.0 : BOOL;
  END_VAR
  VAR
    Statelight : BOOL := TRUE;
  END_VAR
  VAR
    LEDG AT %QX0.0 : BOOL;
    LEDB AT %QX0.1 : BOOL;
    LEDR AT %QX0.2 : BOOL;
    LEDGu AT %QX0.3 : BOOL;
  END_VAR
  VAR
    TON0 : TON;
    OnTime : TIME := T#2s;
    TON1 : TON;
  END_VAR

  LEDB := Statelight;
  LEDR := NOT(Statelight);
  TON0(IN := Statelight, PT := OnTime);
  IF TON0.Q THEN
    Statelight := FALSE; (*reset*)
  END_IF;
  TON1(IN := NOT(Statelight), PT := OnTime);
  IF TON1.Q THEN
    Statelight := TRUE; (*set*)
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK MainTask(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM MainInstance WITH MainTask : Main;
  END_RESOURCE
END_CONFIGURATION
