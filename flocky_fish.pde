ArrayList<Boid> flock;
int fishAmount = 200;

ArrayList<Block> blocks;

boolean track;
int chosen;

int count;

void setup() {
  //fullScreen();
  size(800, 800);
  println(fishAmount);
  flock = new ArrayList<Boid>();
  for (int i=0; i<fishAmount; i++) {flock.add(new Boid());}
  flock.add(new Boid());
  blocks = new ArrayList<Block>();
  track = false;
  chosen = int(random(flock.size()));
  count = 0;
}

void draw() {
  frameRate(60);
  background(51);
  for (int i=0; i<flock.size(); i++) {
    flock.get(i).show(); 
    flock.get(i).update();
    flock.get(i).flock(flock, blocks);
  }
  for (Block b: blocks){
    b.show(); 
  }
  count++;
}

void keyPressed() {
  if (key == 'a') {
    flock.add(new Boid());
  }
  if (flock.size() == 0) {
    for (int i=0; i<fishAmount; i++) {flock.add(new Boid());}
  }
  if (key == 'd' && flock.size() > 0) {
    flock.remove(0); 
  }
  if (key == 'z') {
    blocks.add(new Block()); 
  }
  if (key == 'x' && blocks.size() > 0) {
    blocks.remove(0); 
  }
  if (key == 't' && flock.size() > 0) {
    track = !track;
    if (track) {
      for (int i=0; i<flock.size(); i++) {
        if (i != chosen) { 
          flock.get(i).display = false;
        }
      }
    }else{
      for (Boid b: flock) {
        b.display = true; 
      }
    }
  }
  if (key == 'r') {
    chosen = int(random(flock.size()));
  }
}
