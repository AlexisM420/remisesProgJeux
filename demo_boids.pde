int currentTime;
int previousTime;
int deltaTime;

private DebugLine debugLine;

boolean debug = true;

ArrayList<Mover> flock;
int flockSize = 5;

Circle a;
Circle b;
boolean visibility;

void setup () {
  //fullScreen(P2D);
  size (800, 600);
  currentTime = millis();
  previousTime = millis();
  
  flock = new ArrayList<Mover>();
  
  a = new Circle(random(40,400-40), random(40,height-40), 40);
  b = new Circle(random(440,800-40), random(40,height-40), 40);
  b.fillColor = color(0, 200, 200);
  visibility = true;
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }

  flock.get(0).debug = true;
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();  
}

/***
  The calculations should go here
*/
void update(int delta) {
  
  for (Mover m : flock) {
    m.flock(flock);
    m.update(delta);
    
    if(visibility != false){
      if(a.isCollidingCircle(m.moverBoundingBox())){
        m.location.x=b.location.x+b.radius;
        m.location.y=b.location.y+b.radius;
      }
    }
  }
}

/***
  The rendering should go here
*/
void display () {
  background(0);
  
  if(visibility == true){
    a.display();
    b.display();
  }
  
  for (Mover m : flock) {
    m.display();

  }
}


void keyPressed() {
  switch (key) {
    case 'd':
      flock.get(0).debug = !flock.get(0).debug;
      break;
      
    case ' ':
    visibility = !visibility;
      break;
      
    case 'r':
    setup();
      break;
  }
}

void mousePressed() {
    Mover m = new Mover(new PVector(mouseX, mouseY), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
}
