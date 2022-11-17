```mermaid
graph TD
    main([Start])
    --> setup{{Setup}}
    --> start(( ))
    --> adjPress{Adjust button pressed?}
    --> |Yes| rol{{Rotate LEDs left}}
    --> selPress
    adjPress
    --> |No| selPress{Selection button pressed?}
    --> |Yes| ror{{Rotate LEDs right}}
    --> start
    selPress
    --> |No| start
```

---

```mermaid
graph TD
  setup([Setup])
  --> portd[Set PORTD as output]
  --> portb[Set PORTB as input]
  --> pullupd[Enable pull-up resistors to PORTD]
  --> pullupb[Enable pull-up resistors to PORTB]
  --> off[Turn off all LEDs]
  --> return([Return])
```

---

```mermaid
graph TD
  rol([Rotate LEDs left])
  --> save{{Save current state on SRAM}}
  --> setDelay[Set delay register to 200ms]
  --> carry[Set carry to 0]
  --> loop(( ))
  --> shift[Shift LEDs to the rigth]
  --> delay{{Delay}}
  --> validation{Auxiliar Register <= 8?}
  --> |Yes| loop
  validation
  --> |No| restore{{Restore previous state from SRAM}}
  --> return([Return])
```

---

```mermaid
graph TD
  ror([Rotate LEDs right])
  --> save{{Save current state on SRAM}}
  --> setDelay[Set delay register to 1000ms]
  --> carry[Set carry to 0]
  --> loop(( ))
  --> shift[Shift LEDs to the left]
  --> delay{{Delay}}
  --> validation{Auxiliar Register <= 8?}
  --> |Yes| loop
  validation
  --> |No| restore{{Restore previous state from SRAM}}
  --> return([Return])
```

---

```mermaid
graph TD
  save([Save current state on SRAM])
  --> return([Return])
```

---

```mermaid
graph TD
  restore([Restore state from SRAM])
  --> return([Return])
```
