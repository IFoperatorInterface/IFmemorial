public class RecordController {
  private List<Record> records;
  private List<Integer> playStartTime;
  private Record newRecord;
  private int newId;
  private boolean isRecording;


  RecordController() {
    this.records = new ArrayList<Record>();
    this.playStartTime = new ArrayList<Integer>();
    this.isRecording = false;
    this.newId = 0;

    int x = int(windows[3].pos.x);
    int y = int(windows[3].pos.y);
    int h = int(windows[3].size.y);
    int btSize = int(h / 3);
    controlP5.addToggle("recordToggle")
      .setPosition(x+btSize*5, y)
      .setSize(btSize, btSize)
      .setCaptionLabel("record")
      .plugTo(this);
  }


  void recordToggle(int theValue) {
    if ((theValue==1) == isRecording)
      return;

    isRecording = (theValue==1);

    if (isRecording) {
      newRecord = new Record(frameCount, newId);
      newId++;
    }
    else {
      newRecord.duration = frameCount - newRecord.startTime;
      records.add(newRecord);
      playStartTime.add(-1);

      int x = int(windows[4].pos.x);
      int y = int(windows[4].pos.y);
      int h = int(windows[4].size.y);
      int pd = 10;
      int btSize = int(h / 3);
      controlP5.addToggle("recordPlay" + newRecord.id + "Toggle")
        .setPosition(x+(btSize+pd)*newRecord.id, y)
        .setSize(btSize, btSize)
        .setCaptionLabel("record" + newRecord.id)
        .plugTo(this);

      newRecord = null;
    }
  }
}
