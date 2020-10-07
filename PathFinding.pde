NodeMap worldMap;

int deltaTime = 0;
int previousTime = 0;

int mapRows = 100;
int mapCols = 100;

color baseColor = color (0, 127, 0);

void setup () {
  //size (420, 420);
  fullScreen();
  
  initMap();
}

void draw () {
  deltaTime = millis () - previousTime;
  previousTime = millis();
  
  update(deltaTime);
  display();
}

void update (float delta) {
}

void display () {
  
  if (worldMap.path != null) {
    for (Cell c : worldMap.path) {
      c.setFillColor(color (127, 0, 0));
    }
  }
  
  worldMap.display();
}

void initMap () {
  worldMap = new NodeMap (mapRows, mapCols); 
  
  worldMap.setBaseColor(baseColor);
  
  do
  {
    worldMap.setStartCell((int)random(0, mapCols), (int)random(0, mapRows));
  }while(worldMap.start.isWalkable == false);
  
  do{
    worldMap.setEndCell((int)random(0, mapCols),(int)random(0, mapRows));
  }while(worldMap.end.isWalkable == false);
  
   //<>//
  
  // Mise à jour de tous les H des cellules
  worldMap.updateHs();
  
  for(int i=0; i < (int)random(4, 12); i++)
  {
  worldMap.makeWall ((int)random(0, mapRows), (int)random(0,mapCols), (int)random(5,65), true);
  worldMap.makeWall ((int)random(0, mapRows), (int)random(0,mapCols), (int)random(5,65), false);
  }
    
  worldMap.generateNeighbourhood(); //<>//
      
  worldMap.findAStarPath();
}
