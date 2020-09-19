int nbMovers = 50;

Mover[] movers;
Fluid fluid;
Fluid fluid2;

Mover helium;
ArrayList<Fluid> fluids = new ArrayList();

void setup () {
  size (800, 600);
  movers = new Mover[nbMovers];
  
  
  
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover();
    movers[i].mass = random (1, 5);
    movers[i].radius = i;
    movers[i].location.x = random(800);
    movers[i].location.y = random(600);
  }
  
  helium=new Mover(44, random(800), random(600), 44);
  
  if(fluids.size()>0){
    fluids.remove(0);
  }
  
}


float xOff = 0.0;
float n;
    PVector wind = new PVector(0,0);

void update() {
  
  for (int i = 0; i < movers.length; i++) {
  
    if(fluids.size()>0){
      if (fluids.get(0).getRectangle().intersect(movers[i].getRectangle())) {   
        PVector fForce = fluids.get(0).draggingForce(movers[i].velocity, movers[i].mass);
        movers[i].applyForce(fForce);
      }
    }
    PVector helium = new PVector (0, -0.01);
    float m = movers[i].mass;
    PVector gravity = new PVector (0, 0.1 * m);
    PVector friction = movers[i].velocity.get();
    
    friction.normalize();
    friction.mult(-0.8);
    friction.mult(0.02);
    if (mousePressed) {
      if(mouseButton==RIGHT){
        wind.x=random(0,0.2);
        movers[i].applyForce(wind);
      }
      if(mouseButton==LEFT){
        wind.x=random(-0.2,0);
        movers[i].applyForce(wind);
      }
    }
    movers[i].applyForce(gravity);
    movers[i].applyForce(friction);
    
    movers[i].update();
    movers[i].checkEdges();
  }
    float heliumm = helium.mass;
    PVector frictionn = helium.velocity.get();
    
    frictionn.normalize();
    frictionn.mult(-1);
    frictionn.mult(0.02);
    
    PVector heliumg=new PVector(0,0.1*-heliumm);
    helium.applyForce(wind);
    helium.applyForce(heliumg);
    helium.applyForce(frictionn);
    
    helium.update();
    helium.checkEdges();
}

void keyPressed() {
  /*if (key == ' ') {
    for (int i = 0; i < movers.length; i++) {
      movers[i].location.y = movers[i].size.y;
    }
  }*/
  
  if (key == 'r') {
    setup();
  }
}


void render () {
  background (255);
  
  if(keyPressed){
    if(key == ' ' && fluids.size()==0){
      fluids.add(new Fluid());
    }
    else if(key == ' ' && fluids.size()>0){
      fluids.remove(0);
    }
    keyPressed=false;
  }
  
  if(fluids.size()>0){
    fluids.get(0).display();
  }
  fill(100, 200, 100);

  for (int i = 0; i < movers.length; i++) {
    movers[i].display();
  }
}



void draw () {
  update();
  render();
  helium.display();
    
}
