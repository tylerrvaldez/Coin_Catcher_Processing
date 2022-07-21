
int tint_s = 128;
int tint_m = 128;
float timer1;
float timer2;

class Skills {
  float x, y;
  boolean is_active;
  Skills(float _x, float _y) {
    this.x = _x;
    this.y = _y;
  }


  void display() {
    scale(0.1);
    tint(255, tint_s);
    image(shield, x, y);
    tint(255, tint_m);
    //image(magnet, x, y+ 1200);

    if (keyPressed && (key == 'o' || key == 'O' )) {
      timer1 = 0;
      tint_s = 128;
    }
    timer1 += 0.1;
    if (keyPressed && (key =='p' || key =='P')) {
      timer2 = 0;
      tint_m = 128;
      is_active = false;
    }
    timer2 += 0.1;
    if (timer1 > 10) {
      tint_s = 255;
      timer1 = -10000;
    }
    if (timer2 > 10) {
      tint_m = 255;
      timer2 = -10000;
      is_active = true;
    }
    noTint();
  }
  void displayText() {
    PFont f = createFont("Arial", 16, true);
    textFont(f, 150);
    fill(111, 186, 250);
    text("Press O for shield", 18500, 4200);
    //text("Press P for magnet", 18500, 4600);
    if (10 - timer1 >= 0 && 10 -timer1 <=10) {
      text(String.format("%.1f", 10-timer1), 18500, 2800);
    }
    //if (10 - timer2 >= 0 && 10-timer2 <= 10) {
    //  text(String.format("%.1f", 10-timer2), 18500, 4000);
    //}
  }

}
