// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


// A simple Particle class
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(0, 100, 0, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

class Rain { 
float r = random(600);
float y = 0;

void fall(int speed) {

 y = y + speed;
 fill(0,10,200,180);
 ellipse(r, y, 10, 10);
}
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

// global variables
HScrollbar hs1;
int numDrops = 0;
Rain[] drops = new Rain[500]; // Declare and create the array
float temperature;
//float density = temperature%50;
ParticleSystem ps1;
ParticleSystem ps2;
ParticleSystem ps3;
PImage img;
int blue_babies;


void setup() {
 size(600, 600);
 background(255);
 smooth();
 noStroke();
 drops[0] = new Rain(); // Create first object
 hs1 = new HScrollbar(0, height-8, width, 16, 16);
 ps1 = new ParticleSystem(new PVector(width/2, 0));
 ps2 = new ParticleSystem(new PVector(width/2-200, 0));
 ps3 = new ParticleSystem(new PVector(width/2+200, 0));
 img = loadImage("/Users/Bree/Documents/bluebabysyndrome.png");
 img.resize(0, 100);
}

void draw() {
 textSize(16);
 temperature = hs1.getPos()/60;
 if (numDrops == drops.length - 1) numDrops = 0;
 fill(255, 150-temperature*15, 0);
 rect(0, 0, 600, 600);
 if (random(7-temperature) < 1) {
   drops[++numDrops] = new Rain(); // Create each object
 }
 //Loop through array to use objects.
 for (int i = 0; i < numDrops; i++) {
   drops[i].fall(30);
 }
 hs1.update();
 hs1.display();
 for(float i = 0; i < temperature/6; i++) {
    ps1.addParticle();
    ps2.addParticle();
    ps3.addParticle();
 }
 ps1.run();
 ps2.run();
 ps3.run();
 if (int(random(temperature, 100)) == 99) {
   image(img, random(0, width), random(0, height));
   blue_babies++;
 }

 fill(0, 102, 153);
   text("Temperature increase: " + temperature/3, 0, 580);
   text("Chance of heavy rainfall: " + temperature/2, 0, 560);
   text("Use of pesticides: " + temperature, 0, 540);
   text("Blue babies: " + blue_babies, 0, 520);
   println(temperature);
}