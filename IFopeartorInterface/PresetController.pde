public class PresetController {
  private Effect pullStartEffect, pullEndEffect;

  PresetController() {
    pullStartEffect = new Effect();

    pullEndEffect = new Effect();
  }


  public void onDraw() {
  }


  public void triggerPullStart(int x, int y, float size) {
    moduleView.pullStart(x, y);
  }


  public void triggerPullEnd(int x, int y, PVector direction, float size) {
    moduleView.pullEnd(x, y);

    Effect effect = pullEndEffect.copy();
    effect.note = moduleView.modules[y][x].getNote();
    Trigger trigger = new Trigger(effect, x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}