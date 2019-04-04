import controlP5.*;
import java.util.*;
import processing.serial.*;
import hypermedia.net.*;
import processing.core.*;
import arb.soundcipher.*;
import java.net.*;
import java.awt.Color;
import java.util.Arrays;

final boolean AUTO_WELCOME_MODE = true;

ControlP5 controlP5;
EffectController effectController;
FieldController fieldController;
PresetController presetController;
ModuleView moduleView;
SystemView systemView;
DataView dataView;
TimeView timeView;
Setups setups;

PApplet sketch = this;

DataController dataController;
Data mdata[];
SETTING setting;
boolean settingCompleted = false;

int mouseStartX, mouseStartY;
final int MOUSE_MODE = 1;

public void settings() {
  // size(1920, 1080);
  fullScreen();
}

void setup() {
  setting = new SETTING();

  setting.isCompleted = true;
  setups = new Setups();
  timeView = new TimeView();
}


void draw() {
  background(0);

      try {
        controlP5.draw();
        effectController.onDraw();
        fieldController.onDraw();
        presetController.onDraw();
        moduleView.draw();
        systemView.draw();
        dataView.draw();
        timeView.draw();
      } catch (Exception e) {}
}


void mouseClicked() {
  if (MOUSE_MODE != 0)
    return;
  if (!setting.isCompleted)
    return;

  effectController.press(mouseX, mouseY);
}


void mousePressed() {
  if (!setting.isCompleted)
    return;
  fieldController.onMousePressed();

  if (MOUSE_MODE != 1)
    return;

  mouseStartX = mouseX;
  mouseStartY = mouseY;

  effectController.mousePressed();
}


void mouseReleased() {
  if (!setting.isCompleted)
    return;
  fieldController.onMouseReleased();

  if (MOUSE_MODE != 1)
    return;

  effectController.press(mouseStartX, mouseStartY, mouseX, mouseY);

  effectController.mouseReleased();
}


void stop() {
}
