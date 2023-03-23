class Point {
  int x;
  int y;
  
  Point() {
    x = 0;
    y = 0;
  }
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void display () {
    stroke(0,255,0);
    strokeWeight(10);
    point(this.x, this.y);
  }
}

class LineOfSight extends Line {
  int distanceToObstacle;
  Point collision;
  
  
  LineOfSight (Point start, Point end) {
    super(start, end); 
    distanceToObstacle = 3000;
    collision = new Point();
  }
  
  void SetCollision(Point col) {
    this.collision = col; 
  }
  
  void displayCollision() {
    this.collision.display();
  }
  
  void setEnd(int x, int y) {
    this.end.x = x;
    this.end.y = y;
    
    int lgX = max(this.end.x, this.start.x) - min(this.end.x, this.start.x);
    int lgY = max(this.end.y, this.start.y) - min(this.end.y, this.start.y);
    
    lgX = this.end.x < this.start.x ? -lgX : lgX;
    lgY = this.end.y < this.start.y ? -lgY : lgY;
    while(this.end.x >= 0 && this.end.x <= width && this.end.y >= 0 && this.end.y <= height) {
      this.end.x += lgX;
      this.end.y += lgY;
    }
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
    
    int A1 = line.end.y - line.start.y;
    int B1 = line.start.x - line.end.x;
    int C1 = A1 * line.start.x + B1 * line.start.y;
    
    int A2 = this.end.y - this.start.y;
    int B2 = this.start.x - this.end.x;
    int C2 = A2 * this.start.x + B2 * this.start.y;
    
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
    
    int denominator = (B2 * A1 - B1 * A2);
    
    int x;
    int y;
    
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
