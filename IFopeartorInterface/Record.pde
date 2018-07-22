class Record {
  private List<Trigger> triggers;
  private final int recordStartTime;
  private int duration;
  private final int id;
  private int playStartTime;


  Record(int recordStartTime, int id) {
    this.triggers = new ArrayList<Trigger>();
    this.recordStartTime = recordStartTime;
    this.id = id;
    this.playStartTime = -1;
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}
