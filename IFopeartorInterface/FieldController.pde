public class FieldController {
  FieldController() {
    int padding = 2;
    int spacing = 25;
    int margin = 5;
    int windowWidth = (int) windows[5].size.x - spacing * 2;
    int windowHeight = (int) windows[5].size.y - spacing * 2;
    int windowX = (int) windows[5].pos.x + spacing;
    int windowY = (int) windows[5].pos.y + spacing;
    int btSize = (windowWidth > windowHeight) ? (windowHeight - margin * 2 - padding * 5) / 6: (windowWidth - margin * 2 - padding * 5) / 6;
    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++) {
        controlP5.addButton("" + (i * 6 + j))
          .setValue(i * 6 + j)
          .setPosition(windowX + (btSize + margin) * j, windowY + (btSize + margin) * i)
          .setSize(btSize, btSize)
          .plugTo(this, "fieldButton");
      }
  }


  void fieldButton(int a) {
    Trigger trigger = new Trigger(effectController.getEffect(), a % 6, a / 6, frameCount);

    moduleView.addTrigger(trigger);
  }
}