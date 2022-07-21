class Bombs extends FallingItems {
  boolean active;
  int penalty;
  Bombs(float _x, float _y) {
    super(_x, _y);
    this.penalty = -100;
    this.active = true;
  }

  void display() {
    if (appear == true) {
      scale(0.1);
      image(bomb, x, y);
    }
  }

  void overlap() {
    appear = false;
  }
}
