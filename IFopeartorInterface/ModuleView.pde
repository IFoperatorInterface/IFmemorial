class ModuleView {
  private List < Trigger > triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;
  private static final int DELAY = 20;

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

      if ((phase > DELAY * ROWS) &&
        (phase > DELAY * COLUMNS))
        triggersIterator.remove();

      if (phase == 1) {
        modules[t.y][t.x].addTrigger(t.copyWithStartTime(frameCount));

        println(getNote(t.effect, phase));
        
      }

      if (phase % DELAY == 1) {
        int distance = (frameCount - t.startTime) / DELAY;

        if (t.effect.fieldMode[FieldMode.UP.ordinal()]) {
          int y = t.y - distance;
          if (y >= 0)
            modules[y][t.x].addTrigger(t.copyWithStartTime(frameCount));
        }

        if (t.effect.fieldMode[FieldMode.DOWN.ordinal()]) {
          int y = t.y + distance;
          if (y < ROWS)
            modules[y][t.x].addTrigger(t.copyWithStartTime(frameCount));
        }

        if (t.effect.fieldMode[FieldMode.LEFT.ordinal()]) {
          int x = t.x - distance;
          if (x >= 0)
            modules[t.y][x].addTrigger(t.copyWithStartTime(frameCount));
        }

        if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()]) {
          int x = t.x + distance;
          if (x < COLUMNS)
            modules[t.y][x].addTrigger(t.copyWithStartTime(frameCount));
        }

        if (t.effect.fieldMode[FieldMode.UP.ordinal()]
            || t.effect.fieldMode[FieldMode.DOWN.ordinal()]
            || t.effect.fieldMode[FieldMode.LEFT.ordinal()]
            || t.effect.fieldMode[FieldMode.RIGHT.ordinal()]) {
          println(getNote(t.effect, phase));
          // dataController.sendSoundData()

        }
      }

      if (t.effect.fieldMode[FieldMode.ELLIPSE.ordinal()]) {
        int indx = 0;
        for (int x = 0; x < COLUMNS; x++)
          for (int y = 0; y < ROWS; y++)
            if ((int) (sqrt((x - t.x) * (x - t.x) + (y - t.y) * (y - t.y)) * DELAY) == phase + 1){
              modules[y][x].addTrigger(t.copyWithStartTime(frameCount));
              indx++;
            }
        println(getNote(t.effect, phase));
        dataController.sendSoundData(indx, getNote(t.effect, phase));
      }
    }
  }


  private int getNote(Effect effect, int phase) {
    switch (effect.soundMode) {
      case SINGLE:
        if (phase == 1)
          return effect.note;
        else
          return -1;
      case CHORD:
        return effect.note + (phase - 1) * 3 / DELAY;
      case RANDOM:
        if (phase == 1)
          return (int) random(1, 128);
        else
          return -1;
    }
    return -1;
  } 


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }

}