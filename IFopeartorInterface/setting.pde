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
             y = (i) % 4 * ((height - spacing * 2) / 4) + spacing;
             pos[i] = new PVector(x, y);
         }
         for (int i = 0; i < windows.length; i++) {
             float winX = pos[i].x;
             float winY = pos[i].y;
             float winWidth = width / 2 - spacing * 2;
             float winHeight = (i < 5) ? pos[1].y - pos[0].y - spacing : height - pos[1].y - pos[0].y - spacing;
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
         pushStyle();
         noFill();
         stroke(255, 0, 0);
         rect(pos.x, pos.y, size.x, size.y);
         textFont(tinyFont);
         text(title, pos.x, pos.y + 10);
         popStyle();
     }
 }