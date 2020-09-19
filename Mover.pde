class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float radius;
  
  PVector size; 
  float topSpeed;
  float mass;
  
  Mover () {
    
    this.location = new PVector (random (width), random (height));    
    this.velocity = new PVector (0, 0);
    this.acceleration = new PVector (0 , 0);
    this.size = new PVector (16, 16);
    
    this.mass = 1;
  }  
  
  Mover (PVector loc, PVector vel) {
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);
    this.size = new PVector (16, 16);
    this.topSpeed = 100;
  }
  
  Mover (float m, float x, float y, float r) {
    mass = m;
    location = new PVector (x, y);
    
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    // size = new PVector (16, 16);
    radius = r;
  }
  
  void update () {
    velocity.add (acceleration);
    location.add (velocity);

    acceleration.mult (0);
  }
  
  void display () {
    stroke (0);
    fill (random(255),random(255),random(255));
    
    ellipse (location.x, location.y, 2*radius, 2*radius); // Dimension à l'échelle de la masse
  }
  
  void checkEdges() {
    if (location.x > width-radius) {
      location.x = width-radius;
      velocity.x *= -1;
    } else if (location.x < 0+radius) {
      velocity.x *= -1;
      location.x = 0+radius;
    }
    
    if (location.y > height-radius) {
      velocity.y *= -.9;
      location.y = height-radius;
    }
    
    if (location.y < 0+radius) {
      velocity.y *= -.9;
      location.y = 0+radius;
    }
  }
  
  
  void applyForce (PVector force) {
    PVector f = PVector.div (force, mass);
   
    this.acceleration.add(f);
  }
  
  Rectangle getRectangle() {
    Rectangle r = new Rectangle(location.x, location.y, size.x, size.y);
    
    return r;
  }
}
