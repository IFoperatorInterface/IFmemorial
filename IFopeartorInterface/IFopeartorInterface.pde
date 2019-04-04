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
FieldController fieldController;
PresetController presetController;
ModuleView moduleView;
SystemView systemView;
DataView dataView;
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
}


void draw() {
  background(0);

      try {
        controlP5.draw();
        fieldController.onDraw();
        presetController.onDraw();
        moduleView.draw();
        systemView.draw();
        dataView.draw();
      } catch (Exception e) {}
}


void mouseClicked() {
  if (MOUSE_MODE != 0)
    return;
  if (!setting.isCompleted)
    return;
}


void mousePressed() {
  if (!setting.isCompleted)
    return;
  fieldController.onMousePressed();

  if (MOUSE_MODE != 1)
    return;

  mouseStartX = mouseX;
  mouseStartY = mouseY;
}


void mouseReleased() {
  if (!setting.isCompleted)
    return;
  fieldController.onMouseReleased();

  if (MOUSE_MODE != 1)
    return;
}


void stop() {
}
