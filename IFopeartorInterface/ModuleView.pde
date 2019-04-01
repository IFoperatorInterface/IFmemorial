class ModuleView {
  SoundCipher sc;

  private List < Trigger > triggers;
  private Module modules[][];
  private boolean isPulled[][];
  private int nextPullCount[][];
  private int nextPullSoundCount[][];
  private static final int ROWS = 1;
  private static final int COLUMNS = 16;
  private static final int MIN_DELAY = 1;
  private static final int MAX_DELAY = 40;
  private static final float DECREMENT_RATE = 0.92;

  ModuleView() {
    sc = new SoundCipher(sketch);

    triggers = new ArrayList < Trigger > ();
    modules = new Module[ROWS][COLUMNS];
    isPulled = new boolean[ROWS][COLUMNS];
    nextPullCount = new int[ROWS][COLUMNS];
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
        if (isPulled[i][j] && frameCount > nextPullCount[i][j]) {
          nextPullCount[i][j] = frameCount + int(random(10, 15));
          Effect effect = new Effect();
          effect.barMode = BarMode.BOUNCE;
          effect.size = int(random(2, 4));
          effect.position[0] = -20;
          effect.position[1] = 120;
          effect.brightness[1] = new int[]{int(random(17, 40)), 22};
          effect.brightness[2] = new int[]{effect.brightness[1][0] * 2, 55};
          effect.brightness[3] = new int[]{effect.brightness[1][0] * 3, 100};
          Trigger trigger = new Trigger(effect, j, i, frameCount);
          modules[i][j].addTrigger(trigger);
        }

        if (isPulled[i][j] && frameCount > nextPullSoundCount[i][j]) {
          nextPullSoundCount[i][j] = frameCount + 110;
          makeSound(i*COLUMNS+j, modules[i][j].getNote(), 100, 0, 3.3);
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
        modules[t.y][t.x].increaseBaseLevel();
        modules[t.y][t.x].addTrigger(t.copyWithStartTime(frameCount));

        makeSound(t.y*COLUMNS+t.x, getNote(t.effect, phase, delay), 70, 0, 2);
        
      }

      if ((phase - 1) % delay == 0 && phase > 1) {
        int distance = (frameCount - t.startTime - 1) / delay;

        if (t.effect.fieldMode[FieldMode.LEFT.ordinal()]) {
          int x = t.x - distance;
          if (x >= 0)
            modules[t.y][x].increaseBaseLevel();
          x = (COLUMNS-1) - abs(abs(x) % (COLUMNS*2-2) - (COLUMNS-1));

          float decrement = pow(DECREMENT_RATE, distance);

          if (x >= 0) {
            Trigger newT = t.copyWithStartTime(frameCount);
            newT.effect.position[1] = int(t.effect.position[1]*decrement);
            modules[t.y][x].addTrigger(newT);
            makeSound(t.y * COLUMNS + x, getNote(t.effect, phase, delay), int(75*decrement), 0, 2);
          }
        }

        if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()]) {
          int x = t.x + distance;
          if (x < COLUMNS)
            modules[t.y][x].increaseBaseLevel();
          x = (COLUMNS-1) - abs(abs(x) % (COLUMNS*2-2) - (COLUMNS-1));

          float decrement = pow(DECREMENT_RATE, distance);

          if (x < COLUMNS) {
            Trigger newT = t.copyWithStartTime(frameCount);
            newT.effect.position[1] = int(t.effect.position[1]*decrement);
            modules[t.y][x].addTrigger(newT);
            makeSound(t.y * COLUMNS + x, getNote(t.effect, phase, delay), int(75*decrement), 0, 2);
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
