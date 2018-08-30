class Loader {
  String filename;


  Loader() {
    filename = String.format("save/save.txt");
  }


  void save(List < Effect > presets, List < Record > records) {
    String[] strings = new String[1 + presets.size() + records.size()];

    int[] startId = recordController.getStartId();
    strings[0] = startId[0] + "^" + startId[1];

    for (int i = 0; i < presets.size(); i++)
      strings[1 + i] = presets.get(i).toString();

    for (int i = 0; i < records.size(); i++)
      strings[1 + presets.size() + i] = records.get(i).toString();

    saveStrings(filename, strings);
  }


  void load() {
    String[] lines = loadStrings(filename);
    if (lines == null)
      return;

    for (String l: lines) {
      if (l.indexOf("^") != -1) {
        String[] words = l.split("\\^");
        recordController.setStartId(Integer.parseInt(words[0]), Integer.parseInt(words[1]));
      } else if (l.indexOf("$") == -1) {
        recordController.addPreset(new Effect(l));
      } else {
        recordController.addRecord(new Record(l));
      }
    }
  }
}