class Point {
  float x;
  float y;
  
  Point() {
    x = 0;
    y = 0;
  }
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void setX(float x) {
    this.x = x;
  }
  
  void display (boolean t) {
    if (t) {
      stroke(0,255,0, 0);
    } else {
      stroke(0,255,0, 255); 
    }
    strokeWeight(10);
    point(this.x, this.y);
  }
}



class LineOfSight extends Line {
  float distanceToObstacle;
  int cellCollided;
  Point collision;
  Point[] collisions;
  boolean borderCollided;
  
  Point pointOfView;
  
  
  LineOfSight (Point start, Point end) {
    super(start, end); 
    distanceToObstacle = 3000;
    collision = new Point();
    collisions = new Point[0];
  }
  
  void SetCollision(Point col) {
    this.collision = col; 
  }
  
  void setCellColided(int cell) {
    this.cellCollided = cell; 
    this.borderCollided = false;
  }
  
  void setBorderCollided() {
    this.borderCollided = true;
  }
  
  void addCollision(Point p) {
    Point [] temp = new Point[this.collisions.length+1];
    for (int i = 0; i < this.collisions.length; i++) {
      temp[i] = collisions[i];
    }
    temp[this.collisions.length] = p;
    this.collisions = temp;
  }
  
  void displayCollision(boolean all) {
    if (all) {
      for (int i = 0; i < collisions.length; i++) {
        this.collisions[i].display(false);
      }
    } else {
      this.collision.display(false);
    }
    
  }
  
  /*
  Display the wall, the ceiling and the ground at the row x of the display based on the distanceToObstacle of this object 
  */
  void display3d(int x, Map map) {
    float topAndBot = this.distanceToObstacle / 2; // Size of ground / ceilling (they both have the same size)
    
    stroke(#956400);
    strokeWeight(2);
    line(x, 0, x, height); // Line that represent ground and ceilling
    
    if (this.borderCollided) { // If the collision is on a border we paint it grey otherwise we paint it the color of the obstacle
      stroke(150);
    } else {
      stroke(map.grid[this.cellCollided].color3d);
    }
    
    line(x, topAndBot, x, height - topAndBot); //Line that represent the wall
    
    stroke(0);
    strokeWeight(10);
    point(x, topAndBot); //The two point at the top and bottom of the wall to create a proper delimitation between wall / ceiling
    point(x, height - topAndBot);
  }
  
  void updateVision() {
    setEnd(this.pointOfView.x, this.pointOfView.y);
  }
  
  void setEnd(float x, float y) {
    this.end.x = x;
    this.end.y = y;
    
    float lgX = max(this.end.x, this.start.x) - min(this.end.x, this.start.x);
    float lgY = max(this.end.y, this.start.y) - min(this.end.y, this.start.y);
    
    lgX = this.end.x < this.start.x ? -lgX : lgX;
    lgY = this.end.y < this.start.y ? -lgY : lgY;
    while(this.end.x >= 0 && this.end.x <= width && this.end.y >= 0 && this.end.y <= height) {
      this.end.x += lgX;
      this.end.y += lgY;
    }
    this.end.x = (int)this.end.x;
    this.end.y = (int)this.end.y;
  }
  
  void setStart(float x, float y) {
    this.start.x = x;
    this.start.y = y;
  }
}

class Line {
  Point start;
  Point end;
  
  Line (Point a, Point b) {
    this.start = a;
    this.end = b;
  }
  
  void display() {
    stroke(0,0,255);
    strokeWeight(2);
    line(start.x, start.y, end.x, end.y);
  }
  
  /*
  Calculate point of intersection of two lines
  */
  Point LineIntersect (Line line) {
    Point intersection;
    
    /*
    Begin by calculating the line equation :
    Ax + By = C
    
    with for both line:
    A = y2 - y1
    B = x1 - x2
    C = Ax1 + By1
    
    */
    
    float A1 = line.end.y - line.start.y;
    float B1 = line.start.x - line.end.x;
    float C1 = A1 * line.start.x + B1 * line.start.y;
    
    float A2 = this.end.y - this.start.y;
    float B2 = this.start.x - this.end.x;
    float C2 = A2 * this.start.x + B2 * this.start.y;
    
    /*
    Then we resolve the system: (since we are resolving 2 lines equation there can be only combination of (x, y) that resolve this equation) (we dont take in consideration parallel line and colinear line)
    | C1 = A1x + B1y
    | C2 = A2x + B2y
    
    Equation for x :
    
    =>  |B2 * C1 = B2 * A1 * x + B2 * B1 * y              Multiplied by B2
        |B1 * C2 = B1 * A2 * x + B1 * B2 * y              Multiplied by B1
        
    =>  B2 * C1 - B1 * C2 = B2 * A1 * x - B1 * A2 * x     Substract line2 to line1 (from now on we will only focus on the first line)
    
    =>  B2 * C1 - B1 * C2 = x * (B2 * A1 - B1 * A2)       Put x as factor
    
    =>  (B2 * C1 - B1 * C2) / (B2 * A1 - B1 * A2) = x     Divide by (B2 * A1 - B1 * A2)
    
    We have the x equation of the point of intersection
    
    
    Equation for y :
    
    =>  |A2 * C1 = A2 * A1 * x + A2 * B1 * y              Multiplied by A2
        |A1 * C2 = A1 * A2 * x + A1 * B2 * y              Multiplied by A1
        
    =>  A1 * C2 - A2 * C1 = A1 * B2 * y - A2 * B1 * y     Substract line 1 to line 2
    
    =>  A1 * C2 - A2 * C1 = y * (A1 * B2 - A2 * B1)       Put y as factor
    
    => (A1 * C2 - A2 * C1) / (A1 * B2 - A2 * B1) = y      Divide by (A1 * B2 - A2 * B1)
        
    We now have the x and y equation :)
    */
    
    float denominator = (B2 * A1 - B1 * A2);
    
    float x;
    float y;
    
    if (denominator != 0) {
      x = (B2 * C1 - B1 * C2) / denominator;
      y = (A1 * C2 - A2 * C1) / denominator;
    } else {
      x = 0;
      y = 0;
    }
  
    intersection = new Point(x, y);
    return intersection;
  }
  /*
  Use Line intersection to get the intersection of two line then calculate if the point found is on both line if so, return the point else return null
  */
  Point SegmentIntersect(Line line) {
    Point intersection = this.LineIntersect(line);
    
    boolean isOnFirstLine = false;
    boolean isOnSecondLine = false;
    
    if ((this.start.x <= intersection.x && intersection.x <= this.end.x) || (this.end.x <= intersection.x && intersection.x <= this.start.x)) {
      isOnFirstLine = ((this.start.y <= intersection.y && intersection.y <= this.end.y) || (this.end.y <= intersection.y && intersection.y <= this.start.y));
    }
    
    if ((line.start.x <= intersection.x && intersection.x <= line.end.x) || (line.end.x <= intersection.x && intersection.x <= line.start.x)) {
      isOnSecondLine = ((line.start.y <= intersection.y && intersection.y <= line.end.y) || (line.end.y <= intersection.y && intersection.y <= line.start.y));
    }
  
    if (isOnFirstLine && isOnSecondLine) {
      return intersection;
    } else {
      return null;
    }
  }
  
  
}
