int longeurCase = 100;
int largeurCase = 100;

Map terrain;

int startingCell;

float currentX;
float currentY;

Point a;
Point b;
LineOfSight line;
Vision view; 

boolean [] obstacles;

int start, end;

int previousMouseX = 0;

boolean display3d = true;
boolean display2d = false;


void setup() {
  size(700, 700);
  
  terrain = new Map(width, height, longeurCase, largeurCase);
  obstacles = new boolean[terrain.nbCell];
  
  startingCell = (int)random(terrain.nbCell);
  
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i] = ((int)random(50))%3 == 1;
  }
  
  terrain.setObstacle(obstacles);
  
  while(terrain.map[startingCell].obstacle) {
    startingCell = (int)random(terrain.nbCell);
  }
  
  a = new Point(terrain.map[startingCell].posX + longeurCase / 2, terrain.map[startingCell].posY + largeurCase / 2);
  currentX = terrain.map[startingCell].posX + longeurCase / 2;
  currentY = terrain.map[startingCell].posY + largeurCase / 2;
  b = new Point(terrain.map[startingCell].posX + longeurCase / 2, terrain.map[startingCell].posY);
  
  line = new LineOfSight(a, b);
  line.pointOfView = new Point(terrain.map[startingCell].posX + longeurCase / 2, terrain.map[startingCell].posY);
  view = new Vision(line, 1, 700);
}

void keyPressed() {
  
  if (keyCode == 'O') {
    display3d = !display3d;
  }
  
  if (keyCode == 'P') {
    display2d = !display2d;
  }
  float directionX = 0;
  float directionY = 0;
  if (keyCode == 'Z') {
    directionX = line.pointOfView.x - currentX;
    directionY = line.pointOfView.y - currentY;
    
    currentY += directionY / 10;
    currentX += directionX / 10;
    line.pointOfView.y += directionY / 10;
    line.pointOfView.x += directionX / 10;
  }
  
  if (keyCode == 'Q') {
    if (line.pointOfView.y < line.start.y) {
      line.pointOfView.x--;
    } else {
      line.pointOfView.x++;
    }
    
    if (line.pointOfView.x < line.start.x) {
      line.pointOfView.y++;  
    } else {
      line.pointOfView.y--;
    }
  }
  if (keyCode == 'D') {
    if (line.pointOfView.y < line.start.y) {
      line.pointOfView.x++;  
    } else {
      line.pointOfView.x--;
    }
    
    if (line.pointOfView.x < line.start.x) {
      line.pointOfView.y--;  
    } else {
      line.pointOfView.y++;
    }
  }
}

void draw() {
  background(200);
  
  /*
    start = millis();
    //terrain.display();
    end = millis();
    println("Time for map display : " + (end-start));
  */
  
  start = millis();
  line.updateVision();
  end = millis();
  println("Time for vision update : " + (end-start));
  
  start = millis();
  line.setStart(currentX, currentY);
  end = millis();
  println("Time for vision update : " + (end-start));
  
  start = millis();
  view.update(line);
  end = millis();
  println("Time for update view : " + (end-start));
  /*
  start = millis();
  //view.display();
  end = millis();
  println("Time for view display : " + (end-start));
  */
  
  start = millis();
  view.updateCollision(terrain);
  end = millis();
  println("Time for collision update : " + (end-start));
  
  /*
  start = millis();
  //view.displayCollision();
  end = millis();
  println("Time for collision display : " + (end-start));
  */
  
  if (display2d) {
    
    line.pointOfView.display();
    
    start = millis();
    terrain.display();
    end = millis();
    println("Time for map display : " + (end-start));
    
    start = millis();
    view.display();
    end = millis();
    println("Time for view display : " + (end-start));
    
    start = millis();
    view.displayCollision();
    end = millis();
    println("Time for collision display : " + (end-start));
  }
  
  if (display3d) {
    start = millis();
    view.display3d(terrain);
    end = millis();
    println("Time for 3d display : " + (end-start)); 
  }
  
  for (int i = 0; i < 15; i++) {
    println();
  }
  println("------------------------------------------------");
}
