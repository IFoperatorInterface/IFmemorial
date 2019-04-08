class ModuleView {
  SoundCipher sc;

  private List < Trigger > triggers;
  private Module modules[][];
  private boolean isPulled[][];
  private int nextParticleCount[][];
  private int nextPullSoundCount[][];
  private static final int ROWS = 1;
  private static final int COLUMNS = 16;

  private static final int MIN_DELAY = 1;
  private static final int MAX_DELAY = 40;

  private static final float DECREMENT_RATE = .94; // Wave 퍼질 때 한칸당 빛 높이 및 소리 크기 감쇠 폭. 0에 가까울수록 많이 감쇠. 단위: 1-0

  private static final int PULL_EFFECT_PERIOD_MIN = 10; // 당겼을 때 입자 생성 주기 랜덤 최솟값. 단위: frame
  private static final int PULL_EFFECT_PERIOD_MAX = 60; // 당겼을 때 입자 생성 주기 랜덤 최댓값. 단위: frame
  private static final int PULL_SOUND_PERIOD = 1000; // 당겼을 때 소리 주기. 단위: frame
  private static final int PULL_SOUND_INSTRUMENT = 0; // 당겼을 때 악기. 단위: MIDI 악기 (0-127)
  private static final int PULL_SOUND_VOLUME = 100; // 당겼을 때 소리 크기. 단위: 0-127
  private static final float PULL_SOUND_DURATION = 3.3; // 당겼을 때 소리 길이. 단위: 초

  private static final int WAVE_SOUND_INSTRUMENT = 0; // Wave 악기. 단위: MIDI 악기 (0-127)
  private static final int WAVE_SOUND_VOLUME = 75; // Wave 소리 크기. 단위: 0-127
  private static final float WAVE_SOUND_DURATION = 2; // Wave 소리 길이. 단위: 초

  private static final float NONPULL_PARTICLE_FREQUENCY = 0.015; // 당기지 않았을 때 입자 비율

  ModuleView() {
    sc = new SoundCipher(sketch);

    triggers = new ArrayList < Trigger > ();
    modules = new Module[ROWS][COLUMNS];
    isPulled = new boolean[ROWS][COLUMNS];
    nextParticleCount = new int[ROWS][COLUMNS];
    nextPullSoundCount = new int[ROWS][COLUMNS];

    int indx = 0;
    PVector[] fieldBtsPos = new PVector[ROWS * COLUMNS];
    fieldBtsPos = fieldController.setFieldPostion();
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        int x = (int) opc.ledStripPos[indx].x;
        int y = (int) opc.ledStripPos[indx].y;
        PVector loc = fieldBtsPos[indx];
        modules[i][j] = new Module(indx, x, y, opc.barLength, loc);
        indx++;
      }

  }



  public void draw() {
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        modules[i][j].draw();
        if (frameCount > nextParticleCount[i][j]) {
          nextParticleCount[i][j] = frameCount + int(random(PULL_EFFECT_PERIOD_MIN, PULL_EFFECT_PERIOD_MAX));
          if (isPulled[i][j] || random(1)<NONPULL_PARTICLE_FREQUENCY)
            presetController.triggerParticle(j, i, -20);
        }

        if (isPulled[i][j] && frameCount > nextPullSoundCount[i][j]) {
          nextPullSoundCount[i][j] = frameCount + PULL_SOUND_PERIOD;
          makeSound(i*COLUMNS+j, modules[i][j].getNote(), PULL_SOUND_VOLUME, PULL_SOUND_INSTRUMENT, PULL_SOUND_DURATION);
        }
      }
    // Remove old trigger in triggers
    Iterator < Trigger > triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger t = triggersIterator.next();

      int phase = frameCount - t.startTime;
      int delay = (int) map(sq(140 - t.effect.spread), sq(140), sq(40), MAX_DELAY, MIN_DELAY);

      if (phase > delay * (sqrt(sq(ROWS)+sq(COLUMNS)) + 1))
        triggersIterator.remove();

      if (phase == 1 && !(t.effect.noCenter)) {
        if (t.effect.barMode == BarMode.STRETCH)
          modules[t.y][t.x].increaseBaseLevel();
        modules[t.y][t.x].addTrigger(t.copyWithStartTime(frameCount));

        makeSound(t.y*COLUMNS+t.x, getNote(t.effect, phase, delay), WAVE_SOUND_VOLUME, PULL_SOUND_INSTRUMENT, WAVE_SOUND_DURATION);
        
      }

      if ((phase - 1) % delay == 0 && phase > 1) {
        int distance = (frameCount - t.startTime - 1) / delay;

        if (t.effect.fieldMode[FieldMode.LEFT.ordinal()]) {
          int x = t.x - distance;
          if (x >= 0 && t.effect.barMode == BarMode.STRETCH)
            modules[t.y][x].increaseBaseLevel();
          x = (COLUMNS-1) - abs(abs(x) % (COLUMNS*2-2) - (COLUMNS-1));

          float decrement = pow(DECREMENT_RATE, distance);

          if (x >= 0) {
            Trigger newT = t.copyWithStartTime(frameCount);
            newT.effect.position[1] = int(t.effect.position[1]*decrement);
            modules[t.y][x].addTrigger(newT);
            makeSound(t.y * COLUMNS + x, getNote(t.effect, phase, delay), int(WAVE_SOUND_VOLUME*decrement), PULL_SOUND_INSTRUMENT, WAVE_SOUND_DURATION);
          }
        }

        if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()]) {
          int x = t.x + distance;
          if (x < COLUMNS && t.effect.barMode == BarMode.STRETCH)
            modules[t.y][x].increaseBaseLevel();
          x = (COLUMNS-1) - abs(abs(x) % (COLUMNS*2-2) - (COLUMNS-1));

          float decrement = pow(DECREMENT_RATE, distance);

          if (x < COLUMNS) {
            Trigger newT = t.copyWithStartTime(frameCount);
            newT.effect.position[1] = int(t.effect.position[1]*decrement);
            modules[t.y][x].addTrigger(newT);
            makeSound(t.y * COLUMNS + x, getNote(t.effect, phase, delay), int(WAVE_SOUND_VOLUME*decrement), PULL_SOUND_INSTRUMENT, WAVE_SOUND_DURATION);
          }
        }
      }
    }
  }


  private int getNote(Effect effect, int phase, int delay) {
    switch (effect.soundMode) {
      case SINGLE:
        return effect.note;
      case CHORD:
        return effect.note + (phase - 1) * 3 / delay;
      case RANDOM:
        if (phase == 1)
          effect.note = (int) random(40, 100);
        return effect.note;
    }
    return -1;
  } 
  
  
  private void makeSound(int idx, int note, int volume, int instrument, float length) {
    if (note < 40 || note > 100)
      return;

    dataController.sendSoundData(idx, note, volume, instrument, int(length*50));

    sc.instrument(instrument);
    sc.playNote(note, volume, length);
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }


  public void pullStart(int x, int y) {
    isPulled[y][x] = true;
    modules[y][x].pullStart();
  }


  public void pullEnd(int x, int y) {
    isPulled[y][x] = false;
    modules[y][x].pullEnd();
  }

}
