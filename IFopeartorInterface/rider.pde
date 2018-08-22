class Rider {
    PVector pos;
    private int r;
    private float weight;
    private int indx;
    private int nextMove;
    Rider(PVector pos, float weight, int indx) {
        this.pos = pos;
        r = 120;
        this.weight = weight;
        this.indx = indx;
    }

    void update(PVector pos, float weight) {
        if (frameCount > nextMove
            && (int(pos.x) != int(this.pos.x) || int(pos.y) != int(this.pos.y))) {

            nextMove = frameCount + 10;
            presetController.triggerMove(int(pos.x), int(pos.y));
        }

        this.pos = pos;
        this.weight = weight;
    }

    void draw() {
        pushStyle();
        pushMatrix();
        translate(fieldController.fieldBtsPos[0].x, fieldController.fieldBtsPos[0].y);
        float w = fieldController.fieldBtsPos[5].x - fieldController.fieldBtsPos[0].x + fieldController.btSize;
        float h = fieldController.fieldBtsPos[30].y - fieldController.fieldBtsPos[0].y + fieldController.btSize;
        float x = map(pos.x, 0, 6, 0, w);
        float y = map(pos.y, 0, 6, 0, h);
        float scale = norm(weight, 0, 380);
        stroke(color(200));
        noFill();
        ellipse(x, y, r * scale, r * scale);
        fill(color(200));
        text(indx, x, y);
        popMatrix();
        popStyle();
    }

    boolean checkStateRiderIsOn() {
        boolean result;
        if (weight == 0) result = false;
        else result = true;
        return result;
    }
}