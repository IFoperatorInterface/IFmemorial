Button colorBt;
Slider2D adrBt;

public class EffectController {
  private Effect effect;
  private controlP5.RadioButton sb, b;
  private int sliderLastTime;
  private int sliderTarget;
  private final Module previewModule;
  private int previewStartTime;
  int pd = 10;

  private ADRpointer[] adrPointers = new ADRpointer[4];

  EffectController() {
    effect = new Effect();
    sliderLastTime = -1;
    sliderTarget = -1;
    int x = (int) windows[1].pos.x + (int) windows[1].size.x - (int) windows[1].size.y / 2;
    int h = (int) windows[1].size.y - pd * 6;
    int y = (int) windows[1].pos.y + (int) + h + pd *2;
    previewModule = new Module(-1, x, y, h, null);
    updatePreview();
    systemView.previewTitle = new Title(new PVector(x, y + pd*2), "effect preview");

    x = int(windows[1].pos.x);
    y = int(windows[1].pos.y);
    h = int(windows[1].size.y);
    int btSize = int(h / 3);
    sb = controlP5.addRadioButton("soundModeRadioButton")
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .addItem(SoundMode.SINGLE.name(), SoundMode.SINGLE.ordinal())
      .addItem(SoundMode.CHORD.name(), SoundMode.CHORD.ordinal())
      .addItem(SoundMode.RANDOM.name(), SoundMode.RANDOM.ordinal())
      .activate(effect.soundMode.ordinal())
      .plugTo(this);

    x += (btSize + pd) * 2;
    controlP5.addSlider("noteSlider")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(1, 127)
      .setValue(effect.note)
      .plugTo(this)
      .getCaptionLabel().setVisible(false);
    controlP5.getController("noteSlider").getValueLabel().setVisible(false);
    PVector pos = new PVector(x + btSize / 2, y + h / 2);
    systemView.sliderTitles[3] = new Title(pos, "note");

    x = int(windows[2].pos.x);
    y = int(windows[2].pos.y);
    h = int(windows[2].size.y);

    btSize = int(h / 3);
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
      pos = new PVector(x + btSize / 2, y + btSize * i + btSize / 2);
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
    pos = new PVector(x + btSize / 2, y + h / 2);
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

    x = x + btSize + pd * 4;
    int w = width / 2 - pd * 4 - x - 4;
    int _x = x;
    int _y = y + pd + pd;
    int _w = w;
    int _h = h - pd * 4;
    adrBt = controlP5.addSlider2D("adrBehaviorTransition")
      .setLabelVisible(false)
      .setPosition(_x, _y)
      .setSize(_w, _h)
      .setMinMax(0, 0, 100, 100)
      .setValue(50, 0)
      .disableCrosshair()
      .plugTo(this, "adrGui");

    adrPointers[0] = new ADRpointer(new PVector(
      map(0, 0, 100, _x, _x + _w),
      map(0, 0, 100, _y + _h, _y)
    ));
    adrPointers[1] = new ADRpointer(new PVector(
      map(30, 0, 100, _x, _x + _w),
      map(100, 0, 100, _y + _h, _y)
    ));
    adrPointers[2] = new ADRpointer(new PVector(
      map(70, 0, 100, _x, _x + _w),
      map(100, 0, 100, _y + _h, _y)
    ));
    adrPointers[3] = new ADRpointer(new PVector(
      map(100, 0, 100, _x, _x + _w),
      map(0, 0, 100, _y + _h, _y)
    ));

    for (ADRpointer a: adrPointers) {
      a.x = _x;
      a.y = _y;
      a.w = _w;
      a.h = _h;
    }

    adrBt.getValueLabel().setVisible(false);
    adrBt.getCaptionLabel().setVisible(false);
    String adrTitle = "adr behavior";
    pos = new PVector(x + w / 2, y + h / 2);
    systemView.sliderTitles[2] = new Title(pos, adrTitle);

    x = int(windows[3].pos.x);
    y = int(windows[3].pos.y);
    color c = color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2]);
    controlP5.addColorWheel("ledColor", x, y, h)
      .setRGB(c)
      .plugTo(this)
      .getCaptionLabel()
      .setVisible(false);

    x = x + h + pd;
    y = y + btSize * 2;

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
    for (int i = 0; i < btTitle.length; i++)
      controlP5.getController("fieldMode" + btTitle[i] + "Toggle")
      .getCaptionLabel()
      .setVisible(false);

    controlP5.getController("fieldModeNoTitleToggle")
      .hide();
  }



  void soundModeRadioButton(int a) {
    if (a == -1)
      // Reactivate radio button if pressed same button
      sb.activate(effect.soundMode.ordinal());
    else
      // Update soundMode
      effect.soundMode = SoundMode.values()[a];
  }


  void noteSlider(int a) {
    effect.note = a;
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

  void adrGui() {
    float[] values = adrBt.getArrayValue();
    PVector position = new PVector(
      map(values[0], 0, 100, adrPointers[0].x, adrPointers[0].x + adrPointers[0].w),
      map(values[1], 100, 0, adrPointers[0].y + adrPointers[0].h, adrPointers[0].y)
    );

    boolean isNew = (frameCount - sliderLastTime) > 2;
    sliderLastTime = frameCount;

    if (isNew) {
      sliderTarget = -1;
      for (int i = 0; i < 4; i++) {
        if (adrPointers[i].pos.dist(position) < 50)
          sliderTarget = i;
      }
    }

    if (sliderTarget != -1) {
      if (sliderTarget != 0 && (position.x - adrPointers[sliderTarget - 1].pos.x < 40))
        return;
      if (sliderTarget != 3 && (position.x - adrPointers[sliderTarget + 1].pos.x > -40))
        return;

      if (sliderTarget == 1 || sliderTarget == 2) {
        adrPointers[sliderTarget].update(position);
        effect.brightness[sliderTarget][0] = (int) values[0];
        effect.brightness[sliderTarget][1] = 100 - (int) values[1];
      } else if (sliderTarget == 3) {
        adrPointers[sliderTarget].update(new PVector(position.x, adrPointers[sliderTarget].pos.y));
        effect.brightness[sliderTarget][0] = (int) values[0];
      }
    }
  }


  void ledColor(color c) {
    effect.colorRGB[0] = (int) red(c);
    effect.colorRGB[1] = (int) green(c);
    effect.colorRGB[2] = (int) blue(c);

    updatePreview();
  }


  public void updatePreview() {
    previewModule.updateTrigger(new Trigger(effect.copy(), -1, -1, frameCount));
    previewStartTime = frameCount;
  }


  public void onDraw() {
    if (frameCount >= previewStartTime + Module.MAX_DURATION * effect.brightness[3][0] / 100 + Module.MAX_DURATION)
      updatePreview();

    previewModule.draw();
  }
}

class ADRpointer {
  PVector pos;
  PVector size = new PVector(15, 15);
  int x, y, w, h;

  ADRpointer(PVector pos) {
    this.pos = pos;
  }
  void draw() {
    boolean mouseOver = mouseIsOn();
    color c = (mouseOver) ? color(0, 170, 255) : color(200);
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, size.x, size.y);
  }
  void update(PVector a) {
    pos = a;
  }

  boolean mouseIsOn() {
    boolean result = false;
    if (adrBt.isMouseOver())
      if (getDist(mouseX, mouseY, pos.x, pos.y) < size.x + 20)
        result = true;

    return result;
  }

  float getDist(float px, float py, float bx, float by) {
    float xDist = px - bx; // distance horiz
    float yDist = py - by; // distance vert
    float distance = sqrt(sq(xDist) + sq(yDist)); // diagonal distance

    return distance;
  }
}