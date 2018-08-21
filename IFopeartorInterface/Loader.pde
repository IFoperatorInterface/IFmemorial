class Loader {
  String filename;


  Loader() {
    filename = String.format("save/save.txt");
  }


  void save(List<Effect> presets, List<Record> records) {
    String[] strings = new String[presets.size() + records.size()];
    for (int i=0; i<presets.size(); i++)
      strings[i] = presets.get(i).toString();

    for (int i=0; i<records.size(); i++)
      strings[presets.size()+i] = records.get(i).toString();

    saveStrings(filename, strings);
  }


  void load() {
    String[] lines = loadStrings(filename);
    if (lines == null)
      return;
    int recordId = 0;
    for (String l : lines) {
      if (l.indexOf("$") == -1)
        recordController.addPreset(new Effect(l));
      else {
        recordController.addRecord(new Record(l, recordId));
        recordId++;
      }
    }
  }
}