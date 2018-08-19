public class PresetController {
  private int[] touchColor;
  private Effect[] effects;
  private Effect pullStartEffect, pullEndEffect;
  private Effect jumpStartEffect, jumpEndEffect, jumpFieldEffect;
  private static final int COLOR_PERIOD = 30 * 60 * 16;
  private static final int COLOR_STEPS = 360;
  private final int BT_X = int(windows[4].pos.x + 400);
  private final int BT_Y = int(windows[4].pos.y + 140);
  private final int BT_SIZE = 30;


  PresetController() {
    effects = new Effect[4];

    touchColor = new int[]{255, 0, 0};

    pullStartEffect = new Effect();
    pullStartEffect.note = -1;
    pullStartEffect.barMode = BarMode.BLINK;
    pullStartEffect.position[0] = 0;
    pullStartEffect.brightness[1] = new int[]{0, 100};
    pullStartEffect.brightness[2] = new int[]{2, 100};
    pullStartEffect.brightness[3] = new int[]{2, 0};

    pullEndEffect = new Effect();
    pullEndEffect.soundMode = SoundMode.CHORD;
    pullEndEffect.note = 75;
    pullEndEffect.barMode = BarMode.BLINK;
    pullEndEffect.position[0] = 0;
    pullEndEffect.position[1] = 100;
    pullEndEffect.spread = 75;
    pullEndEffect.noCenter = true;
    pullEndEffect.brightness[1] = new int[]{10, 100};
    pullEndEffect.brightness[2] = new int[]{55, 30};
    pullEndEffect.brightness[3] = new int[]{100, 0};

    jumpStartEffect = new Effect();
    jumpStartEffect.note = 85;
    jumpStartEffect.barMode = BarMode.BOUNCE;
    jumpStartEffect.position[0] = 0;
    jumpStartEffect.position[1] = 100;
    jumpStartEffect.brightness[1] = new int[]{20, 75};
    jumpStartEffect.brightness[2] = new int[]{60, 100};
    jumpStartEffect.brightness[3] = new int[]{65, 0};

    jumpEndEffect = new Effect();
    jumpEndEffect.note = 40;
    jumpEndEffect.barMode = BarMode.BLINK;
    jumpEndEffect.position[0] = 0;
    jumpEndEffect.position[1] = 100;
    jumpEndEffect.brightness[1] = new int[]{10, 100};
    jumpEndEffect.brightness[2] = new int[]{60, 100};
    jumpEndEffect.brightness[3] = new int[]{100, 0};

    jumpFieldEffect = new Effect();
    jumpFieldEffect.note = -1;
    jumpFieldEffect.barMode = BarMode.STRETCH;
    jumpFieldEffect.fieldMode[FieldMode.ELLIPSE.ordinal()] = true;
    jumpFieldEffect.position[0] = 0;
    jumpFieldEffect.position[1] = 100;
    jumpFieldEffect.noCenter = true;
    jumpFieldEffect.brightness[1] = new int[]{10, 100};
    jumpFieldEffect.brightness[2] = new int[]{35, 30};
    jumpFieldEffect.brightness[3] = new int[]{60, 0};

    effects[1] = pullEndEffect;
    effects[2] = jumpFieldEffect;

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

    fill(touchColor[0], touchColor[1], touchColor[2]);
    rect(x, y, size, size);

    x += size + pd;
    fill(effects[1].colorRGB[0], effects[1].colorRGB[1], effects[1].colorRGB[2]);
    rect(x, y, size, size);

    x += size + pd;
    fill(effects[2].colorRGB[0], effects[2].colorRGB[1], effects[2].colorRGB[2]);
    rect(x, y, size, size);

    popStyle();

    for (int i = 0; i < 4; i++) {
      rect(BT_X+BT_SIZE*i, BT_Y, BT_SIZE, BT_SIZE);
    }

    if (frameCount % (COLOR_PERIOD / COLOR_STEPS) != 0)
      return;

    int step = (frameCount / (COLOR_PERIOD / COLOR_STEPS)) % COLOR_STEPS;

    updateColor(step);
  }


  private void updateColor(int step) {
    color c = Color.HSBtoRGB((float)step / COLOR_STEPS, 1, 1);
    touchColor[0] = (int) red(c) + 1;
    touchColor[1] = (int) green(c) + 1;
    touchColor[2] = (int) blue(c) + 1;

    c = Color.HSBtoRGB((float)step / COLOR_STEPS + 0.05, 1, 1);
    pullStartEffect.colorRGB[0] = (int) red(c) + 1;
    pullStartEffect.colorRGB[1] = (int) green(c) + 1;
    pullStartEffect.colorRGB[2] = (int) blue(c) + 1;
    pullEndEffect.colorRGB[0] = (int) red(c) + 1;
    pullEndEffect.colorRGB[1] = (int) green(c) + 1;
    pullEndEffect.colorRGB[2] = (int) blue(c) + 1;


    c = Color.HSBtoRGB((float)step / COLOR_STEPS + 0.1, 1, 1);
    jumpStartEffect.colorRGB[0] = (int) red(c) + 1;
    jumpStartEffect.colorRGB[1] = (int) green(c) + 1;
    jumpStartEffect.colorRGB[2] = (int) blue(c) + 1;
    jumpEndEffect.colorRGB[0] = (int) red(c) + 1;
    jumpEndEffect.colorRGB[1] = (int) green(c) + 1;
    jumpEndEffect.colorRGB[2] = (int) blue(c) + 1;
    jumpFieldEffect.colorRGB[0] = (int) red(c) + 1;
    jumpFieldEffect.colorRGB[1] = (int) green(c) + 1;
    jumpFieldEffect.colorRGB[2] = (int) blue(c) + 1;
  }


  public void triggerPullStart(int x, int y, float size) {
    int barSize = (int) (size * 100);
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
    Effect effect = effects[1].copy();
    effect.direction = new PVector(-direction.x, -direction.y);
    effect.position[1] = (int) constrain(size * 100, 0, 100);

    Trigger trigger = new Trigger(effect, x, y, frameCount);
    moduleView.addTrigger(trigger);

    logger.log(Log.PULL, x, y, direction.heading(), null);
  }


  public void triggerJump(int x, int y) {
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

    int idx = (x1 - BT_X) / BT_SIZE;
    if (idx < 0 || idx >= 4)
      return;

    setEffect(idx, recordController.getPreset(x2, y2));
  }


  private void setEffect(int idx, Effect effect) {
    println(idx, effect);
    if (effect != null){
      effects[idx] = effect.copy();
      for (int i=0; i<FieldMode.values().length; i++)
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
    else {
      switch (idx) {
        case 1:
          effects[1] = pullEndEffect;
          break;
        case 2:
          effects[2] = jumpFieldEffect;
          break;
      }
    }
  }
}