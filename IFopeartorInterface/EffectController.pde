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

  private ColorWheel ledColor;

  private ADRpointer[] adrPointers = new ADRpointer[4];

  private Button[] soundModeRadioButtons;
  private Button[] barModeRadioButtons;
  private Button[] fieldModeToggles;
  private Slider noteSlider;
  private Slider sizeSlider;
  private Slider positionSlider;
  private Slider spreadSlider;
  private Slider diameterSlider;
  private Graph adrGraph;

  EffectController() {
    sliderLastTime = -1;
    sliderTarget = -1;
    positionLastTime = -1;
    positionTarget = -1;
    int x = (int) windows[1].pos.x + (int) windows[1].size.x - (int) windows[1].size.y / 2;
    int h = (int) windows[1].size.y - pd * 6;
    int y = (int) windows[1].pos.y + (int) + h + pd * 2;
    PVector pos;
    previewModule = new Module(-1, x, y, h, null);
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

    x += (btSize + pd);
    noteSlider = new Slider()
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(1, 127)
      .setName("Note")
      .setChangeListener(new SliderChangeListener() {
        public void onChange(int value) {
          noteSlider(value);
        }
      });

    x += (btSize + pd) * 2;
    ledColor = controlP5.addColorWheel("ledColor", x, y, h)
      .plugTo(this);
    ledColor.getCaptionLabel()
      .setVisible(false);

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

    x = x + btSize + pd;
    sizeSlider = new Slider()
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setName("Size")
      .setChangeListener(new SliderChangeListener() {
        public void onChange(int value) {
          sizeSlider(value);
        }
      });

    x = x + btSize + pd;
    positionSlider = new Slider()
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setName("Position")
      .setChangeListener(new SliderChangeListener() {
        public void onChange(int value) {
          positionSlider(value);
        }
      });
    pos = new PVector(x + btSize / 2, y + h / 2);
    systemView.sliderTitles[0] = new Title(pos, "position");

    x = x + btSize + pd * 4;
    int w = width / 2 - pd * 4 - x - 4;
    int _x = x;
    int _y = y + pd + pd;
    int _w = w;
    int _h = h - pd * 4;
    adrGraph = new Graph()
      .setPosition(_x, _y)
      .setSize(_w, _h)
      .setMinMax(0, 0, 100, 100)
      .setValue(50, 0)
      .setChangeListener(new GraphChangeListener() {
        public void onChange(int xValue, int yValue) {
          adrGui(xValue, yValue);
        }
      });

    String adrTitle = "adr behavior";
    pos = new PVector(x + w / 2, y + h / 2);
    systemView.sliderTitles[1] = new Title(pos, adrTitle);

    x = int(windows[3].pos.x);
    y = int(windows[3].pos.y);
    h = int(windows[3].size.y);
    btSize = h / 3;

    spreadSlider = new Slider()
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setName("Spread")
      .setActive(false)
      .setChangeListener(new SliderChangeListener() {
        public void onChange(int value) {
          spreadSlider(value);
        }
      });

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
      int baseX = int(windows[3].pos.x) + (pd + btSize) * 2;
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

    x = int(windows[3].pos.x) + (pd + btSize) * 6;
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

    x += (pd + btSize);
    y = int(windows[3].pos.y);
    diameterSlider = new Slider()
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setName("Diameter")
      .setActive(false)
      .setChangeListener(new SliderChangeListener() {
        public void onChange(int value) {
          diameterSlider(value);
        }
      });


    this.effect = new Effect();
    setEffect(this.effect);
    updatePreview();
  }



  public void setEffect(Effect effect) {
    effect = effect.copy();

    soundModeRadioButton(effect.soundMode.ordinal());
    noteSlider(effect.note);
    barModeRadioButton(effect.barMode.ordinal());
    sizeSlider(effect.size);
    spreadSlider(effect.spread);
    diameterSlider(effect.diameter);

    ledColor.setRGB(color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2]));

    adrPointers[0] = new ADRpointer(new PVector(
      map(effect.brightness[0][0], 0, 100, adrGraph.pos.x, adrGraph.pos.x + adrGraph.size.x),
      map(effect.brightness[0][1], 0, 100, adrGraph.pos.y + adrGraph.size.y, adrGraph.pos.y)), 0);
    adrPointers[1] = new ADRpointer(new PVector(
      map(effect.brightness[1][0], 0, 100, adrGraph.pos.x, adrGraph.pos.x + adrGraph.size.x),
      map(effect.brightness[1][1], 0, 100, adrGraph.pos.y + adrGraph.size.y, adrGraph.pos.y)), 1);
    adrPointers[2] = new ADRpointer(new PVector(
      map(effect.brightness[2][0], 0, 100, adrGraph.pos.x, adrGraph.pos.x + adrGraph.size.x),
      map(effect.brightness[2][1], 0, 100, adrGraph.pos.y + adrGraph.size.y, adrGraph.pos.y)), 2);
    adrPointers[3] = new ADRpointer(new PVector(
      map(effect.brightness[3][0], 0, 100, adrGraph.pos.x, adrGraph.pos.x + adrGraph.size.x),
      map(effect.brightness[3][1], 0, 100, adrGraph.pos.y + adrGraph.size.y, adrGraph.pos.y)), 3);

    for (ADRpointer a: adrPointers) {
      a.x = (int) adrGraph.pos.x;
      a.y = (int) adrGraph.pos.y;
      a.w = (int) adrGraph.size.x;
      a.h = (int) adrGraph.size.y;
    }

    adrPointers[0].clickAreaL = 0.0;
    adrPointers[0].clickAreaR = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaL = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaR = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaL = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaR = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaL = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaR = adrGraph.pos.x + adrGraph.size.x - adrPointers[3].pos.x;

    for (int i=0; i<FieldMode.values().length; i++) {
      if (this.effect.fieldMode[i] != effect.fieldMode[i])
        fieldModeToggle(i);
    }

    this.effect = effect;
  }



  void soundModeRadioButton(int a) {
    for (Button b : soundModeRadioButtons)
      b.setBackgroundColor(0, 45, 90);
    soundModeRadioButtons[a].setBackgroundColor(0, 170, 255);

    effect.soundMode = SoundMode.values()[a];

    if (effect.soundMode == SoundMode.RANDOM) {
      noteSlider.setActive(false);
    } else {
      noteSlider.setActive(true);
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
      sizeSlider.setActive(true);
    } else {
      sizeSlider.setActive(false);
    }

    updatePreview();
  }


  void sizeSlider(int a) {
    effect.size = a;

    updatePreview();
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

    updatePreview();
  }


  void fieldModeToggle(int idx) {
    boolean newMode = !effect.fieldMode[idx];

    if (newMode == true)
      fieldModeToggles[idx].setBackgroundColor(0, 170, 255);
    else
      fieldModeToggles[idx].setBackgroundColor(0, 45, 90);

    effect.fieldMode[idx] = newMode;

    if (newMode == true) {
      if (idx == FieldMode.ELLIPSE.ordinal()) {
        for (FieldMode f : FieldMode.values())
          if (f != FieldMode.ELLIPSE) {
            fieldModeToggles[f.ordinal()].setBackgroundColor(0, 45, 90);
            effect.fieldMode[f.ordinal()] = false;
          }
      }
      else {
        fieldModeToggles[FieldMode.ELLIPSE.ordinal()].setBackgroundColor(0, 45, 90);
        effect.fieldMode[FieldMode.ELLIPSE.ordinal()] = false;
      }
    }

    boolean fieldModeOn = false;
    for (FieldMode f : FieldMode.values())
      if (effect.fieldMode[f.ordinal()])
        fieldModeOn = true;
    spreadSlider.setActive(fieldModeOn);

    diameterSlider.setActive(effect.fieldMode[FieldMode.ELLIPSE.ordinal()]);
  }


  Effect getEffect() {
    return effect.copy();
  }

  void adrGui(int xValue, int yValue) {
    float[] values = new float[]{xValue, 100 - yValue};
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
      if (sliderTarget != 0 && (position.x - adrPointers[sliderTarget - 1].pos.x < 20))
        return;
      if (sliderTarget != 3 && (position.x - adrPointers[sliderTarget + 1].pos.x > -20))
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
    adrPointers[0].clickAreaL = adrGraph.pos.x - adrPointers[0].pos.x;
    adrPointers[0].clickAreaR = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaL = (adrPointers[1].pos.x - adrPointers[0].pos.x) / 2;
    adrPointers[1].clickAreaR = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaL = (adrPointers[2].pos.x - adrPointers[1].pos.x) / 2;
    adrPointers[2].clickAreaR = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaL = (adrPointers[3].pos.x - adrPointers[2].pos.x) / 2;
    adrPointers[3].clickAreaR = adrGraph.pos.x + adrGraph.size.x - adrPointers[3].pos.x;

    updatePreview();
  }


  void ledColor(color c) {
    effect.colorRGB[0] = (int) red(c);
    effect.colorRGB[1] = (int) green(c);
    effect.colorRGB[2] = (int) blue(c);

    updatePreview();
  }


  void spreadSlider(int value) {
    effect.spread = value;
  }


  void diameterSlider(int value) {
    effect.diameter = value;
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

    noteSlider.draw();
    sizeSlider.draw();
    positionSlider.draw();
    spreadSlider.draw();
    diameterSlider.draw();

    adrGraph.draw();


    if (frameCount >= previewStartTime + Module.MAX_DURATION * effect.brightness[3][0] / 100 + 15)
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


  public void mousePressed() {
    noteSlider.mousePressed();
    sizeSlider.mousePressed();
    positionSlider.mousePressed();
    spreadSlider.mousePressed();
    diameterSlider.mousePressed();

    adrGraph.mousePressed();
  }


  public void mouseReleased() {
    noteSlider.mouseReleased();
    sizeSlider.mouseReleased();
    positionSlider.mouseReleased();
    spreadSlider.mouseReleased();
    diameterSlider.mouseReleased();

    adrGraph.mouseReleased();
  }


  public void press(int x, int y) {
    for (Button b : soundModeRadioButtons)
      b.press(x, y);
    for (Button b : fieldModeToggles)
      b.press(x, y);
    for (Button b : barModeRadioButtons)
      b.press(x, y);
  }


  public void press(int x1, int y1, int x2, int y2) {
    for (Button b : soundModeRadioButtons)
      b.press(x1, y1, x2, y2);
    for (Button b : fieldModeToggles)
      b.press(x1, y1, x2, y2);
    for (Button b : barModeRadioButtons)
      b.press(x1, y1, x2, y2);
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