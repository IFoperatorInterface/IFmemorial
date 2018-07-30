public class PresetController {
  private Effect[] effects;
  private Effect pullStartEffect, pullEndEffect;


  PresetController() {
    effects = new Effect[Preset.values().length];

    for (Preset p : Preset.values()) {
      effects[p.ordinal()] = new Effect();
    }

    pullStartEffect = new Effect();
    pullStartEffect.barMode = BarMode.BLINK;
    pullStartEffect.position[0] = 0;
    pullStartEffect.brightness[1] = new int[]{0, 100};
    pullStartEffect.brightness[2] = new int[]{2, 100};
    pullStartEffect.brightness[3] = new int[]{2, 0};

    pullEndEffect = new Effect();
    pullEndEffect.barMode = BarMode.BLINK;
    pullEndEffect.fieldMode[FieldMode.DOWN.ordinal()] = true;
    pullEndEffect.position[0] = 0;
    pullEndEffect.position[1] = 100;
  }


  public void triggerPullStart(int x, int y, float size) {
    int barSize = (int) (size * 100);
    if (barSize > 100)
      barSize = 100;

    pullStartEffect.position[1] = barSize;

    Trigger trigger = new Trigger(pullStartEffect, x, y, frameCount);
    moduleView.addTrigger(trigger);
  }


  public void triggerPullEnd(int x, int y, float angle) {
    Trigger trigger = new Trigger(pullEndEffect, x, y, frameCount);
    moduleView.addTrigger(trigger);
  }


  public void trigger(Preset preset, int x, int y) {
    Trigger trigger = new Trigger(effects[preset.ordinal()], x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}