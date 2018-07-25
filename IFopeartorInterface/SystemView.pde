class SystemView {
    Title[] ledBehaviorTiltles = new Title[3];
    Title[] fieldDirectionTitles = new Title[6];
    Title[] sliderTitles = new Title[3];
    private List < Title > recordTitles;
    SystemView() {
        recordTitles = new ArrayList < Title > ();
    }
    void draw() {

        adrWindow();

        for (Title t: recordTitles)
            t.display();

        for (Title t: sliderTitles)
            t.display();

        for (Title t: fieldDirectionTitles)
            t.display();

        for (Title t: ledBehaviorTiltles)
            t.display();

        windowWindow();
    }
    void windowWindow() {
        if (recordController.isRecording) {
            // float x = fieldController.fieldBtsPos[0].x;
            // float y = fieldController.fieldBtsPos[0].y;
            // float w = fieldController.fieldBtsPos[5].x - fieldController.fieldBtsPos[0].x + fieldController.btSize;
            // float h = fieldController.fieldBtsPos[30].y - fieldController.fieldBtsPos[0].y + fieldController.btSize;
            float x = windows[4].pos.x;
            float y = windows[4].pos.y;
            float w = windows[4].size.x;
            float h = windows[4].size.y;
            float scale = 100;
            float speed = 8;
            pushStyle();
            noFill();
            strokeWeight(5);
            stroke(millis() % (scale * speed), 0, 0);

            rect(x, y, w, h);
            popStyle();
        }


        for (Window w: windows)
            w.display();

    }
    void adrWindow() {
        int NUM_ADR = 3;
        int pd = 10;
        int h = int(windows[NUM_ADR - 1].size.y - pd);
        int btSize = int(h / 3);

        int x = int(windows[NUM_ADR - 1].pos.x) + (btSize + pd) * NUM_ADR + pd * 3 / 2;
        int y = int(windows[NUM_ADR - 1].pos.y + pd / 2);
        int w = width / 2 - 15 - x - pd / 2;
        color c = (!adrBt.isMouseOver()) ? color(0, 55, 110) : color(0, 116, 180);
        pushStyle();
        stroke(c);
        strokeWeight(pd);
        fill(color(0, 45, 90));
        rect(x, y, w, h);
        popStyle();

        for (ADRpointer p: effectController.adrPointers)
            p.draw();

        for (int i = 0; i < effectController.adrPointers.length - 1; i++) {
            stroke(255);
            line(effectController.adrPointers[i].pos.x, effectController.adrPointers[i].pos.y, effectController.adrPointers[i + 1].pos.x, effectController.adrPointers[i + 1].pos.y);
        }
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