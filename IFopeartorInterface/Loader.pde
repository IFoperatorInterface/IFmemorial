class Loader {
  String filename;


  Loader() {
    filename = String.format("save/save.txt");
  }


  void save(List<Effect> presets) {
    String[] presetStrings = new String[presets.size()];
    for (int i=0; i<presetStrings.length; i++)
      presetStrings[i] = presets.get(i).toString();

    saveStrings(filename, presetStrings);
  }


  void load() {
    String[] lines = loadStrings(filename);
    for (String l : lines)
      recordController.addPreset(new Effect(l));
  }
}