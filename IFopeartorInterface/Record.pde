class Record {
  private List<Trigger> triggers;
  private final int startTime;
  private int duration;


  Record(int startTime) {
    this.triggers = new ArrayList<Trigger>();
    this.startTime = startTime;
  }
}
