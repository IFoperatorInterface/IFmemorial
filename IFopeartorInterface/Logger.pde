class Logger {
  private PrintWriter file;


  Logger() {
    String filename = String.format("log/%04d-%02d-%02d/%02d%02d%02d.csv", year(), month(), day(), hour(), minute(), second());
    this.file = createWriter(filename);

    file.println(String.join(",", "Time", "Subject", "Behavior", "X position", "Y position", "Direction(pull)", "Order(trigger)", "Option(trigger)", "Record(record)"));
  }


  void log(Log log, int x, int y, Object data1, Object data2) {
    String time = String.valueOf(frameCount);
    String subject = "None";
    String behavior = "Unknown";
    String positionX = String.valueOf(x);
    String positionY = String.valueOf(y);
    String direction = "";
    String order = "";
    String option = "";
    String record = "";


    switch (log) {
      case MOVE:
        subject = "Visitor";
        behavior = "Move";
        break;
      case PULL:
        subject = "Visitor";
        behavior = "Pull";
        direction = String.valueOf(round((float) data1 / PI * 180));
        break;
      case JUMP:
        subject = "Visitor";
        behavior = "Jump";
        break;
      case TRIGGER:
        subject = "Operator";
        behavior = "TRIGGER";
        order = String.valueOf((int) data1);
        option = ((Effect) data2).toString();
        break;
      case RECORD_START:
        subject = "Operator";
        behavior = "Record start";
        positionX = "";
        positionY = "";
        record = String.valueOf((int) data1);
        break;
      case RECORD_END:
        subject = "Operator";
        behavior = "Record end";
        positionX = "";
        positionY = "";
        record = String.valueOf((int) data1);
        break;
      case RECORD_PLAY:
        subject = "Operator";
        behavior = "Record play";
        positionX = "";
        positionY = "";
        record = String.valueOf((int) data1);
        break;
      case RECORD_STOP:
        subject = "Operator";
        behavior = "Record stop";
        positionX = "";
        positionY = "";
        record = String.valueOf((int) data1);
        break;
      default:
    }

    file.println(String.join(",", time, subject, behavior, positionX, positionY, direction, order, option, record));

    save();
  }


  void save() {
    file.flush();
  }


  void stop() {
    save();
    file.close();
  }
}