/**
  Classe simulant un fluide. Elle est représentée par un rectangle.
*/
class Fluid {
  float quarterHeight;
  Rectangle r;
  float density;
  float coefficientFriction;
  
  Fluid () {
    quarterHeight = random(0.1*height, 0.4*height);
    r = new Rectangle(0, height - quarterHeight, width, quarterHeight);
    density = random(1.5, 3);
    coefficientFriction = 0.1;
  }
  
  Fluid (Rectangle _r, float _density, float _coefficientFriction) {
    r = _r;
    density = _density;
    coefficientFriction = _coefficientFriction;
  }
  
  void setRectangle (Rectangle _r) {
    r = _r;
  }
  
  Rectangle getRectangle () {
    return r;
  }
  
  void display () {
    fill(random(255),random(255),random(255));
    r.display();
    fill(random(255),random(255),random(255));
    text(fluids.get(0).density, width/2-8, height-(fluids.get(0).quarterHeight/2));
    text("Alexis Michaud", width/2-32, height - (fluids.get(0).quarterHeight/2-10));
  }
  
  /**
  Formule F = -0.5 * rho * ||v||^2 * area * friction * speed.normalise
  */
  PVector draggingForce(PVector speed, float area) {
    float speedMag = speed.mag();
    float coeffRhoMag = density * coefficientFriction * speedMag * speedMag * 0.5;
    
    PVector result = speed.get();
    result.mult(-1);
    result.normalize();
    result.mult(area);
    result.mult(coeffRhoMag);
   
    return result;
  }
}
