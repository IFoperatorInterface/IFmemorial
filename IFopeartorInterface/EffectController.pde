Button colorBt;
Slider2D[] adrBt = new Slider2D[2];

public class EffectController {
  private Effect effect;
  private controlP5.RadioButton b;

  private ADRpointer[] adrPointers = new ADRpointer[4];

  EffectController() {
    effect = new Effect();

    int x = int(windows[2].pos.x);
    int y = int(windows[2].pos.y);
    int h = int(windows[2].size.y);
    int pd = 10;
    int btSize = int(h / 3);
    String[] titles = {
      "Bounce",
      "Blink",
      "Stretch"
    };
    b = controlP5.addRadioButton("barModeRadioButton")
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .addItem(titles[0], BarMode.BOUNCE.ordinal())
      .addItem(titles[1], BarMode.BLINK.ordinal())
      .addItem(titles[2], BarMode.STRETCH.ordinal())
      .activate(effect.barMode.ordinal())
      .plugTo(this);



    for (int i = 0; i < titles.length; i++) {
      PVector pos = new PVector(x + btSize / 2, y + btSize * i + btSize / 2);
      systemView.ledBehaviorTiltles[i] = new Title(pos, titles[i]);
      b.getController(titles[i]).getCaptionLabel().setVisible(false);
    }


    x = x + btSize + pd;
    controlP5.addSlider("sizeSlider")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setValue(effect.size)
      .plugTo(this)
      .getCaptionLabel().setVisible(false);
    controlP5.getController("sizeSlider").getValueLabel().setVisible(false);
    PVector pos = new PVector(x + btSize / 2, y + h / 2);
    systemView.sliderTitles[0] = new Title(pos, "size");

    x = x + btSize + pd;
    controlP5.addRange("positionRange")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setRangeValues(effect.position[0], effect.position[1])
      .plugTo(this)
      .getCaptionLabel().setVisible(false);
    pos = new PVector(x + btSize / 2, y + h / 2);
    systemView.sliderTitles[1] = new Title(pos, "position");

    x = x + btSize + pd;
    int w = width / 2 - pd - x - 4;
    for (int i = 0; i < adrBt.length; i++) {
      int _x = x + w / 2 * i;
      int _y = y;
      int _w = w / 2;
      int _h = h - pd - 1;
      adrBt[i] = controlP5.addSlider2D("adrBehaviorTransition" + i)
        .setLabelVisible(false)
        .setPosition(_x, _y)
        .setSize(_w, _h)
        .setMinMax(0, 0, 100, 100)
        .setValue(50, 0)
        .disableCrosshair()
        .plugTo(this, "adrGui");
      adrPointers[i] = new ADRpointer(new PVector(_x + 50, _y + 50));
      int _bX = (i > 0) ? _x + _w : _x;
      adrPointers[i + 2] = new ADRpointer(new PVector(_bX, _h + _y));

      adrBt[i].getValueLabel().setVisible(false);
      adrBt[i].getCaptionLabel().setVisible(false);
    }
    String adrTitle = "adr behavior";
    pos = new PVector(x + pd + textWidth(adrTitle) / 2, y + pd);
    systemView.sliderTitles[2] = new Title(pos, adrTitle);



    controlP5.addSlider("adrBehaviorTime")
      .setPosition(x, y + h - 10)
      .setWidth(w)
      .setRange(10, 100)
      .setValue(100)
      .setNumberOfTickMarks(20)
      .setSliderMode(Slider.FLEXIBLE)
      .showTickMarks(false)
      .plugTo(this, "adrBehavior");
    controlP5.getController("adrBehaviorTime").getCaptionLabel().setVisible(false);
    controlP5.getController("adrBehaviorTime").getValueLabel().setVisible(false);

    x = int(windows[3].pos.x);
    y = int(windows[3].pos.y);
    color c = color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2]);
    controlP5.addColorWheel("ledColor", x, y, h).setRGB(c).plugTo(this);

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
      "NoTitle",
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
      pos = new PVector(x + btSize / 2, y + btSize / 2);
      systemView.fieldDirectionTitles[i] = new Title(pos, btTitle[i]);
      controlP5.addToggle("fieldMode" + btTitle[i] + "Toggle")
        .setPosition(x, y)
        .setSize(btSize, btSize)
        .setCaptionLabel(btTitle[i])
        .plugTo(this, "fieldModeToggle");
    }
    controlP5.getController("fieldModeNoTitleToggle").hide();
    controlP5.getController("fieldModeUpToggle").getCaptionLabel().setVisible(false);
    controlP5.getController("fieldModeEllipseToggle").getCaptionLabel().setVisible(false);
    controlP5.getController("fieldModeLeftToggle").getCaptionLabel().setVisible(false);
    controlP5.getController("fieldModeDownToggle").getCaptionLabel().setVisible(false);
    controlP5.getController("fieldModeRightToggle").getCaptionLabel().setVisible(false);

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

  //FIXME:time 축으로 변화 있을 시 각 점의 비율은 그대로인 상태 유지하기
  void adrBehavior() {
    int w = (int) controlP5.getController("adrBehaviorTime").getWidth();
    int pos0 = (int) controlP5.getController("adrBehaviorTransition0").getPosition()[0];
    int w0 = (int) controlP5.getController("adrBehaviorTransition0").getWidth();
    int areaWidth = (int) map(controlP5.getController("adrBehaviorTime").getValue(), 10, 100, 40, w);

    for (int i = 0; i < adrBt.length; i++) {
      if (i == 1) {
        controlP5.getController("adrBehaviorTransition1").setPosition(w0 + pos0, int(windows[2].pos.y));
      }
      controlP5.getController("adrBehaviorTransition" + i).setSize(areaWidth / 2, controlP5.getController("adrBehaviorTransition" + i).getHeight());

    }

    float as = map(adrBt[0].getArrayValue()[0], 0, 100, 0, controlP5.getController("adrBehaviorTransition0").getWidth());
    // float df = map(adrBt[0].getArrayValue()[1], 0, 100, 0, controlP5.getController("adrBehaviorTransition0").getHeight());
    adrBt[0].setCursorX(as);
    // adrBt[0].setCursorX(df);
    // print(adrBt[1].getCursorX(), normalTime * adrBt[1].getCursorX(), "/");
    // println(normalTime, w0, (int) controlP5.getController("adrBehaviorTransition0").getWidth(), controlP5.getController("adrBehaviorTime").getValue());

    //==============update cursor position to ADRpointer============================
    float x = map(controlP5.getController("adrBehaviorTime").getValue(), 10, 100, 40, controlP5.getController("adrBehaviorTime").getWidth());
    float baseX = controlP5.getController("adrBehaviorTime").getPosition()[0];
    float y = controlP5.getController("adrBehaviorTime").getPosition()[1];
    PVector pos = new PVector(x + baseX, y);
    adrPointers[3].update(pos);
  }
  void adrGui() {
    PVector[] pos = new PVector[2];
    for (int i = 0; i < adrBt.length; i++) {
      float baseX = map(adrBt[i].getArrayValue()[0], 0, 100, 0, controlP5.getController("adrBehaviorTransition" + i).getWidth());
      float baseY = map(adrBt[i].getArrayValue()[1], 0, 100, 0, controlP5.getController("adrBehaviorTransition" + i).getHeight());
      float x = controlP5.getController("adrBehaviorTransition" + i).getPosition()[0];
      float y = controlP5.getController("adrBehaviorTransition" + i).getPosition()[1];
      pos[i] = new PVector(baseX + x, baseY + y);
      adrPointers[i].update(pos[i]);
    }
  }


  void ledColor(color c) {
    effect.colorRGB[0] = (int) red(c);
    effect.colorRGB[1] = (int) green(c);
    effect.colorRGB[2] = (int) blue(c);
  }
}
public void applyC() {
  color c = controlP5.get(ColorWheel.class, "ledColor").getRGB();
  controlP5.getController("applyC").setColorForeground(lerpColor(c, color(255), .2));
  controlP5.getController("applyC").setColorBackground(c);
  controlP5.getController("applyC").setColorActive(lerpColor(c, color(0), .2));
}

class ADRpointer {
  PVector pos;
  int size = 20;
  ADRpointer(PVector pos) {
    this.pos = pos;
  }
  void draw() {
    noStroke();
    fill(200);
    ellipse(pos.x, pos.y, size, size);
  }
  void update(PVector a) {
    pos = a;
  }
}