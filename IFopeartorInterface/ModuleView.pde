class ModuleView {
  private List<Trigger> triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;


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
        modules[t.y][t.x].updateTrigger(t);
    }

    // Remove old trigger in triggers
    Iterator<Trigger> triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger t = triggersIterator.next();
      if (frameCount > t.startTime + 30)
        triggersIterator.remove();
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}
