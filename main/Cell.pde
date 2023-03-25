class Cell {
   //coordinate of the top left corner
  int posX;
  int posY;
  
  //Size of the cell
  int largeur;
  int longeur;
  
  boolean obstacle; //true if the cell is an obstacle
  
  //Color of the cell in 3d
  int color3d;
  
  Cell(boolean obstacle, int x, int y, int largeur, int longeur) {
    this.obstacle = obstacle;
    this.posX = x;
    this.posY = y;
    this.largeur = largeur;
    this.longeur = longeur;
    this.color3d = 0;
  }
  
  void setColor(int color3d) {
    this.color3d = color3d;
  }
  
  /*
  Display the cell in black if it is an obstacle and in white if it is a normal cell
  */
  void display() {
    int cellColor = this.obstacle ? 0 : 255;
    
    strokeWeight(2);
    stroke(0);
    fill(cellColor);
      
    rect(this.posX, this.posY, this.largeur, this.longeur); 
  }
}
