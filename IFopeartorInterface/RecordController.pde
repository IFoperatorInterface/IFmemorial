public class RecordController {
  private final int NUM_RECORD = 4;
  private final int NUM_PRESET = 4;
  private final int PD = 8;
  private final int BT_SIZE = int((windows[4].pos.x - (PD * (NUM_RECORD + NUM_PRESET + 1) + 1)) / (NUM_RECORD + NUM_PRESET + 1));

  private List < Record > records;
  private Record newRecord;
  private int newId;
  private Boolean isRecording;

  private Button recordToggle;
  private List<Button> recordPlayToggles;
  private List<Button> recordDeleteButtons;

  private Button presetButton;
  private int newPresetId;

  private List<Effect> presets;
  private List<Button> presetSetButtons;
  private List<Button> presetDeleteButtons;


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

      this.presetButton = new Button()
        .setPosition(x + (BT_SIZE+PD) * NUM_RECORD, y)
        .setSize(btSize, btSize)
        .setName("preset")
        .setBackgroundColor(120, 20, 200)
        .setPressListener(new ButtonPressListener() {
          public void onPress() {
            presetButton();
          }
        });

      this.newPresetId = 0;
      this.presets = new ArrayList<Effect>();
      this.presetSetButtons = new ArrayList<Button>();
      this.presetDeleteButtons = new ArrayList<Button>();
  }


  void recordToggle(int theValue) {
    if (records.size() >= NUM_RECORD)
      return;
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


  void presetButton() {
    if (presets.size() >= NUM_PRESET)
      return;

    Effect newPreset = effectController.getEffect();

    addPreset(newPreset);

    loader.save(presets);

  }


  void addPreset(Effect newPreset) {
    newPreset = newPreset.copy();
    newPreset.id = newPresetId;
    presets.add(newPreset);

    updatePresetSetButton();
    
    newPresetId++;
  }


  void presetSetButton(int theValue) {
    int idx = -1;

    for (int i = 0; i < presets.size(); i++)
      if (presets.get(i).id == theValue)
        idx = i;

    if (idx == -1)
      return;

    Effect targetPreset = presets.get(idx);

    effectController.setEffect(targetPreset);
  }


  void presetDeleteButton(int theValue) {
    int idx = -1;

    for (int i = 0; i < presets.size(); i++)
      if (presets.get(i).id == theValue)
        idx = i;

    if (idx == -1)
      return;

    presets.remove(idx);
    presetSetButtons.remove(idx);
    presetDeleteButtons.remove(idx);
    updatePresetSetButton();
    loader.save(presets);
  }


  private void updatePresetSetButton() {
    for (int i = 0; i < presets.size(); i++) {
      int x = int(windows[4].pos.x) + (BT_SIZE + PD) * NUM_RECORD;
      int y = int(windows[4].pos.y);
      int h = int(windows[4].size.y);
      int w = int(windows[4].size.x);
      PVector pos = new PVector(x + PD + (BT_SIZE + PD) * i, y + PD);
      final Effect targetPreset = presets.get(i);

      if (i >= presetSetButtons.size()) {
        presetSetButtons.add(new Button()
          .setSize(BT_SIZE, BT_SIZE)
          .setBackgroundColor(0, 45, 90)
          .setName("Preset "+targetPreset.id)
          .setPressListener(new ButtonPressListener() {
            public void onPress() {
              presetSetButton(targetPreset.id);
            }
          })
        );
      }
      presetSetButtons.get(i).setPosition((int) pos.x, (int) pos.y);

      if (i >= presetDeleteButtons.size()) {
        presetDeleteButtons.add(new Button()
          .setSize(BT_SIZE, BT_SIZE / 2)
          .setBackgroundColor(0, 45, 90)
          .setName("Clear")
          .setPressListener(new ButtonPressListener() {
            public void onPress() {
              presetDeleteButton(targetPreset.id);
            }
          })
        );
      }
      presetDeleteButtons.get(i).setPosition((int) pos.x, (int) pos.y + BT_SIZE + 2);
    }
  }


  public Effect getPreset(int xPos, int yPos) {
    int x = int(windows[4].pos.x) + (BT_SIZE + PD) * NUM_RECORD + PD;
    int y = int(windows[4].pos.y);

    if (yPos < y || yPos >= y+BT_SIZE)
      return null;

    int idx = (xPos - x) / (BT_SIZE + PD);

    if (idx >= 0 && idx < presets.size())
      return presets.get(idx);
    else
      return null;
  }


  public void onDraw() {
    recordToggle.draw();
    for (Button b : recordPlayToggles)
      b.draw();
    for (Button b : recordDeleteButtons)
      b.draw();

    presetButton.draw();
    for (Button b : presetSetButtons)
      b.draw();
    for (Button b : presetDeleteButtons)
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

    presetButton.press(x, y);
    for (Button b : presetSetButtons)
      b.press(x, y);
    listSize = presetDeleteButtons.size();
    for (Button b : presetDeleteButtons) {
      b.press(x, y);
      if (presetDeleteButtons.size() != listSize)
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

    presetButton.press(x1, y1, x2, y2);
    for (Button b : presetSetButtons)
      b.press(x1, y1, x2, y2);
    listSize = presetDeleteButtons.size();
    for (Button b : presetDeleteButtons) {
      b.press(x1, y1, x2, y2);
      if (presetDeleteButtons.size() != listSize)
        break;
    }
  }
}