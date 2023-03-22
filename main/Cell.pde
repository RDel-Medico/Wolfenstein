class Cell {
  int posX;
  int posY;
  int largeur;
  int longeur;
  boolean obstacle;
  
  Cell(boolean obstacle, int x, int y, int largeur, int longeur) {
    this.obstacle = obstacle;
    this.posX = x;
    this.posY = y;
    this.largeur = largeur;
    this.longeur = longeur;
  }
  
  void display() {
    strokeWeight(2);
    stroke(0);
    fill(255);
    
    if (this.obstacle)
      fill(0);
      
    rect(this.posX, this.posY, this.largeur, this.longeur); 
  }

}
