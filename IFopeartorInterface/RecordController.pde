public class RecordController {
  private List < Record > records;
  private Record newRecord;
  private int newId;
  private Boolean isRecording;


  RecordController() {
    this.records = new ArrayList < Record > ();
    this.isRecording = false;
    this.newId = 0;

    int pd = 8;
    int h = int(windows[4].size.y);
    int btSize = int(h / 3);
    int x = int(windows[4].pos.x) + pd;
    int y = int(windows[4].pos.y) + h - btSize - pd;


    controlP5.addToggle("recordToggle")
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .setColorBackground(color(120, 20, 200))
      .plugTo(this);

    PVector pos = new PVector(x + btSize / 2, y + btSize / 2);
    systemView.recordTitles.add(new Title(pos, "record"));


    controlP5.getController("recordToggle")
      .getCaptionLabel()
      .setVisible(false);
  }


  void recordToggle(int theValue) {
    if ((theValue == 1) == isRecording)
      return;

    isRecording = (theValue == 1);

    if (isRecording) {
      newRecord = new Record(frameCount, newId);
      newId++;
    } else {
      newRecord.duration = frameCount - newRecord.recordStartTime;
      records.add(newRecord);
      newRecord = null;

      updateRecordPlayToggle();
    }
  }


  void recordPlayToggle(ControlEvent theEvent) {
    Record targetRecord = null;
    for (Record r: records)
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

    for (int i = 0; i < records.size(); i++)
      if (records.get(i).id == theValue)
        idx = i;

    if (idx == -1)
      return;

    controlP5.getController("recordPlay" + records.get(idx).id + "Toggle").hide();
    controlP5.getController("recordDelete" + records.get(idx).id + "Button").hide();
    records.remove(idx);
    systemView.recordTitles.remove(idx + 1);
    updateRecordPlayToggle();
  }


  private void updateRecordPlayToggle() {
    for (int i = 0; i < records.size(); i++) {
      int NUM_RECORD = 9;
      int x = int(windows[4].pos.x);
      int y = int(windows[4].pos.y);
      int h = int(windows[4].size.y);
      int w = int(windows[4].size.x);
      int pd = 8;
      int btSize = int((w - (pd * NUM_RECORD + 1)) / NUM_RECORD);


      String playName = "recordPlay" + records.get(i).id + "Toggle";
      String deleteName = "recordDelete" + records.get(i).id + "Button";

      Controller playController = controlP5.getController(playName);
      Controller deleteController = controlP5.getController(deleteName);

      if (playController == null) {
        playController = controlP5.addToggle(playName)
          .setSize(btSize, btSize)
          .plugTo(this, "recordPlayToggle");
      }

      controlP5.getController(playName)
        .getCaptionLabel()
        .setVisible(false);

      if (deleteController == null) {
        deleteController = controlP5.addButton(deleteName)
          .setSize(btSize, btSize / 2)
          .setValue(records.get(i).id)
          .setCaptionLabel("clear")
          .plugTo(this, "recordDeleteButton");
      }
      PVector pos = new PVector(x + pd + (btSize + pd) * i, y + pd);
      playController.setPosition(pos.x, pos.y);
      deleteController.setPosition(pos.x, pos.y + btSize + 2);
      pos.add(btSize / 2, btSize / 2);
      systemView.recordTitles.add(new Title(pos, "record " + records.get(i).id));
    }
  }


  public void addTrigger(Trigger trigger) {
    if (!isRecording)
      return;

    newRecord.addTrigger(trigger);
  }


  public void onDraw() {
    for (Record r: records) {
      if (r.playStartTime == -1)
        continue;

      int phase = (frameCount - r.playStartTime) % r.duration;

      for (Trigger t: r.triggers)
        if (t.startTime - r.recordStartTime == phase)
          moduleView.addTrigger(t.copyWithStartTime(frameCount));
    }
  }
}