class Map {
  Cell[] map;
  int nbCell;
  int largeur;

  Map(int largeurMap, int longeurMap, int largeurCase, int longeurCase) {
    int nbCellLargeur = (largeurMap - largeurMap%largeurCase) / largeurCase;
    int nbCellLongeur = (longeurMap - longeurMap%longeurCase) / longeurCase;
    
    this.largeur = nbCellLargeur;
    
    this.nbCell = nbCellLargeur*nbCellLongeur;
    
    this.map = new Cell[nbCell];
    
    for (int i = 0; i < nbCellLargeur; i++) {
      for (int j = 0; j < nbCellLongeur; j++) {
        this.map[j*nbCellLargeur + i] = new Cell(false, i*largeurCase, j*longeurCase, largeurCase, longeurCase);
      }
    }
  }
  
  void setObstacle(boolean [] obstacle) {
    int red = 0;
    int green = 0;
    int blue = 0;
    for (int i = 0; i < this.nbCell; i++) {
      if (i % this.largeur == 0) {
        red += 15;
        green += 15;
        blue += 15;
      }
      map[i].obstacle = obstacle[i];
      map[i].setColor(red, green, blue);
    }
  }
  
  void display() {
    for (int i = 0; i < this.nbCell; i++) {
      map[i].display();
    }
  }
}
