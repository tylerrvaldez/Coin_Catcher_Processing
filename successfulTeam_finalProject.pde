// CREDITS
// images from Upklyak on freepik
// basket image by winwin.artlab on freepik
// sound effects made with bfxr

//import processing.sound.*;
import ddf.minim.*;

// setup for audio
AudioPlayer coin_sound, bomb_sound, powerUp_sound;
AudioPlayer song;
Minim minim;
//variables
int state;
int score;
int lives = 3;
int startTime;
Basket _basket;
Skills _skills;
Bombs [] _bombs = new Bombs [3];
Coins [] _coins = new Coins [8];
// images for the objects
PImage basket;
PImage bronze_coin;
PImage silver_coin;
PImage gold_coin;
PImage bomb;
PImage life;
PImage pause;
PImage shield;
PImage magnet;
PImage setting;
PImage sound;
PImage [] coins = {bronze_coin, silver_coin, gold_coin};
Scrollbar hs1;
int mutefactor = -1;
// animation
int growing, maxSize, sunSize;
float angle;


void setup() {
  size(1920, 1080);
  DrawBackground(0, 0, width, height);

  // sun animation variables
  growing = 1;
  maxSize = 200;
  sunSize = 100;
  angle = 0;

  // audio
  minim = new Minim(this);
  song = minim.loadFile("game_music.mp3");
  song.play();

  // sound effects
  coin_sound = minim.loadFile("Pickup_Coin.wav");
  bomb_sound = minim.loadFile("Explosion.wav");
  powerUp_sound = minim.loadFile("PowerUp.wav");

  state = 0; // Initial screen

  // load images for the objects
  basket = loadImage("basket.png");
  bronze_coin = loadImage("coin_bronze.png");
  silver_coin = loadImage("coin_silver.png");
  gold_coin = loadImage("coin_gold.png");
  bomb = loadImage("bomb.png");
  life = loadImage("life.png");
  pause = loadImage("pausebutton.png");
  shield = loadImage("shield.png");
  magnet = loadImage("magnet.png");
  setting = loadImage("settingbutton.png");
  sound = loadImage("soundbutton.png");

  // set up coins
  for (int i = 0; i < _coins.length; i++) {
    float posx = random(100, 1900 * 8);
    float posy = random(-20000, -1000);
    _coins[i] = new Coins(posx, posy);
  }
  // set up bombs
  for (int j = 0; j < _bombs.length; j++) {
    float posx = random(100, 1900 * 8);
    float posy = random(-20000, -1000);
    _bombs[j] = new Bombs(posx, posy);
  }

  //  set up volume scroll bar
  hs1 = new Scrollbar(750, height/2-8, 520, 16, 5);
}

void draw() {
  if (state == 0) { // Initial screen
    Start();
  } else if (state == 1) { // Game start
    Play();
  } else if (state == 2) { // Game over
    Result();
  } else if (state == 3) { // Game pause
    Pause();
  } else if (state == 4) { // Game settings
    Settings();
  }

  // animation hierarchy variables
  // increment sun size to be bigger and smaller, giving the effect of "glowing"
  sunSize += 2 * growing;
  if (sunSize > maxSize || sunSize < 100) {
    growing =- growing;
  }
  // rotate rays
  angle += 0.01;
}

// shows the main menu
void Start() {
  DrawBackground(0, 0, width, height);
  // Fonts
  PFont title = createFont("BROADW.TTF", 128);
  PFont play = createFont("BROADW.TTF", 64);
  PFont copyright = createFont("BROADW.TTF", 40);

  textFont(title);
  textAlign(CENTER);
  fill(55, 100, 154);
  fill(111, 186, 250);
  text("Coin Catcher", width/2, 250);
  fill(252, 171, 193);
  text("Coin Catcher", width/2 + 10, 250 + 8);

  fill(111, 186, 250);
  textFont(play);
  text("Play", width/2, 560);


  fill(111, 186, 250);
  textFont(copyright);
  text("© Successful Team 2022 -- Ziyue, Peyton, Deborah, Tyler", width/2, height-50);

  fill(255);
  text("Use the mouse to move the container\nGood luck!", width/2, 350);

  if (mousePressed) {
    //begin to play
    if (mouseX >= 880 && mouseX <= 1040 && mouseY >=500 && mouseY <= 580) {
      state = 1;
    }
  }
}

// shows the game
void Play() {

  if (mutefactor == 1) {
    song.mute();
  } else {
    song.unmute();
    coin_sound.unmute();
    bomb_sound.unmute();
    powerUp_sound.unmute();
  }

  PFont play = createFont("BROADW.TTF", 64);
  DrawBackground(0, 0, width, height);
  // sun animation
  Sun mySun = new Sun(0, 0, sunSize);
  // add ray animation
  pushMatrix();
  shapeMode(CENTER);
  // draw the sun in the middle of the screen
  translate(width / 2, height / 2);
  mySun.display();
  // rotate light rays around the main sun body
  rotate(angle);
  mySun.rays();
  popMatrix();
  // add some clouds in the background; should move over the main sun
  mySun.clouds(0, 0);
  mySun.clouds(500, 500);
  mySun.clouds(1400, 300);

  //draw pause button
  pushMatrix();
  scale(0.2);
  image(pause, 1850*5, 400);
  popMatrix();

  //draw setting button
  pushMatrix();
  scale(0.25);
  image(setting, 1675*4.167, 80*4.167);
  popMatrix();

  // draws the basket and has it follow the mouse
  _basket = new Basket(mouseX, height/1.3);
  _basket.display();

  // randomly display coins
  for (Coins coin : _coins) {
    if (Overlap(coin) == true && coin.active ==true) {
      coin.active = false;
      score += coin.bonus;
      if (mutefactor == 1) {
        coin_sound.mute();
      } else {
        coin_sound.play(); // play coin sound effect
      }
      coin_sound.cue(0); // reset to the beginning so it can play for every coin
    }
    pushMatrix();
    coin.display();
    coin.move();
    if (coin.y/8 > 1900) {
      coin.active = true;
      coin.appear = true;
      coin.x = random(10, 1900*8);
      coin.a = random(50, 200);
      coin.y = random(-1000, -10);
    }
    popMatrix();
  }
  // randomly display bombs
  for (Bombs bomb : _bombs) {
    if (Overlap(bomb) == true && bomb.active == true) {
      score += bomb.penalty;
      lives -= 1;
      bomb.active = false;
      if (mutefactor == 1) {
        bomb_sound.mute();
      } else {
        bomb_sound.play(); // play bomb sound effect
      }
      bomb_sound.cue(0); // reset to the beginning so it can play again
    }
    pushMatrix();
    bomb.display();
    bomb.move();
    if (bomb.y/8 > 1900) {
      bomb.active = true;
      bomb.appear = true;
      bomb.x = random(10, 1900*8);
      bomb.a = random(50, 200);
      bomb.y = random(-1000, -10);
    }
    if (keyPressed) {
      if (key == 'o' || key == 'O') {
        bomb.appear = false;
        bomb.active = false;
      } else {
        bomb.appear = true;
        bomb.active = true;
      }
    }
    popMatrix();
    pushMatrix();
    if (keyPressed && (key == 'p' || key == 'P')){
      
    }
    popMatrix();
  }

  //Scoreboard
  fill(111, 186, 250);
  textFont(play);
  text("Score: "+ score, 1500, 100);

  //Lives
  text("Lives: "+ lives, 200, 100);

  // Game Over
  if (lives  == 0) {
    state = 2;
  }

  // Add skills to right corner
  _skills = new Skills(18500, 2100);
  _skills.display();

  _skills.displayText();
}

void Result() {
  PFont title = createFont("BROADW.TTF", 128);
  PFont play = createFont("BROADW.TTF", 64);
  isRank(score);
  textFont(title);
  fill(111, 186, 250);
  textMode(CENTER);
  text("Your Score: " + score, width/2, height/4);
  textFont(play);
  if (score <= 0) {
    text(":( Hmmm...you lose all money", width/2, height/3 );
  } else if (score > 0) {
    text(":) You got it!", width/2, height/3);
  }

  text("Try it again", width/2, height /2-100);
  if (mousePressed) {
    if (mouseX > width/2 - 200 && mouseX < width/2 + 200 && mouseY > height /2 -100 - 30 && mouseY < height /2 -100+30) {
      score = 0;
      lives = 3;
      for (Coins coin : _coins) {
        coin.y = random(-20000, -1000);
        coin.theta = 0;
        coin.a = random(0.1, 20);
      }
      for (Bombs bomb : _bombs) {
        bomb.y = random(-20000, -1000);
        bomb.theta = 0;
        bomb.a = random(0.1, 20);
      }
      state = 0;
    }
  }
}

// Pause screen
void Pause() {
  song.pause();
  PFont play = createFont("BROADW.TTF", 64);
  textFont(play);
  textAlign(CENTER);
  text("Paused, click anywhere to resume", width/2, height/2);
  if (mousePressed) {
    state = 1;
    song.loop();
  }
}

// Settings screen
// with slider for volume control and mute button
void Settings() {

  pushMatrix();
  scale(0.25);
  imageMode(CENTER);
  image(sound, (width/2)*4.167, (height/2+75)*4.167);
  popMatrix();

  PFont play = createFont("BROADW.TTF", 55);
  textFont(play);
  textAlign(CENTER);
  text("Settings, press any key to resume", width/2, height/2-100);
  textSize(45);
  text("Volume: ", 585, height/2);
  text("Mute: ", 570, height/2+100);
  hs1.update();
  hs1.display();

  if (mutefactor == 1) {
    song.mute();
    pushMatrix();
    strokeWeight(4);
    stroke(255, 3, 3);
    line(964, 667, 1029, 606);
    popMatrix();
  } else {

    // changes volume based on position of slider
    float perc = (((hs1.getPos()-755)/(1268-755))*(75))+ (-50);
    song.unmute();
    coin_sound.unmute();
    bomb_sound.unmute();
    powerUp_sound.unmute();
    song.shiftGain(song.getGain(), perc, 2500);
    coin_sound.shiftGain(song.getGain(), perc, 2500);
    bomb_sound.shiftGain(song.getGain(), perc, 2500);
    powerUp_sound.shiftGain(song.getGain(), perc, 2500);
  }

  if (keyPressed) {
    state = 1;
    song.loop();
  }
}

void isRank(int score) {
  String[] names = new String[6];
  int[] results = new int[6];
  IntDict rk = new IntDict();
  String[] lines = loadStrings("rankings.txt");
  int counter = 0;
  PFont rank = createFont("BROADW.TTF", 48);
  for (int i = 0; i < lines.length; i++) {
    if (i % 2 == 0) {
      names[counter] = lines[i];
    } else if (i%2 == 1) {
      results[counter] = int(lines[i]);
      counter += 1;
    }
  }
  if (score > results[4]) {

    names[counter] = "YOU";
    results[counter] = score;

    for (int i = results.length -1; i>=0; i--) {
      rk.set(names[i], results[i]);
    }
    rk.sortValuesReverse();
    PrintWriter newrank = createWriter ("rankings.txt");
    char i = char(65);
    for (int j = 0; j < 5; j++) {
      newrank.println("User " + i + "\n" + rk.value(j) );

      i += 1;
    }
    newrank.close();



    float distance = 0;

    pushMatrix();
    fill(252, 171, 193);

    rect(250, 100, 1500, 800);
    text("Rankings:", width/2, height/2);
    for (String k : rk.keys()) {
      if (k == "YOU") {
        fill(0);
      } else {
        fill(162);
      };
      textFont(rank);
      text(k+ ": " + rk.get(k), width/2, 600 + distance);
      distance += 50;
    }
    fill(111, 186, 250);
    popMatrix();
  }
}


// catch the coins/bombs/powerups
Boolean Overlap(Coins c) {
  if (c.y >= 900 * 8 && c.y <= 1200 * 8 && c.x >= (mouseX + 50)*8 && c.x <= (mouseX + 350)*8) {
    c.overlap();
    return true;
  }
  return false;
}

Boolean Overlap(Bombs b) {
  if (b.y >= 760 * 8 && b.y <= 1300 * 8 && b.x >= (mouseX + 80)*8 && b.x <= (mouseX + 380)*8) {
    b.overlap();
    return true;
  }
  return false;
}

// different functions, depending on different buttons clicked
void mouseClicked() {
  // Sound button
  if (mouseX > 950 && mouseX < 1050 && mouseY > 590 && mouseY < 680) {
    mutefactor = mutefactor * (-1);
  }

  // Game Pause
  if (mouseX > 1800 && mouseX < 1960 && mouseY > 0 && mouseY < 100) {
    state = 3;
  }

  // Game Settings
  if (mouseX > 1625 && mouseX < 1760 && mouseY > 0 && mouseY < 100) {
    state = 4;
  }
}


// draws the sky and ground
void DrawBackground(int x, int y, float w, float h) {
  // base sky
  background(69, 77, 175);

  // gradient colors
  color c1 = color(206, 236, 242);
  color c2 = color(247, 216, 231);

  // linear gradient for the sky, code reference from processing.org examples
  noFill();
  for (int i = y; i < y + h; i++) {
    float inter = map(i, y, y + h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x + w, i);
  }

  // ground
  noStroke();
  fill(55, 100, 154);
  rect(0, height / 1.2, width, height / 1.3);
}
