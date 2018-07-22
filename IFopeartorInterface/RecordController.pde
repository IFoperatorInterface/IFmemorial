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


  void recordPlayToggle(ControlEvent theEvent) {
    Record targetRecord = null;
    for (Record r : records)
      if (theEvent.isFrom("recordPlay" + r.id + "Toggle"))
        targetRecord = r;

    if (targetRecord == null)
      return;

    if (theEvent.getValue() != 0.0)
      targetRecord.playStartTime = frameCount;
    else
      targetRecord.playStartTime = -1;
  }


  void recordDeleteButton(int theValue) {
    int idx = -1;

    for (int i=0; i<records.size(); i++)
      if (records.get(i).id == theValue)
        idx = i;

    if (idx == -1)
      return;

    controlP5.getController("recordPlay" + records.get(idx).id + "Toggle").remove();
    controlP5.getController("recordDelete" + records.get(idx).id + "Button").remove();
    records.remove(idx);
    updateRecordPlayToggle();
  }


  private void updateRecordPlayToggle() {
    for (int i=0; i<records.size(); i++) {
      int x = int(windows[4].pos.x);
      int y = int(windows[4].pos.y);
      int h = int(windows[4].size.y);
      int pd = 15;
      int btSize = int(h / 3);

      String playName = "recordPlay" + records.get(i).id + "Toggle";
      String deleteName = "recordDelete" + records.get(i).id + "Button";

      Controller playController = controlP5.getController(playName);
      Controller deleteController = controlP5.getController(deleteName);

      if (playController == null) {
        playController = controlP5.addToggle(playName)
          .setSize(btSize, btSize)
          .setCaptionLabel("record" + records.get(i).id)
          .plugTo(this, "recordPlayToggle");
      }
      if (deleteController == null) {
        deleteController = controlP5.addButton(deleteName)
          .setSize(btSize, btSize/2)
          .setValue(records.get(i).id)
          .setCaptionLabel("clear")
          .plugTo(this, "recordDeleteButton");
      }

      playController.setPosition(x+(btSize+pd)*i, y);
      deleteController.setPosition(x+(btSize+pd)*i, y+btSize+pd);
    }
  }


  public void addTrigger(Trigger trigger) {
    if (!isRecording)
      return;

    newRecord.addTrigger(trigger);
  }


  public void onDraw() {
    for (Record r : records) {
      if (r.playStartTime == -1)
        continue;

      int phase = (frameCount - r.playStartTime) % r.duration;

      for (Trigger t : r.triggers)
        if (t.startTime - r.recordStartTime == phase)
          moduleView.addTrigger(t.copyWithStartTime(frameCount));
    }
  }
}
