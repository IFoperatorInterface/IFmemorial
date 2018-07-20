class EffectController {
  private Effect effect;


  EffectController() {
    effect = new Effect();

    controlP5.addRadioButton("barModeRadioButton")
      .setPosition(50/SCALE, 300/SCALE)
      .setSize(100/SCALE, 100/SCALE)
      .addItem("Bounce", 1)
      .addItem("Blink", 2)
      .addItem("Stretch", 3)
      .activate(0);

    controlP5.addSlider("sizeSlider")
      .setPosition(300/SCALE, 300/SCALE)
      .setSize(500/SCALE, 100/SCALE)
      .setRange(0, 100)
      .setValue(50);

    controlP5.addRange("positionRange")
      .setPosition(300/SCALE, 500/SCALE)
      .setSize(500/SCALE, 100/SCALE)
      .setRange(0, 100)
      .setRangeValues(0, 100);
  }
}
