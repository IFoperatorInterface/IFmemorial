public class RecordController {
  private List<Record> records;
  private Record newRecord;
  private int newId;
  private boolean isRecording;


  RecordController() {
    this.records = new ArrayList<Record>();
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
      newRecord.duration = frameCount - newRecord.recordStartTime;
      records.add(newRecord);
      newRecord = null;

      updateRecordPlayToggle();
    }
  }


  private void updateRecordPlayToggle() {
    for (int i=0; i<records.size(); i++) {
      int x = int(windows[4].pos.x);
      int y = int(windows[4].pos.y);
      int h = int(windows[4].size.y);
      int pd = 10;
      int btSize = int(h / 3);
      controlP5.addToggle("recordPlay" + records.get(i).id + "Toggle")
        .setPosition(x+(btSize+pd)*i, y)
        .setSize(btSize, btSize)
        .setCaptionLabel("record" + records.get(i).id)
        .plugTo(this);
    }
  }
}
