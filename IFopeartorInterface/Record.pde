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


  Record(String s, int id) {
    String[] words = s.split("\\$");
    this.recordStartTime = Integer.parseInt(words[0]);
    this.id = id;
    this.playStartTime = -1;

    this.triggers = new ArrayList<Trigger>();
    for (int i=1; i<words.length; i++) {
      triggers.add(new Trigger(words[i]));
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }


  public String toString() {
    String result = "";
    result += recordStartTime + "$";
    for (Trigger t : triggers) {
      result += t.toString() + "$";
    }

    return result;
  }
}
