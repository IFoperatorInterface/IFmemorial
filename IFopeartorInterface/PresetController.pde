public class PresetController {
  private Effect[] effects;
  private Effect pullStartEffect, pullEndEffect;
  private Effect jumpStartEffect, jumpEndEffect, jumpFieldEffect;


  PresetController() {
    effects = new Effect[Preset.values().length];

    for (Preset p : Preset.values()) {
      effects[p.ordinal()] = new Effect();
    }

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
    pullEndEffect.fieldMode[FieldMode.DOWN.ordinal()] = true;
    pullEndEffect.position[0] = 0;
    pullEndEffect.position[1] = 100;
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
    jumpFieldEffect.barMode = BarMode.STRETCH;
    jumpFieldEffect.fieldMode[FieldMode.ELLIPSE.ordinal()] = true;
    jumpFieldEffect.position[0] = 0;
    jumpFieldEffect.position[1] = 100;
    jumpFieldEffect.noCenter = true;
    jumpFieldEffect.brightness[1] = new int[]{10, 100};
    jumpFieldEffect.brightness[2] = new int[]{35, 30};
    jumpFieldEffect.brightness[3] = new int[]{60, 0};
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


  public void triggerJump(int x, int y) {
    Trigger startTrigger = new Trigger(jumpStartEffect, x, y, frameCount);
    Trigger endTrigger = new Trigger(jumpEndEffect, x, y, frameCount + 58);
    Trigger fieldTrigger = new Trigger(jumpFieldEffect, x, y, frameCount + 58);
    moduleView.addTrigger(startTrigger);
    moduleView.addTrigger(endTrigger);
    moduleView.addTrigger(fieldTrigger);
  }


  public void trigger(Preset preset, int x, int y) {
    Trigger trigger = new Trigger(effects[preset.ordinal()], x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}