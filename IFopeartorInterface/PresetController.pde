public class PresetController {
  private Effect[] effects;
  private Effect touchEffect;
  private Effect pullStartEffect, pullEndEffect;
  private Effect jumpStartEffect, jumpEndEffect, jumpFieldEffect;
  private Effect locationEffect;
  private static final int COLOR_PERIOD = 30 * 60 * 16;
  private static final int COLOR_STEPS = 360;
  private final int NUM_RECORD = 3;
  private final int PD = 4;
  private final int BT_SIZE = int(windows[4].size.y / 3 - PD);
  private final int BT_X = int(windows[4].pos.x + (BT_SIZE + PD) * (9 - NUM_RECORD) + PD);
  private final int BT_Y = int(windows[4].pos.y + PD);

  PresetController() {
    effects = new Effect[4];

    touchEffect = new Effect();

    pullStartEffect = new Effect();
    pullStartEffect.note = -1;
    pullStartEffect.barMode = BarMode.BLINK;
    pullStartEffect.position[0] = 0;
    pullStartEffect.brightness[1] = new int[] {
      0,
      100
    };
    pullStartEffect.brightness[2] = new int[] {
      2,
      100
    };
    pullStartEffect.brightness[3] = new int[] {
      2,
      0
    };

    pullEndEffect = new Effect();
    pullEndEffect.soundMode = SoundMode.CHORD;
    pullEndEffect.note = 75;
    pullEndEffect.barMode = BarMode.BLINK;
    pullEndEffect.position[0] = 0;
    pullEndEffect.position[1] = 100;
    pullEndEffect.spread = 75;
    pullEndEffect.noCenter = true;
    pullEndEffect.brightness[1] = new int[] {
      10,
      100
    };
    pullEndEffect.brightness[2] = new int[] {
      55,
      30
    };
    pullEndEffect.brightness[3] = new int[] {
      100,
      0
    };

    jumpStartEffect = new Effect();
    jumpStartEffect.note = 85;
    jumpStartEffect.barMode = BarMode.BOUNCE;
    jumpStartEffect.position[0] = 0;
    jumpStartEffect.position[1] = 100;
    jumpStartEffect.brightness[1] = new int[] {
      20,
      75
    };
    jumpStartEffect.brightness[2] = new int[] {
      60,
      100
    };
    jumpStartEffect.brightness[3] = new int[] {
      65,
      0
    };

    jumpEndEffect = new Effect();
    jumpEndEffect.note = 40;
    jumpEndEffect.barMode = BarMode.BLINK;
    jumpEndEffect.position[0] = 0;
    jumpEndEffect.position[1] = 100;
    jumpEndEffect.brightness[1] = new int[] {
      10,
      100
    };
    jumpEndEffect.brightness[2] = new int[] {
      60,
      100
    };
    jumpEndEffect.brightness[3] = new int[] {
      100,
      0
    };

    jumpFieldEffect = new Effect();
    jumpFieldEffect.note = -1;
    jumpFieldEffect.barMode = BarMode.STRETCH;
    jumpFieldEffect.fieldMode[FieldMode.ELLIPSE.ordinal()] = true;
    jumpFieldEffect.position[0] = 0;
    jumpFieldEffect.position[1] = 100;
    jumpFieldEffect.noCenter = true;
    jumpFieldEffect.brightness[1] = new int[] {
      10,
      100
    };
    jumpFieldEffect.brightness[2] = new int[] {
      35,
      30
    };
    jumpFieldEffect.brightness[3] = new int[] {
      60,
      0
    };

    locationEffect = new Effect();

    effects[0] = touchEffect;
    effects[1] = pullEndEffect;
    effects[2] = jumpFieldEffect;
    effects[3] = locationEffect;

    updateColor(0);
  }


  public void onDraw() {
    int pd = 5;
    int h = int(windows[1].size.y);
    int size = h / 10;
    int x = int(windows[1].pos.x) + size * 22 + pd;
    int y = int(windows[1].pos.y) + h - size;

    pushStyle();
    rectMode(CORNER);
    noStroke();

    for (int i=0; i<effects.length; i++) {
      if (effects[i] == null)
        continue;

      fill(effects[i].colorRGB[0], effects[i].colorRGB[1], effects[i].colorRGB[2]);
      rect(x+(size+pd)*i, y, size, size);
    }

    popStyle();

    pushStyle();
    rectMode(CORNER);
    noStroke();
    final String[] titles = new String[] {
      "TOUCH",
      "PULL",
      "JUMP",
      "LOC"
    };
    for (int i = 0; i < 4; i++) {
      fill(0, 45, 90);
      rect(BT_X + (BT_SIZE + PD) * i, BT_Y, BT_SIZE, BT_SIZE);
      fill(255);
      textAlign(CENTER, CENTER);
      textFont(titleFont);
      text(titles[i], BT_X + (BT_SIZE + PD) * i + BT_SIZE / 2, BT_Y + BT_SIZE / 2);
    }
    popStyle();

    if (frameCount % (COLOR_PERIOD / COLOR_STEPS) != 0)
      return;

    int step = (frameCount / (COLOR_PERIOD / COLOR_STEPS)) % COLOR_STEPS;

    updateColor(step);
  }


  private void updateColor(int step) {
    color c = Color.HSBtoRGB((float) step / COLOR_STEPS, 1, 1);
    touchEffect.colorRGB[0] = (int) red(c) + 1;
    touchEffect.colorRGB[1] = (int) green(c) + 1;
    touchEffect.colorRGB[2] = (int) blue(c) + 1;

    c = Color.HSBtoRGB((float) step / COLOR_STEPS + 0.05, 1, 1);
    pullEndEffect.colorRGB[0] = (int) red(c) + 1;
    pullEndEffect.colorRGB[1] = (int) green(c) + 1;
    pullEndEffect.colorRGB[2] = (int) blue(c) + 1;


    c = Color.HSBtoRGB((float) step / COLOR_STEPS + 0.1, 1, 1);
    jumpFieldEffect.colorRGB[0] = (int) red(c) + 1;
    jumpFieldEffect.colorRGB[1] = (int) green(c) + 1;
    jumpFieldEffect.colorRGB[2] = (int) blue(c) + 1;

    c = Color.HSBtoRGB((float) step / COLOR_STEPS + 0.15, 1, 1);
    locationEffect.colorRGB[0] = (int) red(c) + 1;
    locationEffect.colorRGB[1] = (int) green(c) + 1;
    locationEffect.colorRGB[2] = (int) blue(c) + 1;
  }


  public void triggerPullStart(int x, int y, float size) {
    if (effects[1] == null)
      return;

    int barSize = (int)(size * 100);
    if (barSize > 100)
      barSize = 100;

    pullStartEffect.colorRGB[0] = effects[1].colorRGB[0];
    pullStartEffect.colorRGB[1] = effects[1].colorRGB[1];
    pullStartEffect.colorRGB[2] = effects[1].colorRGB[2];
    pullStartEffect.position[1] = barSize;

    Trigger trigger = new Trigger(pullStartEffect.copy(), x, y, frameCount);
    moduleView.addTrigger(trigger);
  }


  public void triggerPullEnd(int x, int y, PVector direction, float size) {
    if (effects[1] == null)
      return;

    Effect effect = effects[1].copy();
    effect.direction = new PVector(-direction.x, -direction.y);
    effect.position[1] = (int) constrain(size * 100, 0, 100);

    Trigger trigger = new Trigger(effect, x, y, frameCount);
    moduleView.addTrigger(trigger);

    logger.log(Log.PULL, x, y, direction.heading(), null);
  }


  public void triggerJump(int x, int y) {
    if (effects[2] == null)
      return;

    jumpStartEffect.colorRGB[0] = effects[2].colorRGB[0];
    jumpStartEffect.colorRGB[1] = effects[2].colorRGB[1];
    jumpStartEffect.colorRGB[2] = effects[2].colorRGB[2];
    jumpEndEffect.colorRGB[0] = effects[2].colorRGB[0];
    jumpEndEffect.colorRGB[1] = effects[2].colorRGB[1];
    jumpEndEffect.colorRGB[2] = effects[2].colorRGB[2];

    Trigger startTrigger = new Trigger(jumpStartEffect.copy(), x, y, frameCount);
    Trigger endTrigger = new Trigger(jumpEndEffect.copy(), x, y, frameCount + 58);
    Trigger fieldTrigger = new Trigger(effects[2].copy(), x, y, frameCount + 54);
    moduleView.addTrigger(startTrigger);
    moduleView.addTrigger(endTrigger);
    moduleView.addTrigger(fieldTrigger);

    logger.log(Log.JUMP, x, y, null, null);
  }


  public void press(int x1, int y1, int x2, int y2) {
    if (y1 < BT_Y || y1 >= BT_Y + BT_SIZE)
      return;

    int idx = (x1 - BT_X) / (BT_SIZE + PD);
    if (idx < 0 || idx >= 4)
      return;

    setEffect(idx, recordController.getPreset(x2, y2));
  }


  private void resetEffect(int idx) {
    switch (idx) {
      case 0:
        effects[0] = touchEffect;
        break;
      case 1:
        effects[1] = pullEndEffect;
        break;
      case 2:
        effects[2] = jumpFieldEffect;
        break;
      case 3:
        effects[3] = locationEffect;
        break;
    }
  }


  private void setEffect(int idx, Effect effect) {
    if (effect != null && effect.id != -1) {
      effects[idx] = effect.copy();
      for (int i = 0; i < FieldMode.values().length; i++)
        effects[idx].fieldMode[i] = false;
      switch (idx) {
        case 1:
          effects[1].spread = 75;
          break;
        case 2:
          effects[2].fieldMode[FieldMode.ELLIPSE.ordinal()] = true;
          effects[2].spread = 50;
      }
    }
    else if (effect != null) {
      effects[idx] = null;
    }
    else {
      resetEffect(idx);
    }
  }


  public void unregisterPreset(Effect preset) {
    for (int i=0; i<4; i++) {
      if (effects[i] == null)
        continue;

      if (effects[i].id == preset.id){
        resetEffect(i);
      }
    }
  }
}