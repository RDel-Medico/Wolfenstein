class Map {
  Cell[] grid; // All the cell of the map
  int nbCell; // Amount of cell in total
  int largeur; // Amount of cell in on line

  Map(int largeurMap, int longeurMap, int largeurCase, int longeurCase) {
    int nbCellLargeur = (largeurMap - largeurMap%largeurCase) / largeurCase;
    int nbCellLongeur = (longeurMap - longeurMap%longeurCase) / longeurCase;
    
    this.largeur = nbCellLargeur;
    
    this.nbCell = nbCellLargeur*nbCellLongeur;
    
    this.grid = new Cell[nbCell];
    
    for (int i = 0; i < nbCellLargeur; i++) {
      for (int j = 0; j < nbCellLongeur; j++) {
        this.grid[j*nbCellLargeur + i] = new Cell(false, i*largeurCase, j*longeurCase, largeurCase, longeurCase);
      }
    }
  }
  
  /*
  Will set the 3d color of each obstacle cell and create each obstacle based on the given array
  (true in the array at the index i will make the cell at the index i in this.grid an obstacle)
  
  PARAM : 
    -  obstacle : boolean array (the size of this array is equal to this.nbCell)
  */
  void setObstacle(boolean [] obstacle) {
    int color3d = 0;
    for (int i = 0; i < this.nbCell; i++) { // After each row, we add 15 to the 3d color of the cell
      if (i % this.largeur == 0) {
        color3d += 15;
      }
      this.grid[i].obstacle = obstacle[i];
      this.grid[i].setColor(color3d);
    }
  }
  
  /*
  display the grid in 2d
  */
  void display() {
    for (int i = 0; i < this.nbCell; i++) {
      this.grid[i].display();
    }
  }
}
