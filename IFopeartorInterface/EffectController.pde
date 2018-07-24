Button colorBt;
Slider2D adrBt;

public class EffectController {
  private Effect effect;
  private controlP5.RadioButton b;
  private int sliderLastTime;
  private int sliderTarget;
  private final Module previewModule;
  private int previewStartTime;

  private ADRpointer[] adrPointers = new ADRpointer[4];

  EffectController() {
    effect = new Effect();
    sliderLastTime = -1;
    sliderTarget = -1;
    previewModule = new Module(-1,
                               (int)windows[1].pos.x + (int)windows[1].size.x - (int)windows[1].size.y/2,
                               (int)windows[1].pos.y + (int)windows[1].size.y,
                               (int)windows[1].size.y,
                               null);
    updatePreview();

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
    int _x = x;
    int _y = y;
    int _w = w;
    int _h = h - pd - 11;
    adrBt = controlP5.addSlider2D("adrBehaviorTransition")
      .setLabelVisible(false)
      .setPosition(_x, _y)
      .setSize(_w, _h)
      .setMinMax(0, 0, 100, 100)
      .setValue(50, 0)
      .disableCrosshair()
      .plugTo(this, "adrGui");

    adrPointers[0] = new ADRpointer(new PVector(map(0, 0, 100, _x, _x+_w),
                                                map(0, 0, 100, _y+_h, _y)));
    adrPointers[1] = new ADRpointer(new PVector(map(30, 0, 100, _x, _x+_w),
                                                map(100, 0, 100, _y+_h, _y)));
    adrPointers[2] = new ADRpointer(new PVector(map(70, 0, 100, _x, _x+_w),
                                                map(100, 0, 100, _y+_h, _y)));
    adrPointers[3] = new ADRpointer(new PVector(map(100, 0, 100, _x, _x+_w),
                                                map(0, 0, 100, _y+_h, _y)));

    for (ADRpointer a : adrPointers) {
      a.x = _x;
      a.y = _y;
      a.w = _w;
      a.h = _h;
    }

    adrBt.getValueLabel().setVisible(false);
    adrBt.getCaptionLabel().setVisible(false);
    String adrTitle = "adr behavior";
    pos = new PVector(x + pd + textWidth(adrTitle) / 2, y + pd);
    systemView.sliderTitles[2] = new Title(pos, adrTitle);

    x = int(windows[3].pos.x);
    y = int(windows[3].pos.y);
    color c = color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2]);
    controlP5.addColorWheel("ledColor", x, y, h).setRGB(c).plugTo(this).getCaptionLabel().setVisible(false);

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
    for (int i = 0; i < btTitle.length; i++) 
      controlP5.getController("fieldMode" +btTitle[i] + "Toggle").getCaptionLabel().setVisible(false);
    
    controlP5.getController("fieldModeNoTitleToggle").hide();
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
    PVector position = new PVector(map(values[0], 0, 100, adrPointers[0].x, adrPointers[0].x+adrPointers[0].w),
                                   map(values[1], 100, 0, adrPointers[0].y+adrPointers[0].h, adrPointers[0].y));

    boolean isNew = (frameCount - sliderLastTime) > 2;
    sliderLastTime = frameCount;

    if (isNew) {
      sliderTarget = -1;
      for (int i=0; i<4; i++) {
        if (adrPointers[i].pos.dist(position) < 40)
          sliderTarget = i;
      }
    }
    
    if (sliderTarget != -1) {
      if (sliderTarget != 0 && (position.x - adrPointers[sliderTarget-1].pos.x < 40))
        return;
      if (sliderTarget != 3 && (position.x - adrPointers[sliderTarget+1].pos.x > -40))
        return;
      
      if (sliderTarget == 1 || sliderTarget == 2) {
        adrPointers[sliderTarget].update(position);
        effect.brightness[sliderTarget][0] = (int) values[0];
        effect.brightness[sliderTarget][1] = 100 - (int) values[1];
      }
      else if (sliderTarget == 3) {
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
public void applyC() {
  color c = controlP5.get(ColorWheel.class, "ledColor").getRGB();
  controlP5.getController("applyC").setColorForeground(lerpColor(c, color(255), .2));
  controlP5.getController("applyC").setColorBackground(c);
  controlP5.getController("applyC").setColorActive(lerpColor(c, color(0), .2));
}

class ADRpointer {
  PVector pos;
  int size = 20;
  int x, y, w, h;
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