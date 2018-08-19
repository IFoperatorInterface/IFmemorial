class Trigger {
  public final Effect effect;
  public final int x, y;
  public final int startTime;


  Trigger(Effect effect, int x, int y, int startTime) {
    this.effect = effect;
    this.x = x;
    this.y = y;
    this.startTime = startTime;
  }


  Trigger(String s) {
    String[] words = s.split("@");
    this.x = Integer.parseInt(words[0]);
    this.y = Integer.parseInt(words[1]);
    this.startTime = Integer.parseInt(words[2]);
    this.effect = new Effect(words[3]);
  }


  public Trigger copyWithStartTime(int startTime) {
    return new Trigger(this.effect, this.x, this.y, startTime);
  }


  public String toString() {
    String result = "";
    result += x + "@";
    result += y + "@";
    result += startTime + "@";
    result += effect.toString();

    return result;
  }
}
