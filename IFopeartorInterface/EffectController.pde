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


  Effect getEffect() {
    return effect.copy();
  }
}
