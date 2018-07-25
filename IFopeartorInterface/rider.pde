class Rider {
    PVector pos;
    private color c;
    private int r;
    private float weight;
    Rider(PVector pos, float weight) {
        this.pos = pos;
        c = color(random(255), random(255), random(255), 100);
        r = 20;
        this.weight = weight;
    }

    void update(PVector pos, float weight) {
        this.pos = pos;
        this.weight = weight;
    }

    void draw() {
        // float x = map(pos.x, 0, 6, 0, fieldController.fieldBtsPos[0].x + fieldController.btSize.x);
        // float y = map(pos.y, 0, 6, 0, fieldController.fieldBtsPos[30].y + fieldController.btSize.y);
        // pushStyle();
        // pushMatrix();
        // translate(fieldController.fieldBtsPos[0].x, fieldController.fieldBtsPos[0].y);
        // fill(c);
        // ellipse(x, y, r * weight, r * weight);
        // popMatrix();
        // popStyle();
    }
}