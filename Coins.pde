class Coins extends FallingItems {
  PImage [] coins = {bronze_coin, silver_coin, gold_coin};
  PImage curr = coins[int(random(0, 3))];
  boolean active; 
  int bonus;
  Coins(float _x, float _y) {
    super(_x, _y);
    if (curr == coins[0]){
      this.bonus = 10;
    } else if (curr == coins[1]){
      this.bonus = 50;
    } else if (curr == coins[2]){
      this.bonus = 100;
    }
    this.active = true;
    
  }

  void display() {
    if (appear == true) {
      scale(0.1);
      image(curr, x, y);
    } 
  }
  
}
