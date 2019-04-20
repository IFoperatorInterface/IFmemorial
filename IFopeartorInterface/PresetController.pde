public class PresetController {
  private static final int PARTICLE_SIZE_MIN = 2; // 입자 크기 랜덤 최솟값. 단위: 0-100
  private static final int PARTICLE_SIZE_MAX = 4; // 입자 크기 랜덤 최댓값. 단위: 0-100
  private static final int PARTICLE_DURATION_MIN = 87/3; // 입자 올라갈때까지 걸리는 시간 랜덤 최솟값. 클수록 느림. 단위: frame/3
  private static final int PARTICLE_DURATION_MAX = 210/3; // 입자 올라갈때까지 걸리는 시간 랜덤 최댓값. 클수록 느림. 단위: frame/3

  private Effect pullStartEffect, pullEndEffect;

  PresetController() {
    pullStartEffect = new Effect();

    pullEndEffect = new Effect();
  }


  public void onDraw() {
  }


  public void triggerPullStart(int x, int y, float size) {
  }


  public void triggerPullEnd(int x, int y, PVector direction, float size) {
    Effect effect = pullEndEffect.copy();
    effect.note = moduleView.modules[y][x].getNote();
    Trigger trigger = new Trigger(effect, x, y, frameCount);
    moduleView.addTrigger(trigger);
  }


  public void triggerParticle(int x, int y, int start) {
    Effect effect = new Effect();
    effect.note = -1;
    effect.barMode = BarMode.BOUNCE;
    effect.size = int(random(PARTICLE_SIZE_MIN, PARTICLE_SIZE_MAX));
    effect.position[0] = start;
    effect.position[1] = 120;
    effect.brightness[1] = new int[]{int(random(PARTICLE_DURATION_MIN, PARTICLE_DURATION_MAX))*(120-start)/140, 22};
    effect.brightness[2] = new int[]{effect.brightness[1][0] * 2, 55};
    effect.brightness[3] = new int[]{effect.brightness[1][0] * 3, 100};
    effect.fieldMode[0] = false;
    effect.fieldMode[1] = false;
    effect.fieldMode[2] = false;
    effect.fieldMode[3] = false;
    Trigger trigger = new Trigger(effect, x, y, frameCount);
    moduleView.addTrigger(trigger);
  }
}
