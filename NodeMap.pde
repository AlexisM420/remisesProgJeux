/********************
  Énumération des directions
  possibles
  
********************/
enum Direction {
  EAST, SOUTH, WEST, NORTH
}

/********************
  Représente une carte de cellule permettant
  de trouver le chemin le plus court entre deux cellules
  
********************/
class NodeMap extends Matrix {
  Node start;
  Node end;
  
  ArrayList <Node> path;
  
  boolean debug = false;
  
  NodeMap (int nbRows, int nbColumns) {
    super (nbRows, nbColumns);
  }
  
  NodeMap (int nbRows, int nbColumns, int bpp, int width, int height) {
    super (nbRows, nbColumns, bpp, width, height);
  }
  
  void init() {
    
    cells = new ArrayList<ArrayList<Cell>>();
    
    for (int j = 0; j < rows; j++){
      // Instanciation des rangees
      cells.add (new ArrayList<Cell>());
      
      for (int i = 0; i < cols; i++) {
        Cell temp = new Node(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        
        // Position matricielle
        temp.i = i;
        temp.j = j;
        
        cells.get(j).add (temp);
      }
    }
    
    println ("rows : " + rows + " -- cols : " + cols);
  }
  
  /*
    Configure la cellule de départ
  */
  void setStartCell (int i, int j) {
    
    if (start != null) {
      start.isStart = false;
      start.setFillColor(color (200, 200, 0));
    } 
    
    start = (Node)cells.get(j).get(i);
    start.isStart = true;
    
    start.setFillColor(color (200, 200, 0));
  }
  
  /*
    Configure la cellule de fin
  */
  void setEndCell (int i, int j) {
    
    if (end != null) {
      end.isEnd = false;
      end.setFillColor(color (0, 200, 200));
    }
    
    end = (Node)cells.get(j).get(i);
    end.isEnd = true;
    
    end.setFillColor(color (0, 200, 200));
  }
  
  /** Met a jour les H des cellules
  doit etre appele apres le changement du noeud
  de debut ou fin
  */
  void updateHs() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node current = (Node)cells.get(j).get(i); 
        current.setH( calculateH(current));
        current.setFillColor(color (0,127,0));
      }
    }
  }
  
  // Permet de generer aleatoirement le cout de deplacement
  // entre chaque cellule
  void randomizeMovementCost() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        
        int cost = parseInt(random (0, cols)) + 1;
        
        Node current = (Node)cells.get(j).get(i);
        current.setMovementCost(cost);
       
      }
    }
  }
  
  // Permet de generer les voisins de la cellule a la position indiquee
  void generateNeighbours(int i, int j) {
    Node c = (Node)getCell (i, j);
    if (debug) println ("Current cell : " + i + ", " + j);
    
    
    for (Direction d : Direction.values()) {
      Node neighbour = null;
      
      switch (d) {
        case EAST :
          if (i < cols - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i + 1, j);
          }
          break;
        case SOUTH :
          if (j < rows - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j + 1);
          }
          break;
        case WEST :
          if (i > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i - 1, j);
          }
          break;
        case NORTH :
          if (j > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j - 1);
          }
          break;
      }
      
      if (neighbour != null) {
        if (neighbour.isWalkable) {
          c.addNeighbour(neighbour);
        }
      }
    }
  }
  
  /**
    Génère les voisins de chaque Noeud
    Pas la méthode la plus efficace car ça
    prend beaucoup de mémoire.
    Idéalement, on devrait le faire au besoin
  */
  void generateNeighbourhood() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        generateNeighbours(i, j);
      }
    }
  }
  
  /*
    Permet de trouver le chemin le plus court entre
    deux cellules
  */
  void findAStarPath () {
    // TODO : Complétez ce code
    // DONE
    
    if (start == null || end == null) {
      println ("No start and no end defined!");
      return;
    } else {
    ArrayList<Node> open_list= new ArrayList<Node>();
    ArrayList<Node> closed_list= new ArrayList<Node>();
    Node current_node = start;
    open_list.add(start);

    while(current_node != end && open_list.size() != 0 && end.parent == null)
    {
      current_node = getLowestCost(open_list);
      if(current_node.equals(end))
      {
        continue;
      }else
      {
        open_list.remove(current_node);
        closed_list.add(current_node);
        for(int i=0; i < current_node.neighbours.size(); i++)
        {
          Node nghb = current_node.neighbours.get(i);
          if(nghb.isWalkable==false||closed_list.contains(nghb))
          {
            continue;
          }
          if(!open_list.contains(nghb))
          {
            open_list.add(nghb);
            nghb.parent=current_node;
          } 
          else
          {
            int d = current_node.getG() +calculateCost(current_node,nghb);
            if(d < nghb.getG())
            {
              nghb.parent=current_node;
            }
          } 
            
        }
      }
      
      
    }
    
    

    generatePath();
    }
   
  }
  
  /*
    Permet de générer le chemin une fois trouvée
  */
  void generatePath () {
    // TODO : Complétez ce code
    // DONE
    path= new ArrayList<Node>();
    Node par = end.parent;
    while(par != start)
    {
      path.add(par);
      par.setFillColor(color (127,127, 0));
      par=par.parent;
    }
  }
  
  /**
  * Cherche et retourne le noeud le moins couteux de la liste ouverte
  * @return Node le moins couteux de la liste ouverte
  */
  private Node getLowestCost(ArrayList<Node> openList) {    //find best node
    // TODO : Complétez ce code
    // DONE
    Node best = openList.get(0);
    Node cn = null;
    
    for(int i=1; i < openList.size(); i++)
    {
      cn=openList.get(i);
      if(cn.getH() < best.getH())
      {
        best = cn;
      }
      else if(cn.getH() == best.getH())
      {
        if(best.getF() > cn.getF())
        {
          best = cn;
        }
        else if(best.getH() == cn.getH() && best.getG() > cn.getG())
        {
          best = cn;
        }
      }
    }
    return best;
  }
  

  
 /**
  * Calcule le coût de déplacement entre deux noeuds
  * @param nodeA Premier noeud
  * @param nodeB Second noeud
  * @return
  */
  private int calculateCost(Cell nodeA, Cell nodeB) {
    // TODO : Complétez ce code
    int costX = Math.abs(nodeB.x-nodeA.x);
    int costY = Math.abs(nodeB.y-nodeA.y);
    int cost = (costX*costX) + (costY*costY);
    return cost;
  }
  
  /**
  * Calcule l'heuristique entre le noeud donnée et le noeud finale
  * @param node Noeud que l'on calcule le H
  * @return la valeur H
  */
  private int calculateH(Cell node) {
    
    int d = int(dist(node.i, node.j, end.i, end.j));
    
    return d;
  }
  
  String toStringFGH() {
    String result = "";
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        Node current = (Node)cells.get(j).get(i);
        
        result += "(" + current.getF() + ", " + current.getG() + ", " + current.getH() + ") ";
      }
      
      result += "\n";
    }
    
    return result;
  }
  
  // Permet de créer un mur à la position _i, _j avec une longueur
  // et orientation données.
  void makeWall (int _i, int _j, int _length, boolean _vertical) {
    int max;
    
    if (_vertical) {
      max = _j + _length > rows ? rows: _j + _length;  
      
      for (int j = _j; j < max; j++) {
        ((Node)cells.get(j).get(_i)).setWalkable (false, 0);
      }       
    } else {
      max = _i + _length > cols ? cols: _i + _length;  
      
      for (int i = _i; i < max; i++) {
        ((Node)cells.get(_j).get(i)).setWalkable (false, 0);
      }     
    }
  }
}
