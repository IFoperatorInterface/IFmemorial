class SystemView {
    Title[] ledBehaviorTiltles = new Title[3];
    Title[] fieldDirectionTitles = new Title[6];
    Title[] sliderTitles = new Title[3];
    SystemView() {

    }
    void draw() {
        for (Title t: sliderTitles)
            t.display();
        
        for (Title t: fieldDirectionTitles)
            t.display();
        
        for (Title t: ledBehaviorTiltles)
            t.display();

        for (Window w: windows)
            w.display();


        for (int i = 0; i < effectController.adrPointers.length; i++)
            effectController.adrPointers[i].draw();

        stroke(255);
        line(effectController.adrPointers[0].pos.x, effectController.adrPointers[0].pos.y, effectController.adrPointers[1].pos.x, effectController.adrPointers[1].pos.y);
        line(effectController.adrPointers[1].pos.x, effectController.adrPointers[1].pos.y, effectController.adrPointers[2].pos.x, effectController.adrPointers[2].pos.y);
        line(effectController.adrPointers[2].pos.x, effectController.adrPointers[2].pos.y, effectController.adrPointers[3].pos.x, effectController.adrPointers[3].pos.y);
    }
}

 class Title {
     PVector pos;
     String title;
     Title(PVector pos, String title) {
         this.pos = pos;
         this.title = title;
     }
     void display() {
         pushStyle();
         fill(255);
         textAlign(CENTER, CENTER);
         textFont(titleFont);
         if (title != "NoTitle")
             text(title.toUpperCase(), pos.x, pos.y);

         popStyle();
     }
 }