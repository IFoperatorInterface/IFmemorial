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


  public void triggerPullStart(int x, int y, float size) {
    if (effects[1] == null)
      return;

    moduleView.pullStart(x, y);
  }


  public void triggerPullEnd(int x, int y, PVector direction, float size) {
    if (effects[1] == null)
      return;

    moduleView.pullEnd(x, y);
    Effect effect = pullEndEffect.copy();
    effect.note = moduleView.modules[y][x].getNote();
    Trigger trigger = new Trigger(effect, x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}