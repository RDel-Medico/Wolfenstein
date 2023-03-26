
/*
This class represent a classic point with two coordinate x and y => representing the point (x, y)
 */
class Point {
  float x;
  float y;

  Point() { // Default constructor at (0, 0)
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

  void display () {
    stroke(0, 255, 0);
    strokeWeight(10);
    point(this.x, this.y);
  }
}

/*
This class represent a classic line with two point, point a and point b => represent the line between a and b
 */
class Line {
  Point start;
  Point end;

  Line (int x1, int y1, int x2, int y2) {
    this.start = new Point(x1, y1);
    this.end = new Point(x2, y2);
  }

  Line (Point a, Point b) {
    this.start = a;
    this.end = b;
  }

  void display() {
    stroke(0, 0, 255);
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

    if ((this.start.x <= intersection.x && intersection.x <= this.end.x) || (this.end.x <= intersection.x && intersection.x <= this.start.x)) { // Check if the point of intersection is on the first segment
      isOnFirstLine = ((this.start.y <= intersection.y && intersection.y <= this.end.y) || (this.end.y <= intersection.y && intersection.y <= this.start.y));
    }

    if ((line.start.x <= intersection.x && intersection.x <= line.end.x) || (line.end.x <= intersection.x && intersection.x <= line.start.x)) { // Check if the point of intersection is on the second segment
      isOnSecondLine = ((line.start.y <= intersection.y && intersection.y <= line.end.y) || (line.end.y <= intersection.y && intersection.y <= line.start.y));
    }

    if (isOnFirstLine && isOnSecondLine) { // If the point of intersection is on both segment then the segment
      return intersection;
    } else {
      return null;
    }
  }
}

/*
This class represent a line of sight wich extend a normal line it represent what is seen  from the start of the line to the end
 */
class LineOfSight extends Line {
  float distanceToObstacle; // Distance to the collided obstacle
  int cellCollided; // Index of the cell collided (-1 if it collid a border)
  Point collision; // closest Point of collision
  Point[] collisions; // All the point of collision (usefull for debug)
  Point pointOfView; //Point to get the direction of the view (The line of sight is a prolongation of the segment (playerX, playerY) to (pointOfView.x, pointOfView.y))


  LineOfSight (Point start, Point end) {
    super(start, end);
    distanceToObstacle = integerLimit;
    collision = new Point();
    collisions = new Point[0];
  }

  void SetCollision(Point col) {
    this.collision = col;
  }

  void setCellColided(int cell) {
    this.cellCollided = cell;
  }

  void displayCollision(boolean all) { // all is an option for debug when set to true it display all the collision and not only the closest
    if (all) {
      for (int i = 0; i < collisions.length; i++) {
        this.collisions[i].display();
      }
    } else {
      this.collision.display();
    }
  }


  /*
  Detect if this line of sight collid with a border (should return a value each time but sometimes return null)
   
   RETURN : The point of collision with the border or null if there is no point of collision found
   */
  Point collidBorder() {
    Point collid = this.SegmentIntersect(new Line(0, 0, width, 0)); // Collid become point of collision with top border
    if (collid == null) {
      collid = this.SegmentIntersect(new Line(0, height, width, height)); // Collid become point of collision with bottom border
      if (collid == null) {
        collid = this.SegmentIntersect(new Line(0, 0, 0, height)); // Collid become point of collision with left border
        if (collid == null) {
          collid = this.SegmentIntersect(new Line(width, 0, width, height)); // Collid become point of collision with right border
        }
      }
    }
    return collid;
  }

  /*
  Detect if this line of sight collid with the top or bottom side of cell in parameter (should return a value each time but sometimes return null)
   
   RETURN : The point of collision with the top or bottom side of the cell or null if there is no point of collision found
   */
  Point collidY (Cell cell) {

    if (this.start.y > cell.posY + cell.longeur) { // If we are under the cell

      Line bottomObstacle = new Line(cell.posX, cell.posY + cell.longeur, cell.posX + cell.largeur, cell.posY + cell.longeur); // Bottom side of the obstacle
      return this.SegmentIntersect(bottomObstacle); //Detection of collision between lines[i] and bottom side of the obstacle
    } else if (this.start.y < cell.posY) { // If we are on top of the obstacle

      Line topObstacle = new Line(cell.posX, cell.posY, cell.posX + cell.largeur, cell.posY); // Top side of the obstacle
      return this.SegmentIntersect(topObstacle); //Detection of collision between lines[i] and top side of the obstacle
    }
    return null;
  }

  Point collidX (Cell cell) {

    if (this.start.x < cell.posX) { // If the player is on the left of the cell

      Line leftObstacle = new Line(cell.posX, cell.posY, cell.posX, cell.posY + cell.longeur); // Left side of the obstacle
      return this.SegmentIntersect(leftObstacle); //Detection of collision between lines[i] and left side of the obstacle
    } else if (this.start.x > cell.posX + cell.largeur) { // If we are on the right of the cell

      Line rightObstacle = new Line(cell.posX + cell.largeur, cell.posY, cell.posX + cell.largeur, cell.posY + cell.longeur); // Right side of the obstacle
      return this.SegmentIntersect(rightObstacle); //Detection of collision between lines[i] and right side of the obstacle
    }
    return null;
  }

  /*
  Display the wall, the ceiling and the ground at the row x of the display based on the distanceToObstacle of this object
   */
  void display3d(int x, Map map) {
    float topAndBot = this.distanceToObstacle / 2; // Size of ground / ceilling (they both have the same size)

    if (this.cellCollided == -1) { // If the collision is on a border we paint it grey otherwise we paint it the color of the obstacle
      stroke(150);
    } else {
      stroke(map.grid[this.cellCollided].color3d);
    }

    strokeWeight(width / nbLineOfView);
    line(x, topAndBot, x, height - topAndBot); //Line that represent the wall

    //The two point at the top and bottom of the wall to create a proper delimitation between wall / ceiling
    stroke(0);
    strokeWeight(10);
    point(x, topAndBot);
    point(x, height - topAndBot);
  }

  /*
  Update this line of sight
   */
  void updateVision() {
    setEnd(this.pointOfView.x, this.pointOfView.y);
  }

  /*
  Move the end of this line of sight till it go offscreen
   */
  void setEnd(float x, float y) {
    this.end.x = x;
    this.end.y = y;

    float lgX = max(this.end.x, this.start.x) - min(this.end.x, this.start.x); //x value to keep the line at the same angle
    float lgY = max(this.end.y, this.start.y) - min(this.end.y, this.start.y); //y value to keep the line at the same angle

    lgX = this.end.x < this.start.x ? -lgX : lgX;
    lgY = this.end.y < this.start.y ? -lgY : lgY;

    while (this.end.x >= 0 && this.end.x <= width && this.end.y >= 0 && this.end.y <= height) { // Till it is not out of screen we add x and y
      this.end.x += lgX;
      this.end.y += lgY;
    }

    //Conversion to int for better intersection calculation
    this.end.x = (int)this.end.x;
    this.end.y = (int)this.end.y;
  }

  void setStart(float x, float y) {
    this.start.x = x;
    this.start.y = y;
  }
}
