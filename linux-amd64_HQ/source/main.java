/* autogenerated by Processing revision 1286 on 2023-03-25 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class main extends PApplet {

final int integerLimit = 2147483647;

//Size of a cell on the map
int longeurCase = 100;
int largeurCase = 100;

Map terrain; // The map

int startingCell; // The starting cell for the player

//Coordinate of the player
float currentX;
float currentY;

//The center line of the vision
Point a;
Point b;
LineOfSight line;

//Vision of the player
Vision view; 

//All the obstacle
boolean [] obstacles;

//The number of line in the view
int nbLineOfView = 700; // This can be 700, 350, 140, 100, 70, 50, 28, 20, 14, 10, 4, 2

//Used for debug (calcul time of function)
int start, end;

//Debug option
boolean display3d = true;
boolean display2d = false;
boolean displayAllCollision = false;
boolean displayTest = false;


 public void setup() {
  /* size commented out by preprocessor */;
  //Map génération
  terrain = new Map(width, height, longeurCase, largeurCase);
  
//---------------------------OBSTACLE GENERATION-------------------------------
  obstacles = new boolean[terrain.nbCell];
  
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i] = ((int)random(50))%3 == 1;
  }
  
  terrain.setObstacle(obstacles);
//-----------------------------------------------------------------------------

//---------------------------PLAYER POSITION-----------------------------------
  startingCell = (int)random(terrain.nbCell);
  
  while(terrain.grid[startingCell].obstacle) {
    startingCell = (int)random(terrain.nbCell);
  }
  
  currentX = terrain.grid[startingCell].posX + longeurCase / 2;
  currentY = terrain.grid[startingCell].posY + largeurCase / 2;
//-----------------------------------------------------------------------------

//---------------------------PLAYER LINE OF SIGHT------------------------------
  a = new Point(terrain.grid[startingCell].posX + longeurCase / 2, terrain.grid[startingCell].posY + largeurCase / 2);
  b = new Point(terrain.grid[startingCell].posX + longeurCase / 2, terrain.grid[startingCell].posY);
  
  line = new LineOfSight(a, b);
  line.pointOfView = new Point(terrain.grid[startingCell].posX + longeurCase / 2, terrain.grid[startingCell].posY);
//-----------------------------------------------------------------------------

  //Player view
  view = new Vision(nbLineOfView);
}

 public void keyPressed() {
  
  if (keyCode == 'O') { //Debug option to display the 3d render
    display3d = !display3d;
  }
  
  if (keyCode == 'P') { // Debug option to display the 2d render
    display2d = !display2d;
  }
  
  if (keyCode == 'I') { // Debug option to display all the collision
    displayAllCollision = !displayAllCollision;
  }
  
  float directionX = 0;
  float directionY = 0;
  
  if (keyCode == 'Z') { // Go forward
  
    if (view.lines[view.lines.length/2].distanceToObstacle > 10) {
      directionX = line.pointOfView.x - currentX;
      directionY = line.pointOfView.y - currentY;
      
      // Move the player
      currentY += (int)(directionY / 10);
      currentX += (int)(directionX / 10);
      
      //Move the pointOfView
      line.pointOfView.y += (int)(directionY / 10);
      line.pointOfView.x += (int)(directionX / 10);
    }
  }
  
  if (keyCode == 'Q') { // Turning the camera to the left
    
    //Move the point of view
    line.pointOfView.x += line.pointOfView.y < line.start.y ? -1 : 1;
    line.pointOfView.y += line.pointOfView.x < line.start.x ? 1 : -1;
    
  }
  if (keyCode == 'D') { // Turning the camera to the right
    line.pointOfView.x += line.pointOfView.y < line.start.y ? 1 : -1;
    line.pointOfView.y += line.pointOfView.x < line.start.x ? -1 : 1;
  }
}

 public void draw() {
  background(200);
  
  start = millis();
  line.setStart(currentX, currentY); // Update player position
  end = millis();
  println("Time for vision update : " + (end-start));
  
  start = millis();
  view.update(line); // update the view
  end = millis();
  println("Time for update view : " + (end-start));
  
  start = millis();
  view.updateCollision(terrain); // update the collision of the view
  end = millis();
  println("Time for collision update : " + (end-start));
  
  start = millis();
  line.updateVision(); // update the vision
  end = millis();
  println("Time for vision update : " + (end-start));
  
  if (display2d) { // if there is the debug option for 2d render
    
    start = millis();
    terrain.display(); // We display the map
    end = millis();
    println("Time for map display : " + (end-start));
    
    start = millis();
    view.display(); // We display the view
    end = millis();
    println("Time for view display : " + (end-start));
    
    start = millis();
    view.displayCollision(displayAllCollision); // We display the closest collision (or all collision if there is the debug option for)
    end = millis();
    println("Time for collision display : " + (end-start));
  }
  
  if (display3d) {
    start = millis();
    displayBackground();
    view.display3d(terrain); // We display the 3d render
    end = millis();
    println("Time for 3d display : " + (end-start)); 
  }
  
  fill(255, 255, 255);
  text("Press P for 2d rendering", 10, 20);
  text("Press O for 3d rendering", 10, 40);
  text("Press I to render all collision Point", 10, 60);
  text("Press Q to watch on your left", 10, 80);
  text("Press D to watch on your right", 10, 100);
  text("Press Z to walk forward", 10, 120);
  
  println("------------------------------------------------");
}

 public void displayBackground() {
  noStroke();
  for (int i = 0; i < 40; i++) {
    fill(50+i*10, i, i);
    rect(0, i*10, width, 10);
  }
  for (int i = 0; i < 40; i++) {
    fill(50+i*10, i, i);
    rect(0, height - i*10-10, width, 10);
  }
}
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
  
   public void setColor(int color3d) {
    this.color3d = color3d;
  }
  
  /*
  Display the cell in black if it is an obstacle and in white if it is a normal cell
  */
   public void display() {
    int cellColor = this.obstacle ? 0 : 255;
    
    strokeWeight(2);
    stroke(0);
    fill(cellColor);
      
    rect(this.posX, this.posY, this.largeur, this.longeur); 
  }
}

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

   public void setX(float x) {
    this.x = x;
  }

   public void display () {
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

   public void display() {
    stroke(0, 0, 255);
    strokeWeight(2);
    line(start.x, start.y, end.x, end.y);
  }

  /*
  Calculate point of intersection of two lines
   */
   public Point LineIntersect (Line line) {
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
   public Point SegmentIntersect(Line line) {
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

   public void SetCollision(Point col) {
    this.collision = col;
  }

   public void setCellColided(int cell) {
    this.cellCollided = cell;
  }

   public void displayCollision(boolean all) { // all is an option for debug when set to true it display all the collision and not only the closest
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
   public Point collidBorder() {
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
   public Point collidY (Cell cell) {

    if (this.start.y > cell.posY + cell.longeur) { // If we are under the cell

      Line bottomObstacle = new Line(cell.posX, cell.posY + cell.longeur, cell.posX + cell.largeur, cell.posY + cell.longeur); // Bottom side of the obstacle
      return this.SegmentIntersect(bottomObstacle); //Detection of collision between lines[i] and bottom side of the obstacle
    } else if (this.start.y < cell.posY) { // If we are on top of the obstacle

      Line topObstacle = new Line(cell.posX, cell.posY, cell.posX + cell.largeur, cell.posY); // Top side of the obstacle
      return this.SegmentIntersect(topObstacle); //Detection of collision between lines[i] and top side of the obstacle
    }
    return null;
  }

   public Point collidX (Cell cell) {

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
   public void display3d(int x, Map map) {
    float topAndBot = this.distanceToObstacle / 2; // Size of ground / ceilling (they both have the same size)

    if (this.cellCollided == -1) { // If the collision is on a border we paint it grey otherwise we paint it the color of the obstacle
      stroke(150);
    } else {
      stroke(map.grid[this.cellCollided].color3d);
    }

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
   public void updateVision() {
    setEnd(this.pointOfView.x, this.pointOfView.y);
  }

  /*
  Move the end of this line of sight till it go offscreen
   */
   public void setEnd(float x, float y) {
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

   public void setStart(float x, float y) {
    this.start.x = x;
    this.start.y = y;
  }
}

/*
This class represent the vision of something it is composed of lines, each line representing a column of pixel on a 3d representation.
 */
class Vision {
  LineOfSight[] lines; // All the line of sight of this vision

  Vision(int nbLine) {
    this.lines = new LineOfSight[nbLine+1];
  }

  /*
  Update all the line the vision centered around line
   
   PARAM : line : line at the center of the vision
   */
   public void update(LineOfSight line) {
    for (int i = -(this.lines.length/2); i < this.lines.length/2 + 1; i++) { // All line
      Point currentPos = new Point(line.start.x, line.start.y); // First point of the line of sight

      float previousX = line.pointOfView.x-line.start.x; // center x on 0 to help rotation
      float previousY = line.pointOfView.y - line.start.y; // center y on 0 to help rotation
      float theta = i*0.0015f*(width/nbLineOfView); // Angle of rotation
      Point watch = new Point(previousX * cos(theta) - previousY * sin(theta) + line.start.x, previousY * cos(theta) + previousX * sin(theta) + line.start.y); // Second point of the line of sight

      lines[i+this.lines.length/2] = new LineOfSight(currentPos, watch); // Line From curentPos to watch
      lines[i+this.lines.length/2].setEnd(lines[i+this.lines.length/2].end.x, lines[i+this.lines.length/2].end.y); //Make the line go to a wall
    }
  }

  /*
  Display all the line of the line of sight
   */
   public void display() {
    for (int i = 0; i < lines.length; i++) {
      lines[i].display();
    }
  }

   public void updateCollision(Map map) {
    for (int i = 0; i < this.lines.length; i++) { // For each line of sight

      this.lines[i].collisions = new Point[0];
      Point [] allCollision = new Point[0];
      int [] indexCollision = new int[0];

      for (int j = 0; j < map.grid.length; j++) { // On all cell
        if (map.grid[j].obstacle) { // If the cell is an obstacle

          Point collidX = this.lines[i].collidX(map.grid[j]); // We check if the line of sight collid with the left or right side of the current cell
          Point collidY = this.lines[i].collidY(map.grid[j]); // We check if the line of sight collid with the top or bottom side of the current cell

          if (collidX != null) { // If there is collision with the left or right side of the current cell, we save the collision
            allCollision = addPoint(collidX, allCollision);
            indexCollision = append(indexCollision, j);
          }

          if (collidY != null) { // If there is collision with the top or bottom side of the current cell, we save the collision
            allCollision = addPoint(collidY, allCollision);
            indexCollision = append(indexCollision, j);
          }
        }
      }

      Point collidBorder = this.lines[i].collidBorder(); // We check if the line of sight collid with the border

      if (collidBorder != null) { // If there is collision with the border, we save the collision
        allCollision = addPoint(collidBorder, allCollision);
        indexCollision = append(indexCollision, -1);
      }

      this.lines[i].collisions = allCollision; // We save all the collision (usefull for the debug tool)


      int indexPlusProche = 0; // Contain the index of the closest cell hit (or -1 if the closest collision is a border)
      float distanceMin = integerLimit; // Contain the distance to the closest collision from the player

      for (int j = 0; j < allCollision.length; j++) { // We check all the collision to find the closest

        float longeur = max(allCollision[j].x, this.lines[i].start.x)-min(allCollision[j].x, this.lines[i].start.x);
        float hauteur = (max(allCollision[j].y, this.lines[i].start.y)-min(allCollision[j].y, this.lines[i].start.y));

        if (distanceMin > sqrt(pow(longeur, 2) + pow(hauteur, 2))) {

          indexPlusProche = j;
          distanceMin = sqrt(pow(longeur, 2)+pow(hauteur, 2));
        }
      }

      if (allCollision.length > 0) {
        
        this.lines[i].distanceToObstacle = distanceMin; //Save distance to the point of collision
        this.lines[i].SetCollision(allCollision[indexPlusProche]); // Save collision point
        this.lines[i].setCellColided(indexCollision[indexPlusProche]);
        
      } else { // If we didn't found a collision (wich is not supposed to append but append sometimes) we simply copy all the value from a neighbour line
      
        int neighbour = i == 0 ? 1 : -1; // We choose an existing neighbour

        this.lines[i].distanceToObstacle = this.lines[i+neighbour].distanceToObstacle;
        this.lines[i].collision = this.lines[i+neighbour].collision;
        this.lines[i].cellCollided = this.lines[i+neighbour].cellCollided;
        
      }
    }
  }

  /*
  Display all collsion in 2d
   */
   public void displayCollision(boolean all) {
    for (int i = 0; i < this.lines.length; i++) {
      this.lines[i].displayCollision(all);
    }
  }

  /*
  Display the vision in 3d
   */
   public void display3d(Map map) {
    for (int i = 0; i < this.lines.length; i++) {
      this.lines[i].display3d(i*(width / nbLineOfView), map);
    }
  }
}

/*
add a point at the end of a tab and return it
 PARAM :
 - point : the point we want to add to the tab
 - points : the tab in wich we want to add the point
 
 RETURN : The tab passed in parameters with point added to the end
 */
 public Point[] addPoint(Point point, Point[] points) {
  Point[] temp = new Point[points.length+1];
  for (int i = 0; i < points.length; i++) {
    temp[i] = points[i];
  }
  temp[points.length] = point;
  return temp;
}
/*
This class represent a rectangular map composed of rectangular cell, and each of this cell can be a normal cell or an obstacle
 */
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
   public void setObstacle(boolean [] obstacle) {
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
   public void display() {
    for (int i = 0; i < this.nbCell; i++) {
      this.grid[i].display();
    }
  }
}


  public void settings() { size(700, 700); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
