public class PresetController {
  private Effect[] effects;


  PresetController() {
    effects = new Effect[Preset.values().length];

    int pd = 8;
    int h = int(windows[4].size.y);
    int btSize = int(h / 3);
    int x = int(windows[4].pos.x) + btSize * 2 + pd * 3;
    int y = int(windows[4].pos.y) + h - btSize - pd;

    for (Preset p : Preset.values()) {
      effects[p.ordinal()] = new Effect();

      controlP5.addButton("preset"+p.name()+"Button")
        .setValue(p.ordinal())
        .setPosition(x, y)
        .setSize((int) btSize, (int) btSize)
        .setLabel(p.name())
        .plugTo(this, "presetButton");

      x += btSize + pd;
    }
  }


  void presetButton(int theValue) {
    effects[theValue] = effectController.getEffect();
  }


  public void trigger(Preset preset, int x, int y) {
    Trigger trigger = new Trigger(effects[preset.ordinal()], x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}