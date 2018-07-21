public class EffectController {
  private Effect effect;
  private controlP5.RadioButton b;


  EffectController() {
    effect = new Effect();

    b = controlP5.addRadioButton("barModeRadioButton")
      .setPosition(50/SCALE, 300/SCALE)
      .setSize(100/SCALE, 100/SCALE)
      .addItem("Bounce", BarMode.BOUNCE.ordinal())
      .addItem("Blink", BarMode.BLINK.ordinal())
      .addItem("Stretch", BarMode.STRETCH.ordinal())
      .activate(effect.barMode.ordinal())
      .plugTo(this)
      ;

    controlP5.addSlider("sizeSlider")
      .setPosition(300/SCALE, 300/SCALE)
      .setSize(500/SCALE, 100/SCALE)
      .setRange(0, 100)
      .setValue(effect.size)
      .plugTo(this)
      ;

    controlP5.addRange("positionRange")
      .setPosition(300/SCALE, 500/SCALE)
      .setSize(500/SCALE, 100/SCALE)
      .setRange(0, 100)
      .setRangeValues(effect.position[0], effect.position[1])
      .plugTo(this)
      ;

    controlP5.addToggle("fieldModeUpToggle")
      .setPosition(400/SCALE, 700/SCALE)
      .setSize(90/SCALE, 90/SCALE)
      .plugTo(this, "fieldModeToggle")
      ;

    controlP5.addToggle("fieldModeDownToggle")
      .setPosition(400/SCALE, 800/SCALE)
      .setSize(90/SCALE, 90/SCALE)
      .plugTo(this, "fieldModeToggle")
      ;

    controlP5.addToggle("fieldModeLeftToggle")
      .setPosition(300/SCALE, 800/SCALE)
      .setSize(90/SCALE, 90/SCALE)
      .plugTo(this, "fieldModeToggle")
      ;

    controlP5.addToggle("fieldModeRightToggle")
      .setPosition(500/SCALE, 800/SCALE)
      .setSize(90/SCALE, 90/SCALE)
      .plugTo(this, "fieldModeToggle")
      ;
  }



  void barModeRadioButton(int a) {
    if (a == -1)
      // Reactivate radio button if pressed same button
      b.activate(effect.barMode.ordinal());
    else
      // Update barMode
      effect.barMode = BarMode.values()[a];
  }


  void sizeSlider(int a) {
    effect.size = a;
  }


  void positionRange(ControlEvent theEvent) {
    effect.position[0] = (int) theEvent.getArrayValue()[0];
    effect.position[1] = (int) theEvent.getArrayValue()[1];
  }


  void fieldModeToggle(ControlEvent theEvent) {
    int idx = -1;

    if (theEvent.isFrom("fieldModeUpToggle"))
      idx = FieldMode.UP.ordinal();
    else if (theEvent.isFrom("fieldModeDownToggle"))
      idx = FieldMode.DOWN.ordinal();
    else if (theEvent.isFrom("fieldModeLeftToggle"))
      idx = FieldMode.LEFT.ordinal();
    else if (theEvent.isFrom("fieldModeRightToggle"))
      idx = FieldMode.RIGHT.ordinal();

    if (idx != -1)
      effect.fieldMode[idx] = theEvent.getValue() != 0.0;
  }


  Effect getEffect() {
    return effect.copy();
  }
}
