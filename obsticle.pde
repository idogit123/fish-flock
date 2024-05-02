class Block {
  PVector pos;  
  
  Block() {
    pos = new PVector(random(0, width), random(0, height));
  }
  
  void show() {
    stroke(255);
    strokeWeight(2);
    fill(255, 255, 0, 200);
    rect(pos.x, pos.y, 16, 16); 
  }
}
