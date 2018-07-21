class ModuleView {
  private List<Trigger> triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;
  private static final int DELAY = 5;


  ModuleView() {
    triggers = new ArrayList<Trigger>();
    modules = new Module[6][6];

    for (int i=0; i<ROWS; i++)
      for (int j=0; j<COLUMNS; j++)
        modules[i][j] = new Module(i, j);
  }


  public void draw() {
    for (int i=0; i<ROWS; i++)
      for (int j=0; j<COLUMNS; j++)
        modules[i][j].draw();

    for (Trigger t : triggers) {
      if (frameCount - t.startTime == 1)
        modules[t.y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));

      if (t.effect.fieldMode[FieldMode.UP.ordinal()] && ((frameCount-t.startTime)%DELAY==1)) {
        int y = t.y - (frameCount-t.startTime)/DELAY;
        if (y >= 0)
          modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.DOWN.ordinal()] && ((frameCount-t.startTime)%DELAY==1)) {
        int y = t.y + (frameCount-t.startTime)/DELAY;
        if (y < 6)
          modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.LEFT.ordinal()] && ((frameCount-t.startTime)%DELAY==1)) {
        int x = t.x - (frameCount-t.startTime)/DELAY;
        if (x >= 0)
          modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()] && ((frameCount-t.startTime)%DELAY==1)) {
        int x = t.x + (frameCount-t.startTime)/DELAY;
        if (x < 6)
          modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }
    }

    // Remove old trigger in triggers
    Iterator<Trigger> triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger t = triggersIterator.next();
      if ((frameCount > t.startTime + DELAY * ROWS)
        && (frameCount > t.startTime + DELAY * COLUMNS))
        triggersIterator.remove();
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}
