class FieldController {
  FieldController() {
    controlP5.addMatrix("fieldMatrix")
      .setPosition(1200/SCALE, 300/SCALE)
      .setSize(600/SCALE, 600/SCALE)
      .setGrid(6, 6)
      .stop();
  }
}
