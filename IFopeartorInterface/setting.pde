 PFont titleFont, tinyFont;
 Window[] windows = new Window[6];
 class SETTING {

     SETTING() {
         titleFont = createFont("stan0758.ttf", 8);
         tinyFont = createFont("stan0758.ttf", 8);
         setWindow();
     }
     void setWindow() {
         PVector[] pos = new PVector[windows.length];
         String[] title = {
             "WINDOW1",
             "WINDOW2",
             "WINDOW3",
             "WINDOW4",
             "WINDOW5",
             "WINDOW6"
         };
         int spacing = 15;
         int x = 0;
         int y = 0;
         for (int i = 0; i < windows.length; i++) {
             x = (i < 4) ? spacing : width / 2 + spacing;
             y = (i) % 4 * ((height - spacing) / 4) + spacing;
             pos[i] = new PVector(x, y);
         }
         for (int i = 0; i < windows.length; i++) {
             float winX = pos[i].x;
             float winY = pos[i].y;
             float winWidth = width / 2 - spacing * 2;
             float winHeight = (i < 5) ? pos[1].y - pos[0].y - spacing : height - pos[1].y - pos[0].y - 1;
             windows[i] = new Window(winX, winY, winWidth, winHeight, title[i]);
         }
     }
 }

 class Window {
     PVector pos;
     PVector size;
     Integer spacing, padding, margin;
     String title;
     Window(float x, float y, float w, float h, String title) {
         pos = new PVector(x, y);
         size = new PVector(w, h);
         this.title = title;
         margin = 5;
     }
     void display() {
         windowGUI();
         adrGUI();
     }
     void windowGUI() {
         pushStyle();
         noFill();
         stroke(20);
         rect(pos.x, pos.y, size.x, size.y);
         textAlign(CENTER, CENTER);
         textFont(tinyFont);
         fill(100);
         float x = pos.x + size.x / 2;
         float y = pos.y + size.y + 5;
         text(title, x, y);
         popStyle();
     }
     void adrGUI() {
         for (int i = 0; i < effectController.adrPointers.length; i++) {//effectController.adrPointers.length
             effectController.adrPointers[i].draw();
         }
         stroke(255);
         line(effectController.adrPointers[0].pos.x, effectController.adrPointers[0].pos.y, effectController.adrPointers[1].pos.x, effectController.adrPointers[1].pos.y);
         line(effectController.adrPointers[0].pos.x, effectController.adrPointers[0].pos.y, effectController.adrPointers[2].pos.x, effectController.adrPointers[2].pos.y);
         line(effectController.adrPointers[3].pos.x, effectController.adrPointers[3].pos.y, effectController.adrPointers[1].pos.x, effectController.adrPointers[1].pos.y);

     }
 }