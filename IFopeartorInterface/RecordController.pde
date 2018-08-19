public class RecordController {
  private final int NUM_RECORD = 9;
  private final int PD = 8;
  private final int BT_SIZE = int((windows[4].pos.x - (PD * NUM_RECORD + 1)) / NUM_RECORD);

  private List < Record > records;
  private Record newRecord;
  private int newId;
  private Boolean isRecording;

  private Button recordToggle;
  private List<Button> recordPlayToggles;
  private List<Button> recordDeleteButtons;


  RecordController() {
    this.records = new ArrayList < Record > ();
    this.isRecording = false;
    this.newId = 0;

    int h = int(windows[4].size.y);
    int btSize = int(h / 3);
    int x = int(windows[4].pos.x) + PD;
    int y = int(windows[4].pos.y) + h - btSize - PD;


    recordToggle = new Button()
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .setName("record")
      .setBackgroundColor(120, 20, 200)
      .setPressListener(new ButtonPressListener() {
        public void onPress() {
          if (isRecording)
            recordToggle(0);
          else 
            recordToggle(1);
        }
      });

      this.recordPlayToggles = new ArrayList<Button>();
      this.recordDeleteButtons = new ArrayList<Button>();
  }


  void recordToggle(int theValue) {
    if ((theValue == 1) == isRecording)
      return;

    isRecording = (theValue == 1);

    if (isRecording) {
      newRecord = new Record(frameCount, newId);
      logger.log(Log.RECORD_START, -1, -1, newId, null);
      newId++;
    } else {
      newRecord.duration = frameCount - newRecord.recordStartTime;
      records.add(newRecord);

      logger.log(Log.RECORD_END, -1, -1, newRecord.id, null);

      newRecord = null;

      updateRecordPlayToggle();
    }
  }


  void recordPlayToggle(int theValue) {
    int idx = -1;

    for (int i = 0; i < records.size(); i++)
      if (records.get(i).id == theValue)
        idx = i;

    if (idx == -1)
      return;

    Record targetRecord = records.get(idx);

    if (targetRecord.playStartTime == -1){
      targetRecord.playStartTime = frameCount;
      recordPlayToggles.get(idx).setBackgroundColor(0, 170, 255);
      logger.log(Log.RECORD_PLAY, -1, -1, targetRecord.id, null);
    }
    else {
      targetRecord.playStartTime = -1;
      recordPlayToggles.get(idx).setBackgroundColor(0, 45, 90);
      logger.log(Log.RECORD_STOP, -1, -1, targetRecord.id, null);
    }
  }


  void recordDeleteButton(int theValue) {
    int idx = -1;

    for (int i = 0; i < records.size(); i++)
      if (records.get(i).id == theValue)
        idx = i;

    if (idx == -1)
      return;

    records.remove(idx);
    recordPlayToggles.remove(idx);
    recordDeleteButtons.remove(idx);
    updateRecordPlayToggle();
  }


  private void updateRecordPlayToggle() {
    for (int i = 0; i < records.size(); i++) {
      int x = int(windows[4].pos.x);
      int y = int(windows[4].pos.y);
      int h = int(windows[4].size.y);
      int w = int(windows[4].size.x);
      PVector pos = new PVector(x + PD + (BT_SIZE + PD) * i, y + PD);
      final Record targetRecord = records.get(i);

      if (i >= recordPlayToggles.size()) {
        recordPlayToggles.add(new Button()
          .setSize(BT_SIZE, BT_SIZE)
          .setBackgroundColor(0, 45, 90)
          .setName("Record "+targetRecord.id)
          .setPressListener(new ButtonPressListener() {
            public void onPress() {
              recordPlayToggle(targetRecord.id);
            }
          })
        );
      }
      recordPlayToggles.get(i).setPosition((int) pos.x, (int) pos.y);

      if (i >= recordDeleteButtons.size()) {
        recordDeleteButtons.add(new Button()
          .setSize(BT_SIZE, BT_SIZE / 2)
          .setBackgroundColor(0, 45, 90)
          .setName("Clear")
          .setPressListener(new ButtonPressListener() {
            public void onPress() {
              recordDeleteButton(targetRecord.id);
            }
          })
        );
      }
      recordDeleteButtons.get(i).setPosition((int) pos.x, (int) pos.y + BT_SIZE + 2);
    }
  }


  public void addTrigger(Trigger trigger) {
    if (!isRecording)
      return;

    newRecord.addTrigger(trigger);
  }


  public void onDraw() {
    recordToggle.draw();
    for (Button b : recordPlayToggles)
      b.draw();
    for (Button b : recordDeleteButtons)
      b.draw();


    for (Record r: records) {
      if (r.playStartTime == -1)
        continue;

      int phase = (frameCount - r.playStartTime) % r.duration;

      for (Trigger t: r.triggers)
        if (t.startTime - r.recordStartTime == phase)
          moduleView.addTrigger(t.copyWithStartTime(frameCount));
    }
  }


  public void press(int x, int y) {
    recordToggle.press(x, y);
    for (Button b : recordPlayToggles)
      b.press(x, y);
    int listSize = recordDeleteButtons.size();
    for (Button b : recordDeleteButtons) {
      b.press(x, y);
      if (recordDeleteButtons.size() != listSize)
        break;
    }
  }


  public void press(int x1, int y1, int x2, int y2) {
    recordToggle.press(x1, y1, x2, y2);
    for (Button b : recordPlayToggles)
      b.press(x1, y1, x2, y2);
    int listSize = recordDeleteButtons.size();
    for (Button b : recordDeleteButtons) {
      b.press(x1, y1, x2, y2);
      if (recordDeleteButtons.size() != listSize)
        break;
    }
  }
}