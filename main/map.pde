class Map {
  Cell[] map;
  int nbCell;

  Map(int largeurMap, int longeurMap, int largeurCase, int longeurCase) {
    int nbCellLargeur = (largeurMap - largeurMap%largeurCase) / largeurCase;
    int nbCellLongeur = (longeurMap - longeurMap%longeurCase) / longeurCase;
    
    this.nbCell = nbCellLargeur*nbCellLongeur;
    
    this.map = new Cell[nbCell];
    
    for (int i = 0; i < nbCellLargeur; i++) {
      for (int j = 0; j < nbCellLongeur; j++) {
        this.map[j*nbCellLargeur + i] = new Cell(false, i*largeurCase, j*longeurCase, largeurCase, longeurCase);
      }
    }
  }
  
  void setObstacle(boolean [] obstacle) {
    for (int i = 0; i < this.nbCell; i++) {
      map[i].obstacle = obstacle[i];
    }
  }
  
  void display() {
    for (int i = 0; i < this.nbCell; i++) {
      map[i].display();
    }
  }
}
