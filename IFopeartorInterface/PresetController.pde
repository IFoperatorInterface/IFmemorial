public class PresetController {
  private Effect[] effects;


  PresetController() {
    effects = new Effect[Preset.values().length];

    for (Preset p : Preset.values()) {
      effects[p.ordinal()] = new Effect();
    }
  }


  public void trigger(Preset preset, int x, int y) {
    Trigger trigger = new Trigger(effects[preset.ordinal()], x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}