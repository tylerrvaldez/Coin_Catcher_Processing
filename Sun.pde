class Sun {
  float x, y, radius;
  
  Sun(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }
  
  // draw sun
  void display() {
    // sun
    noStroke();
    fill(249, 142, 107);
    ellipse(x, y, radius, radius);
    // glow
    fill(249, 142, 107, 100);
    ellipse(x, y, radius + 20, radius + 20);
    fill(249, 142, 107, 50);
    ellipse(x, y, radius + 40, radius + 40);
  }
  
  // add animation hierarchy with rotating rays around the sun
  // rays should expand with the sun
  void rays() {
    PShape rays = createShape(GROUP);
    float dist = radius / 2;
    strokeWeight(radius / 10); 
    
    // rays have alternating opacities 
    // diagonals
    stroke(249, 142, 107, 100);
    PShape r1 = createShape(LINE, x - radius, y - radius, x - dist, y - dist);
    PShape r2 = createShape(LINE, x + dist, y + dist, x + radius, y + radius);
    PShape r3 = createShape(LINE, x + radius, y - radius, x + dist, y - dist);
    PShape r4 = createShape(LINE, x - dist, y + dist, x - radius, y + radius);
    
    // horizontals and verticals
    stroke(249, 142, 107, 50);
    PShape r5 = createShape(LINE, x - radius, y, x - dist, y);
    PShape r6 = createShape(LINE, x, y - radius, x, y - dist);
    PShape r7 = createShape(LINE, x + radius, y, x + dist, y);
    PShape r8 = createShape(LINE, x, y + radius, x, y + dist);
    
    // add individual rays to pshape group
    rays.addChild(r1);
    rays.addChild(r2);
    rays.addChild(r3);
    rays.addChild(r4);
    rays.addChild(r5);
    rays.addChild(r6);
    rays.addChild(r7);
    rays.addChild(r8);
    
    // draw the rays
    shape(rays);
  }
  
  // add some clouds around the sun
  // x, y for starting position
  void clouds(int x, int y) {
    noStroke();
    fill(255, 231, 231);
    ellipse((frameCount+50+x)% width, 50+y, 60, 50);
    ellipse((frameCount+80+x)% width, 40+y, 60, 50);
    ellipse((frameCount+130+x)% width, 50+y, 60, 50);
    ellipse((frameCount+70+x)% width, 70+y, 60, 50);
    ellipse((frameCount+110+x)% width, 65+y, 60, 50);
  }
}
