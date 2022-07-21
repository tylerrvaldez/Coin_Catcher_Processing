class FallingItems {
  float x, y;
  float a = random(0.1, 20);
  float theta = 0;
  Boolean appear = true;
  FallingItems(float _x, float _y) {
    this.x = _x;
    this.y = _y;
  }

  void move() {
    a += random(1 + theta, 3+ theta);
    y += a;
    theta += 0.02;
  }

  void overlap() {
    appear = false;
  }
  
}
