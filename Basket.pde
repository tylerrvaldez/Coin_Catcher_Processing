class Basket {
  float x, y;
  boolean big; // bigger basket skill

  Basket(float _x, float _y) {
    this.x = _x;
    this.y = _y;
    this.big = false;
  }

  void display() {
    imageMode(CENTER);
    
    // bigger basket power up
    if(big) {
      image(basket, x, y, basket.width * 1.5, basket.height * 1.2);
    }
    else {
      image(basket, x, y);
    }
  }
  
}
