class Record {
  private List<Trigger> triggers;
  private final int startTime;
  private int duration;
  private final int id;


  Record(int startTime, int id) {
    this.triggers = new ArrayList<Trigger>();
    this.startTime = startTime;
    this.id = id;
  }
}
