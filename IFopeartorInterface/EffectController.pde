Button colorBt;
Slider2D adrBt;

public class EffectController {
  private Effect effect;
  private int sliderLastTime;
  private int sliderTarget;
  private int positionLastTime;
  private int positionTarget;
  private final Module previewModule;
  private int previewStartTime;
  int pd = 10;

  private ADRpointer[] adrPointers = new ADRpointer[4];

  private Button[] soundModeRadioButtons;
  private Button[] barModeRadioButtons;
  private Button[] fieldModeToggles;

  EffectController() {
    effect = new Effect();
    sliderLastTime = -1;
    sliderTarget = -1;
    positionLastTime = -1;
    positionTarget = -1;
    int x = (int) windows[1].pos.x + (int) windows[1].size.x - (int) windows[1].size.y / 2;
    int h = (int) windows[1].size.y - pd * 6;
    int y = (int) windows[1].pos.y + (int) + h + pd * 2;
    PVector pos;
    previewModule = new Module(-1, x, y, h, null);
    updatePreview();
    systemView.previewTitle = new Title(new PVector(x, y + pd * 2), "effect preview");

    soundModeRadioButtons = new Button[SoundMode.values().length];
    x = int(windows[1].pos.x);
    y = int(windows[1].pos.y);
    h = int(windows[1].size.y);
    int btSize = int(h / 3);
    for (final SoundMode s : SoundMode.values()) {
      soundModeRadioButtons[s.ordinal()] = new Button()
        .setPosition(x, y + btSize * s.ordinal())
        .setSize(btSize, btSize)
        .setBackgroundColor(0, 45, 90)
        .setName(s.name())
        .setPressListener(new ButtonPressListener() {
          public void onPress() {
            soundModeRadioButton(s.ordinal());
          }
        });
    }
    soundModeRadioButtons[effect.soundMode.ordinal()].setBackgroundColor(0, 170, 255);

    x += (btSize + pd);
    controlP5.addSlider("noteSlider")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(1, 127)
      .setValue(effect.note)
      .plugTo(this)
      .getCaptionLabel().setVisible(false);
    controlP5.getController("noteSlider").getValueLabel().setVisible(false);
    pos = new PVector(x + btSize / 2, y + h / 2);
    systemView.sliderTitles[3] = new Title(pos, "note");

    barModeRadioButtons = new Button[BarMode.values().length];
    x = int(windows[2].pos.x);
    y = int(windows[2].pos.y);
    h = int(windows[2].size.y);
    btSize = int(h / 3);
    for (final BarMode b : BarMode.values()) {
      barModeRadioButtons[b.ordinal()] = new Button()
        .setPosition(x, y + btSize * b.ordinal())
        .setSize(btSize, btSize)
        .setBackgroundColor(0, 45, 90)
        .setName(b.name())
        .setPressListener(new ButtonPressListener() {
          public void onPress() {
            barModeRadioButton(b.ordinal());
          }
        });
    }
    barModeRadioButtons[effect.barMode.ordinal()].setBackgroundColor(0, 170, 255);


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
    controlP5.addSlider("positionSlider")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .plugTo(this)
      .getCaptionLabel().setVisible(false);
    controlP5.getController("positionSlider").getValueLabel().setVisible(false);
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
      map(effect.brightness[0][0], 0, 100, _x, _x + _w),
      map(effect.brightness[0][1], 0, 100, _y + _h, _y)), 0);
    adrPointers[1] = new ADRpointer(new PVector(
      map(effect.brightness[1][0], 0, 100, _x, _x + _w),
      map(effect.brightness[1][1], 0, 100, _y + _h, _y)), 1);
    adrPointers[2] = new ADRpointer(new PVector(
      map(effect.brightness[2][0], 0, 100, _x, _x + _w),
      map(effect.brightness[2][1], 0, 100, _y + _h, _y)), 2);
    adrPointers[3] = new ADRpointer(new PVector(
      map(effect.brightness[3][0], 0, 100, _x, _x + _w),
      map(effect.brightness[3][1], 0, 100, _y + _h, _y)), 3);

    for (ADRpointer a: adrPointers) {
      a.x = _x;
      a.y = _y;
      a.w = _w;
      a.h = _h;
    }

    adrPointers[0].clickAreaL = 0.0;
    adrPointers[0].clickAreaR = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaL = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaR = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaL = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaR = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaL = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaR = _x + _w - adrPointers[3].pos.x;

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

    fieldModeToggles = new Button[FieldMode.values().length];

    x = x + h + pd;
    y = y + btSize * 2;
    FieldMode[] fieldModePosition = {
      null,
      FieldMode.UP,
      null,
      FieldMode.LEFT,
      FieldMode.DOWN,
      FieldMode.RIGHT
    };
    for (int i = 0; i < 6; i++) {
      final FieldMode f = fieldModePosition[i];
      if (f == null)
        continue;
      int baseX = int(windows[3].pos.x) + h + (pd + btSize) * 3;
      int baseY = int(windows[3].pos.y) + pd;
      x = baseX + (btSize + pd) * (i % 3);
      y = baseY + (btSize + pd) * (i / 3);
      pos = new PVector(x + btSize / 2, y + btSize / 2);
      fieldModeToggles[f.ordinal()] = new Button()
        .setPosition(x, y)
        .setSize(btSize, btSize)
        .setBackgroundColor(0, 45, 90)
        .setName(f.name())
        .setPressListener(new ButtonPressListener() {
          public void onPress() {
            fieldModeToggle(f.ordinal());
          }
        });
    }

    x = int(windows[3].pos.x) + h + (pd + btSize) * 1;
    y = int(windows[3].pos.y) + pd + (btSize + pd) * (5 / 3);
    pos = new PVector(x + btSize / 2, y + btSize / 2);
    fieldModeToggles[FieldMode.ELLIPSE.ordinal()] = new Button()
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .setBackgroundColor(0, 45, 90)
      .setName(FieldMode.ELLIPSE.name())
      .setPressListener(new ButtonPressListener() {
        public void onPress() {
          fieldModeToggle(FieldMode.ELLIPSE.ordinal());
        }
      });
  }



  void soundModeRadioButton(int a) {
    for (Button b : soundModeRadioButtons)
      b.setBackgroundColor(0, 45, 90);
    soundModeRadioButtons[a].setBackgroundColor(0, 170, 255);

    effect.soundMode = SoundMode.values()[a];

    if (effect.soundMode == SoundMode.RANDOM) {
      controlP5.getController("noteSlider").hide();
    } else {
      controlP5.getController("noteSlider").show();
    }
  }


  void noteSlider(int a) {
    effect.note = a;
  }


  void barModeRadioButton(int a) {
    for (Button b : barModeRadioButtons)
      b.setBackgroundColor(0, 45, 90);
    barModeRadioButtons[a].setBackgroundColor(0, 170, 255);

    effect.barMode = BarMode.values()[a];

    if (effect.barMode == BarMode.BOUNCE) {
      controlP5.getController("sizeSlider").show();
    } else {
      controlP5.getController("sizeSlider").hide();
    }
  }


  void sizeSlider(int a) {
    effect.size = a;
  }


  void positionSlider(int a) {
    final int MIN_DISTANCE = 20;

    boolean isNew = (frameCount - positionLastTime) > 2;
    positionLastTime = frameCount;

    if (isNew) {
      if (a < (effect.position[0] + effect.position[1]) / 2)
        positionTarget = 0;
      else
        positionTarget = 1;
    }

    if (positionTarget != -1) {
      if (positionTarget == 0) {
        if (a < effect.position[1] - MIN_DISTANCE)
          effect.position[0] = a;
      }

      if (positionTarget == 1) {
        if (a > effect.position[0] + MIN_DISTANCE)
          effect.position[1] = a;
      }
    }
  }


  void fieldModeToggle(int idx) {
    boolean newMode = !effect.fieldMode[idx];

    if (newMode == true)
      fieldModeToggles[idx].setBackgroundColor(0, 170, 255);
    else
      fieldModeToggles[idx].setBackgroundColor(0, 45, 90);

    effect.fieldMode[idx] = newMode;
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
      sliderTarget = 0;
      for (int i = 1; i < 4; i++) {
        if (position.x > (adrPointers[i - 1].pos.x + adrPointers[i].pos.x) / 2)
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
        float newX;
        int newValue;

        newX = map(position.x,
          adrPointers[0].pos.x,
          adrPointers[3].pos.x,
          adrPointers[0].pos.x,
          adrPointers[1].pos.x);
        newValue = (int) map(newX,
          adrPointers[0].x,
          adrPointers[0].x + adrPointers[0].w,
          0,
          100);
        adrPointers[1].update(new PVector(newX, adrPointers[1].pos.y));
        effect.brightness[1][0] = newValue;

        newX = map(position.x,
          adrPointers[0].pos.x,
          adrPointers[3].pos.x,
          adrPointers[0].pos.x,
          adrPointers[2].pos.x);
        newValue = (int) map(newX,
          adrPointers[0].x,
          adrPointers[0].x + adrPointers[0].w,
          0,
          100);
        adrPointers[2].update(new PVector(newX, adrPointers[2].pos.y));
        effect.brightness[2][0] = newValue;

        newX = position.x;
        newValue = (int) values[0];
        adrPointers[3].update(new PVector(newX, adrPointers[sliderTarget].pos.y));
        effect.brightness[3][0] = newValue;
      }
    }
    adrPointers[0].clickAreaL = adrBt.getPosition()[0] - adrPointers[0].pos.x;
    adrPointers[0].clickAreaR = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaL = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaR = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaL = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaR = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaL = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaR = adrBt.getPosition()[0] + adrBt.getWidth() - adrPointers[3].pos.x;
  }


  void ledColor(color c) {
    effect.colorRGB[0] = (int) red(c);
    effect.colorRGB[1] = (int) green(c);
    effect.colorRGB[2] = (int) blue(c);

    updatePreview();
  }


  public void updatePreview() {
    previewModule.addTrigger(new Trigger(effect.copy(), -1, -1, frameCount));
    previewStartTime = frameCount;
  }


  public void onDraw() {
    for (Button b : soundModeRadioButtons)
      b.draw();
    for (Button b : fieldModeToggles)
      b.draw();
    for (Button b : barModeRadioButtons)
      b.draw();


    if (frameCount >= previewStartTime + Module.MAX_DURATION * effect.brightness[3][0] / 100 + Module.MAX_DURATION)
      updatePreview();

    previewModule.draw();

    int h = int(windows[2].size.y);
    int btSize = int(h / 3);
    int x = int(windows[2].pos.x + (btSize + pd) * 2);
    int y = int(windows[2].pos.y);

    int start = (int) map(effect.position[0], 0, 100, y + h, y);
    int end = (int) map(effect.position[1], 0, 100, y + h, y);

    pushStyle();
    strokeWeight(0);
    rectMode(CORNERS);
    fill(0, 45, 90);
    rect(x, y, x + btSize, y + h);
    fill(0, 116, 217);
    rect(x, end, x + btSize, start);
    popStyle();
  }


  public void press(int x, int y) {
    for (Button b : soundModeRadioButtons)
      b.press(x, y);
    for (Button b : fieldModeToggles)
      b.press(x, y);
    for (Button b : barModeRadioButtons)
      b.press(x, y);
  }
}

class ADRpointer {
  PVector pos;
  PVector size = new PVector(15, 15);
  Float clickAreaL, clickAreaR;
  Boolean mouseOver = false;
  int x, y, w, h;
  int indx;

  ADRpointer(PVector pos, int indx) {
    this.pos = pos;
    this.indx = indx;
  }
  void draw() {
    mouseOver = mouseIsOn();
    color c = (mouseOver) ? color(0, 170, 255) : color(180);
    pushStyle();
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, size.x, size.y);
    stroke(100);
    noFill();
    rectMode(CORNERS);
    rect(pos.x - clickAreaL, y, pos.x + clickAreaR, y + h);
    popStyle();
  }
  void update(PVector a) {
    pos = a;
  }

  boolean mouseIsOn() {
    boolean result = false;
    if (pos.x - clickAreaL > mouseX && pos.x + clickAreaR < mouseX && mouseY > y && mouseY < y + h)
      result = true;
    return result;
  }
}