public class EffectController {
  private Effect effect;
  private controlP5.RadioButton b;


  EffectController() {
    effect = new Effect();

    int x = int(windows[2].pos.x);
    int y = int(windows[2].pos.y);
    int h = int(windows[2].size.y);
    int pd = 10;
    int btSize = int(h / 3);
    b = controlP5.addRadioButton("barModeRadioButton")
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .addItem("Bounce", BarMode.BOUNCE.ordinal())
      .addItem("Blink", BarMode.BLINK.ordinal())
      .addItem("Stretch", BarMode.STRETCH.ordinal())
      .activate(effect.barMode.ordinal())
      .plugTo(this);

    x = x + btSize + pd;
    controlP5.addSlider("sizeSlider")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setValue(effect.size)
      .plugTo(this);

    x = x + btSize + pd;
    controlP5.addRange("positionRange")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setRangeValues(effect.position[0], effect.position[1])
      .plugTo(this);

    x = x + btSize + pd;
    //TODO: behavior chart add

    x = int(windows[3].pos.x);
    y = int(windows[3].pos.y);
    color c = color(128, 0, 255);
    controlP5.addColorWheel("ledColor", x, y, h).setRGB(c);

    x = x + h + pd;
    y = y + btSize * 2;
    controlP5.addButton("applyC")
      .setValue(c)
      .setPosition(x, y)
      .setCaptionLabel("apply color")
      .setSize(btSize, btSize);

    String[] btMode = {
      "fieldModeLeftToggle",
      "fieldModeDownToggle",
      "fieldModeRightToggle",
      "fieldModeUpToggle"
    };
    String[] btTitle = {
      "left",
      "down",
      "right",
      "up"
    };

    for (int i = 0; i < btTitle.length; i++) {
      int baseX = int(windows[3].pos.x) + h + (pd + btSize) * 3;
      int baseY = int(windows[3].pos.y);
      x = (i < btTitle.length - 1) ? baseX + (btSize + pd) * i : baseX + (btSize + pd);
      y = (i < btTitle.length - 1) ? baseY + btSize + 1 : baseY;
      controlP5.addToggle(btMode[i])
        .setPosition(x, y)
        .setSize(btSize, btSize)
        .setCaptionLabel(btTitle[i])
        .plugTo(this, "fieldModeToggle");
    }
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