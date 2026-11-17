void LOGGER_init__(LOGGER *data__, BOOL retain) {
  __INIT_VAR(data__->EN,__BOOL_LITERAL(TRUE),retain)
  __INIT_VAR(data__->ENO,__BOOL_LITERAL(TRUE),retain)
  __INIT_VAR(data__->TRIG,__BOOL_LITERAL(FALSE),retain)
  __INIT_VAR(data__->MSG,__STRING_LITERAL(0,""),retain)
  __INIT_VAR(data__->LEVEL,LOGLEVEL__INFO,retain)
  __INIT_VAR(data__->TRIG0,__BOOL_LITERAL(FALSE),retain)
}

// Code part
void LOGGER_body__(LOGGER *data__) {
  // Control execution
  if (!__GET_VAR(data__->EN)) {
    __SET_VAR(data__->,ENO,,__BOOL_LITERAL(FALSE));
    return;
  }
  else {
    __SET_VAR(data__->,ENO,,__BOOL_LITERAL(TRUE));
  }
  // Initialise TEMP variables

  if ((__GET_VAR(data__->TRIG,) && !(__GET_VAR(data__->TRIG0,)))) {
    #define GetFbVar(var,...) __GET_VAR(data__->var,__VA_ARGS__)
    #define SetFbVar(var,val,...) __SET_VAR(data__->,var,__VA_ARGS__,val)

   LogMessage(GetFbVar(LEVEL),(char*)GetFbVar(MSG, .body),GetFbVar(MSG, .len));
  
    #undef GetFbVar
    #undef SetFbVar
;
  };
  __SET_VAR(data__->,TRIG0,,__GET_VAR(data__->TRIG,));

  goto __end;

__end:
  return;
} // LOGGER_body__() 





void MAIN_init__(MAIN *data__, BOOL retain) {
  __INIT_LOCATED(BOOL,__IX0_0,data__->BUTTON,retain)
  __INIT_LOCATED_VALUE(data__->BUTTON,__BOOL_LITERAL(FALSE))
  __INIT_VAR(data__->STATELIGHT,__BOOL_LITERAL(TRUE),retain)
  __INIT_LOCATED(BOOL,__QX0_0,data__->LEDG,retain)
  __INIT_LOCATED_VALUE(data__->LEDG,__BOOL_LITERAL(FALSE))
  __INIT_LOCATED(BOOL,__QX0_1,data__->LEDB,retain)
  __INIT_LOCATED_VALUE(data__->LEDB,__BOOL_LITERAL(FALSE))
  __INIT_LOCATED(BOOL,__QX0_2,data__->LEDR,retain)
  __INIT_LOCATED_VALUE(data__->LEDR,__BOOL_LITERAL(FALSE))
  __INIT_LOCATED(BOOL,__QX0_3,data__->LEDGU,retain)
  __INIT_LOCATED_VALUE(data__->LEDGU,__BOOL_LITERAL(FALSE))
  TON_init__(&data__->TON0,retain);
  __INIT_VAR(data__->ONTIME,__time_to_timespec(1, 0, 2, 0, 0, 0),retain)
  TON_init__(&data__->TON1,retain);
}

// Code part
void MAIN_body__(MAIN *data__) {
  // Initialise TEMP variables

  __SET_LOCATED(data__->,LEDB,,__GET_VAR(data__->STATELIGHT,));
  __SET_LOCATED(data__->,LEDR,,!(__GET_VAR(data__->STATELIGHT,)));
  __SET_VAR(data__->TON0.,IN,,__GET_VAR(data__->STATELIGHT,));
  __SET_VAR(data__->TON0.,PT,,__GET_VAR(data__->ONTIME,));
  TON_body__(&data__->TON0);
  if (__GET_VAR(data__->TON0.Q,)) {
    __SET_VAR(data__->,STATELIGHT,,__BOOL_LITERAL(FALSE));
  };
  __SET_VAR(data__->TON1.,IN,,!(__GET_VAR(data__->STATELIGHT,)));
  __SET_VAR(data__->TON1.,PT,,__GET_VAR(data__->ONTIME,));
  TON_body__(&data__->TON1);
  if (__GET_VAR(data__->TON1.Q,)) {
    __SET_VAR(data__->,STATELIGHT,,__BOOL_LITERAL(TRUE));
  };

  goto __end;

__end:
  return;
} // MAIN_body__() 





