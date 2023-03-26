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
int nbLineOfView = 350; // This can be 700, 350, 140, 100, 70, 50, 28, 20, 14, 10, 4, 2

//Used for debug (calcul time of function)
int start, end;

//Debug option
boolean display3d = true;
boolean display2d = false;
boolean displayAllCollision = false;
boolean displayTest = false;

boolean []keyPresseds = new boolean[3]; // [0] = true if Z is pressed, [1] = true if Q is pressed, [2] = true if D is pressed

void setup() {
  size(700, 700);
  //Map génération
  terrain = new Map(width, height, longeurCase, largeurCase);
  
  //Generation of obstacle and player 
  mapGeneration();

  //Player view
  view = new Vision(nbLineOfView);
}

void keyPressed() {
  
  if (keyCode == 'O') { //Debug option to display the 3d render
    display3d = !display3d;
  }
  
  if (keyCode == 'P') { // Debug option to display the 2d render
    display2d = !display2d;
  }
  
  if (keyCode == 'I') { // Debug option to display all the collision
    displayAllCollision = !displayAllCollision;
  }
  
  if (keyCode == 'U') { // Fast reset of the map
    //Regeneration of obstacle and player 
    mapGeneration();
  }
  
  if (keyCode == 'Z') { // Go forwar
    keyPresseds[0] = true;
  }
  
  if (keyCode == 'Q') { // Turning the camera to the left
    keyPresseds[1] = true;
  }
  if (keyCode == 'D') { // Turning the camera to the right
    keyPresseds[2] = true;
  }
}

void keyReleased() {
  if (keyCode == 'Z') { // Stop going forward
    keyPresseds[0] = false;
  }
  
  if (keyCode == 'Q') { // Stop turning the camera left
    keyPresseds[1] = false;
  }
  
  if (keyCode == 'D') { // Stop turning the camera right
    keyPresseds[2] = false;
  }
}

void draw() {
  background(200);
  
  manageMovement();
  
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
  text("Press R to reset the map", 10, 80);
  text("Press Q to watch on your left", 10, 100);
  text("Press D to watch on your right", 10, 120);
  text("Press Z to walk forward", 10, 140);
  
  println("------------------------------------------------");
}

void displayBackground() {
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

void manageMovement() {
  if (keyPresseds[0]) {
    float directionX = 0;
    float directionY = 0;
  
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
  
  if (keyPresseds[1]) {
    //Move the point of view
    line.pointOfView.x += line.pointOfView.y < line.start.y ? -1 : 1;
    line.pointOfView.y += line.pointOfView.x < line.start.x ? 1 : -1;
  }
  
  //Move the point of view
  if (keyPresseds[2]) {
    line.pointOfView.x += line.pointOfView.y < line.start.y ? 1 : -1;
    line.pointOfView.y += line.pointOfView.x < line.start.x ? -1 : 1;
  }
}

void mapGeneration() {
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
}
