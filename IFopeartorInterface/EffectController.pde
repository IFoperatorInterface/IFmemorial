Button colorBt;
Slider2D[] adrBt = new Slider2D[2];
Slider2D dddd;

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
    //TODO: 
    int w = width / 2 - pd - x - 4;
    for (int i = 0; i < adrBt.length; i++) {
      adrBt[i] = controlP5.addSlider2D("adrBehaviorTransition" + i)
        .setLabelVisible(false)
        .setPosition(x + w / 2 * i, y)
        .setSize(w / 2, h - pd - 1)
        .setMinMax(0, 0, 100, 100)
        .setValue(50, 50)
        .disableCrosshair();
    }
    controlP5.addSlider("adrBehaviorTime")
      .setPosition(x, y + h - 10)
      .setWidth(w)
      .setRange(0, 100)
      .setValue(100)
      .setNumberOfTickMarks(20)
      .setSliderMode(Slider.FLEXIBLE)
      .plugTo(this, "adrBehavior");

    x = int(windows[3].pos.x);
    y = int(windows[3].pos.y);
    color c = color(128, 0, 255);
    controlP5.addColorWheel("ledColor", x, y, h).setRGB(c);

    x = x + h + pd;
    y = y + btSize * 2;
    colorBt = controlP5.addButton("applyC")
      .setValue(c)
      .setPosition(x, y)
      .setColorBackground(c)
      .setColorForeground(lerpColor(c, color(255), .2))
      .setColorActive(lerpColor(c, color(0), .2))
      .setCaptionLabel("apply color")
      .setSize(btSize, btSize);

    String[] btTitle = {
      null,
      "Up",
      "Ellipse",
      "Left",
      "Down",
      "Right"
    };
    for (int i = 5; i >= 0; i--) {
      if (btTitle[i] == null)
        continue;
      int baseX = int(windows[3].pos.x) + h + (pd + btSize) * 3;
      int baseY = int(windows[3].pos.y);
      x = baseX + (btSize + pd) * (i % 3);
      y = baseY + (btSize + 1) * (i / 3);
      controlP5.addToggle("fieldMode"+btTitle[i]+"Toggle")
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
    else if (theEvent.isFrom("fieldModeEllipseToggle"))
      idx = FieldMode.ELLIPSE.ordinal();

    if (idx != -1)
      effect.fieldMode[idx] = theEvent.getValue() != 0.0;
  }


  Effect getEffect() {
    return effect.copy();
  }

  void adrBehavior() {
    int w = (int) controlP5.getController("adrBehaviorTime").getWidth();
    int pos0 = (int) controlP5.getController("adrBehaviorTransition0").getPosition()[0];
    int w0 = (int) controlP5.getController("adrBehaviorTransition0").getWidth();
    int areaWidth = (int) map(controlP5.getController("adrBehaviorTime").getValue(), 0, 100, 0, w);

    controlP5.getController("adrBehaviorTransition1").setPosition(w0 + pos0, int(windows[2].pos.y));
    for (int i = 0; i < adrBt.length; i++) {
      controlP5.getController("adrBehaviorTransition" + i).setSize(areaWidth / 2, int(windows[2].size.y) - 10);
      // int cursorX = (int)map(controlP5.getController("adrBehaviorTransition" + i).getWidth(), 0, 228, 0, 100);
      // int cursorX = (int) map(areaWidth * adrBt[i].getCursorX() / w, 0, 228, 0, 100);
      // int cursorX = 
      // adrBt[i].setCursorX(cursorX);
      // int cursorX =(int)adrBt[i].getCursorX()*(int)controlP5.getController("adrBehaviorTime").getValue()/100;
      adrBt[i].setCursorX(cursorX);
    }
  
  // println(controlP5.getController("adrBehaviorTime").getAbsolutePosition()[1]);
  }

}
public void applyC() {
  color c = controlP5.get(ColorWheel.class, "ledColor").getRGB();
  controlP5.getController("applyC").setColorForeground(lerpColor(c, color(255), .2));
  controlP5.getController("applyC").setColorBackground(c);
  controlP5.getController("applyC").setColorActive(lerpColor(c, color(0), .2));
  ledColor = c;
}