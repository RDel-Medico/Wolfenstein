class LineOfSight {
  int x1;
  int x2;
  int y1;
  int y2;
  
  LineOfSight(int x, int y, int destX, int destY) {
    this.x1 = x;
    this.x2 = destX;
    this.y1 = y;
    this.y2 = destY;
  }
  
  void setEnd(int x, int y) {
    this.x2 = x;
    this.y2 = y;
  }
  
  void display(boolean center) {
    stroke(255,0,0);
    strokeWeight(1);
      
    if (center) {
      stroke(0,0,255);
      strokeWeight(5);
    }
    
    line(x1, y1, x2, y2); 
  }
}
