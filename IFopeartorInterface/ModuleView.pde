class ModuleView {
  private List < Trigger > triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;
  private static final int MIN_DELAY = 1;
  private static final int MAX_DELAY = 40;

  ModuleView() {
    triggers = new ArrayList < Trigger > ();
    modules = new Module[ROWS][COLUMNS];

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
        modules[t.y][t.x].addTrigger(t.copyWithStartTime(frameCount));

        dataController.sendSoundData(t.y*COLUMNS+t.x, getNote(t.effect, phase, delay));
        
      }

      if (phase % delay == 1 && phase > 1) {
        int distance = (frameCount - t.startTime) / delay;

        if (t.effect.fieldMode[FieldMode.UP.ordinal()]) {
          int y = t.y - distance;
          if (y >= 0)
            modules[y][t.x].addTrigger(t.copyWithStartTime(frameCount));
          dataController.sendSoundData(y * COLUMNS + t.x, getNote(t.effect, phase, delay));
        }

        if (t.effect.fieldMode[FieldMode.DOWN.ordinal()]) {
          int y = t.y + distance;
          if (y < ROWS)
            modules[y][t.x].addTrigger(t.copyWithStartTime(frameCount));
          dataController.sendSoundData(y * COLUMNS + t.x, getNote(t.effect, phase, delay));
        }

        if (t.effect.fieldMode[FieldMode.LEFT.ordinal()]) {
          int x = t.x - distance;
          if (x >= 0)
            modules[t.y][x].addTrigger(t.copyWithStartTime(frameCount));
          dataController.sendSoundData(t.y * COLUMNS + x, getNote(t.effect, phase, delay));
        }

        if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()]) {
          int x = t.x + distance;
          if (x < COLUMNS)
            modules[t.y][x].addTrigger(t.copyWithStartTime(frameCount));
          dataController.sendSoundData(t.y * COLUMNS + x, getNote(t.effect, phase, delay));
        }
      }

      if (t.effect.fieldMode[FieldMode.ELLIPSE.ordinal()]) {
        float diameter = map(t.effect.diameter, 0, 100, 1, getDistance(1, 1, ROWS, COLUMNS));
        for (int x = 0; x < COLUMNS; x++)
          for (int y = 0; y < ROWS; y++)
            if ((int) (getDistance(t.x, t.y, x, y) * delay) == phase + 1
                && getDistance(t.x, t.y, x, y) <= diameter
                && !(x == t.x && y == t.y)) {
              modules[y][x].addTrigger(t.copyWithStartTime(frameCount));
              dataController.sendSoundData(y * COLUMNS + x, getNote(t.effect, phase, delay));
            }
      }

      if (t.effect.direction != null) {
        PVector displacement = t.effect.direction.setMag(null, 1).mult((phase - 1.0) / delay);
        PVector prevDisplacement = t.effect.direction.setMag(null, 1).mult((phase - 2.0) / delay);

        int x = t.x + round(displacement.x);
        int y = t.y + round(displacement.y);

        if ((round(displacement.x) != round(prevDisplacement.x) || round(displacement.y) != round(prevDisplacement.y))
            && !(x < 0 || x >= 6 || y < 0 || y >= 6)
            && !(x == t.x && y == t.y)) {
          modules[y][x].addTrigger(t.copyWithStartTime(frameCount));
          dataController.sendSoundData(y * COLUMNS + x, getNote(t.effect, phase, delay));
        }
      }
    }
  }


  private float getDistance(int x1, int y1, int x2, int y2) {
    return sqrt(sq(x1 - x2) + sq(y1 - y2));
  }


  private int getNote(Effect effect, int phase, int delay) {
    switch (effect.soundMode) {
      case SINGLE:
        return effect.note;
      case CHORD:
        return effect.note + (phase - 1) * 3 / delay;
      case RANDOM:
        if (phase == 1)
          effect.note = (int) random(1, 128);
        return effect.note;
    }
    return -1;
  } 


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }

}