class Boid {
    PVector pos;
    PVector vel;
    PVector acc;
    
    float cohForce, sepForce, aliForce, colForce, obsForce;
    float maxSpeed;
    
    float persep = random(20, 70);
    
    int r, g, b;
    color c;
    boolean display;
    
    Boid() {
      pos = new PVector(width/2, height/2);
      acc = new PVector(0, 0);
      vel = new PVector(random(-3, 3), random(-3, 3));
      cohForce = 0.2;
      aliForce = 0.3;
      sepForce = 0.27;
      obsForce = 0.5;
      r = int(random(100, 255));
      g = int(random(100, 255));
      b = int(random(100, 255));
      c = color(r, g, b);
      maxSpeed = random(3.5, 4.5);
      display = true;
    }
    
    void show() {
      strokeWeight(16);
      if (display) {stroke(c);}
      else {stroke(0);}
      point(pos.x, pos.y);
      strokeWeight(floor(4));
      line(pos.x, pos.y, pos.x+vel.x*4, pos.y+vel.y*4);
    }
    
    void update() {
      pos.add(vel);
      vel.add(acc);
      vel.limit(maxSpeed);
    }
    
    PVector align(ArrayList<Boid> boids) {
      int tot = 0;
      PVector steer = new PVector(0,0);
      for (Boid b: boids) {
        if (b != this && dist(pos.x, pos.y, b.pos.x, b.pos.y) < persep) {
          steer.add(b.vel);
          if (mousePressed && dist(mouseX, mouseY, pos.x, pos.y) < 70){
            steer.add(new PVector(mouseX-pos.x, mouseY-pos.y));
          }
          tot++;
        }
      }
      if (tot > 0) {
        steer.div(tot);
        steer.setMag(maxSpeed);
        steer.sub(vel);
        steer.limit(aliForce);
      }
      return steer;
    }
    
    PVector cohe(ArrayList<Boid> boids) {
      PVector steer = new PVector();
      int per = 30;
      int tot = 0;
      for (Boid b: boids) {
        if (b != this && dist(pos.x, pos.y, b.pos.x, b.pos.y) < persep) {
          steer.add(b.pos);
          tot++;
        }
      }
      if (tot > 0) {
        steer.div(tot);
        steer.sub(pos);
        steer.setMag(maxSpeed);
        steer.sub(vel);
        steer.limit(cohForce);
      }
      return steer;  
    }
    
    PVector seap(ArrayList<Boid> boids) {
      PVector steer = new PVector();
      int per = 30;
      int tot = 0;
      for (Boid b: boids) {
        float d = dist(pos.x, pos.y, b.pos.x, b.pos.y);
        if (b != this && d < persep) {
          PVector diff = PVector.sub(pos, b.pos);
          diff.div(d);
          steer.add(diff);
          tot++;
        }
      }
      if (tot > 0) {
        steer.div(tot);
        steer.setMag(maxSpeed);
        steer.sub(vel);
        steer.limit(sepForce);
      }
      return steer;  
    }
    
    PVector avoid(ArrayList<Block> blocks) {
      PVector steer = new PVector(0,0);
      int per = 70;
      int tot = 0;
      for (Block b: blocks) {
        float d = dist(pos.x, pos.y, b.pos.x, b.pos.y);
        if (d < per) {
          PVector diff = new PVector().sub(pos, b.pos);
          diff.div(d);
          steer.add(diff);
          tot++;
        }
      }
      if (tot != 0) {
        steer.div(tot);
        steer.setMag(maxSpeed);
        steer.sub(vel);
        steer.limit(obsForce);
      }
      return steer;
    }
    
    void flock(ArrayList<Boid> boids, ArrayList<Block> blocks) {
      acc.set(0,0);
      acc.add(align(boids));
      acc.add(cohe(boids));
      acc.add(seap(boids));
      acc.add(avoid(blocks));
      edge();
    }  
    void edge() {
      if (pos.x > width)  { pos.x = 0;      }
      else if (pos.x < 0) { pos.x = width;  }
      if (pos.y > height) { pos.y = 0;      }
      else if (pos.y < 0) { pos.y = height; }
    }
}
