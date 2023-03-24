class Cell {
  int posX;
  int posY;
  int largeur;
  int longeur;
  boolean obstacle;
  int red;
  int blue;
  int green;
  
  Cell(boolean obstacle, int x, int y, int largeur, int longeur) {
    this.obstacle = obstacle;
    this.posX = x;
    this.posY = y;
    this.largeur = largeur;
    this.longeur = longeur;
    this.red = 0;
    this.blue = 0;
    this.green = 0;
  }
  
  void setColor(int red, int green, int blue) {
    this.red = red;
    this.blue = blue;
    this.green = green;
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
