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
    OnTime : TIME := T#10s;
    OldState : BOOL;
    ButtonTimerState : BOOL := FALSE;
    TON1 : TON;
    ButtonTimer : TIME := T#80s;
    ButtonState : BOOL := FALSE;
    ButtonLightState : BOOL := FALSE;
    TON2 : TON;
    TON3 : TON;
  END_VAR

  LEDB := Statelight AND NOT(ButtonLightState);
  LEDR := NOT(Statelight) AND NOT(ButtonLightState);
  TON0(IN := Statelight AND NOT(ButtonLightState), PT := OnTime);
  IF TON0.Q THEN
    Statelight := FALSE; (*reset*)
  END_IF;
  TON1(IN := NOT(Statelight) AND NOT(ButtonLightState), PT := OnTime);
  IF TON1.Q THEN
    Statelight := TRUE; (*set*)
  END_IF;
  IF Button AND NOT(ButtonTimerState) THEN
    ButtonState := TRUE; (*set*)
  END_IF;
  LEDG := ButtonLightState;
  TON2(IN := LEDG, PT := OnTime);
  IF TON2.Q THEN
    ButtonState := FALSE; (*reset*)
  END_IF;
  IF TON2.Q THEN
    ButtonLightState := FALSE; (*reset*)
  END_IF;
  IF ButtonState AND TON0.Q THEN
    ButtonLightState := TRUE; (*set*)
  END_IF;
  IF ButtonState AND TON1.Q THEN
    ButtonLightState := TRUE; (*set*)
  END_IF;
  IF NOT(OldState) AND Statelight AND TON2.Q THEN
    Statelight := TRUE; (*set*)
  END_IF;
  IF OldState AND Statelight AND TON2.Q THEN
    Statelight := FALSE; (*reset*)
  END_IF;
  OldState := Statelight AND TON2.Q;
  TON3(IN := ButtonTimerState, PT := ButtonTimer);
  IF TON3.Q THEN
    ButtonTimerState := FALSE; (*reset*)
  END_IF;
  IF TON2.Q THEN
    ButtonTimerState := TRUE; (*set*)
  END_IF;
  LEDGu := ButtonTimerState;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK MainTask(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM MainInstance WITH MainTask : Main;
  END_RESOURCE
END_CONFIGURATION
