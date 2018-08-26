class Record {
  private List<Trigger> triggers;
  private int recordStartTime;
  private int duration;
  private final int id;
  public String name;
  private int playStartTime;


  Record(int recordStartTime, int id) {
    this.triggers = new ArrayList<Trigger>();
    this.recordStartTime = recordStartTime;
    this.duration = 120;
    this.id = id;
    this.name = "";
    this.playStartTime = -1;
  }


  Record(String s) {
    String[] words = s.split("\\$");
    this.recordStartTime = Integer.parseInt(words[0]);
    this.duration = Integer.parseInt(words[1]);
    this.id = Integer.parseInt(words[2]);
    this.name = words[3];
    this.playStartTime = -1;

    this.triggers = new ArrayList<Trigger>();
    for (int i=4; i<words.length; i++) {
      triggers.add(new Trigger(words[i]));
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);

    if (triggers.size() == 1)
      recordStartTime = frameCount - 15;

    duration = (frameCount + 105) - recordStartTime;
  }


  public String toString() {
    String result = "";
    result += recordStartTime + "$";
    result += duration + "$";
    result += id + "$";
    result += name + "$";
    for (Trigger t : triggers) {
      result += t.toString() + "$";
    }

    return result;
  }
}
