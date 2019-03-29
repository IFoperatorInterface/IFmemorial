class Rider {
    PVector pos;
    PVector prevPos;
    private int r;
    private float weight;
    private int indx;
    private int nextMove;
    Rider(PVector pos, float weight, int indx) {
        this.pos = pos;
        r = 120;
        this.weight = weight;
        this.indx = indx;
        this.prevPos = new PVector(0, 0);
    }

    void update(PVector pos, float weight) {
        this.pos = pos;
        this.weight = weight;
    }

    void draw() {
    }

    boolean checkStateRiderIsOn() {
        boolean result;
        if (weight == 0) result = false;
        else result = true;
        return result;
    }
}