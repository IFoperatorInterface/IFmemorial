class RecordController {
  private List<Record> records;
  private List<Integer> playStartTime;
  private Record newRecord;
  private boolean isRecording;


  RecordController() {
    this.records = new ArrayList<Record>();
    this.playStartTime = new ArrayList<Integer>();
    this.isRecording = false;

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
}
