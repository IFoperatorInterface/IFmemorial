public class PresetController {
  private Effect[] effects;
  private Effect touchEffect;
  private Effect pullStartEffect, pullEndEffect;
  private Effect jumpStartEffect, jumpEndEffect, jumpFieldEffect;
  private Effect moveEffect;
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

    pullEndEffect = new Effect();

    jumpStartEffect = new Effect();

    jumpEndEffect = new Effect();

    jumpFieldEffect = new Effect();

    moveEffect = new Effect();

    effects[0] = touchEffect;
    effects[1] = pullEndEffect;
    effects[2] = jumpFieldEffect;
    effects[3] = moveEffect;
  }


  public void onDraw() {
    if (frameCount % (COLOR_PERIOD / COLOR_STEPS) != 0)
      return;

    int step = (frameCount / (COLOR_PERIOD / COLOR_STEPS)) % COLOR_STEPS;
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
    moveEffect.colorRGB[0] = (int) red(c) + 1;
    moveEffect.colorRGB[1] = (int) green(c) + 1;
    moveEffect.colorRGB[2] = (int) blue(c) + 1;
  }


  public void triggerPullStart(int x, int y, float size) {
    if (effects[1] == null)
      return;

    moduleView.pullStart(x, y);
  }


  public void triggerPullEnd(int x, int y, PVector direction, float size) {
    if (effects[1] == null)
      return;

    moduleView.pullEnd(x, y);
    Trigger trigger = new Trigger(pullEndEffect.copy(), x, y, frameCount);
    moduleView.addTrigger(trigger);
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
        effects[3] = moveEffect;
        break;
    }
  }


  private void setEffect(int idx, Effect effect) {
    if (effect != null && effect.id != -1) {
      effects[idx] = effect.copy();
      switch (idx) {
        case 1:
          for (int i = 0; i < FieldMode.values().length; i++)
            effects[idx].fieldMode[i] = false;
          effects[1].spread = 75;
          break;
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