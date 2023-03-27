
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
  void update(LineOfSight line) {
    for (int i = -(this.lines.length/2); i < this.lines.length/2 + 1; i++) { // All line
      Point currentPos = new Point(line.start.x, line.start.y); // First point of the line of sight

      float previousX = line.pointOfView.x-line.start.x; // center x on 0 to help rotation
      float previousY = line.pointOfView.y - line.start.y; // center y on 0 to help rotation
      float theta = i*0.0015*(width/nbLineOfView); // Angle of rotation
      Point watch = new Point(previousX * cos(theta) - previousY * sin(theta) + line.start.x, previousY * cos(theta) + previousX * sin(theta) + line.start.y); // Second point of the line of sight

      lines[i+this.lines.length/2] = new LineOfSight(currentPos, watch); // Line From curentPos to watch
      lines[i+this.lines.length/2].setEnd(lines[i+this.lines.length/2].end.x, lines[i+this.lines.length/2].end.y); //Make the line go to a wall
    }
  }

  /*
  Display all the line of the line of sight
   */
  void display() {
    for (int i = 0; i < lines.length; i++) {
      lines[i].display();
    }
  }

  void updateCollision(Map map) {
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
        this.lines[i].angle = false;
        
        if (i > 0) {
          if (lines[i-1].cellCollided%map.largeur != lines[i].cellCollided%map.largeur && lines[i-1].cellCollided%map.longeur != lines[i].cellCollided%map.longeur) {
            lines[i].angle = true;
            lines[i-1].angle = true;
          }
        }
        
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
  void displayCollision(boolean all) {
    for (int i = 0; i < this.lines.length; i++) {
      this.lines[i].displayCollision(all);
    }
  }

  /*
  Display the vision in 3d
   */
  void display3d(Map map) {
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
Point[] addPoint(Point point, Point[] points) {
  Point[] temp = new Point[points.length+1];
  for (int i = 0; i < points.length; i++) {
    temp[i] = points[i];
  }
  temp[points.length] = point;
  return temp;
}
