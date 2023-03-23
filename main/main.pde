int longeurCase = 50;
int largeurCase = 50;

Map terrain;

int startingCell;

Point a;
Point b;
LineOfSight line;
Vision view; 

boolean [] obstacles;

int start, end;



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
  b = new Point();
  
  line = new LineOfSight(a, b); 
  view = new Vision(line, 1, 175);
}

void draw() {
  background(200);
  
  
  start = millis();
  terrain.display();
  end = millis();
  println("Time for map display : " + (end-start));
  
  start = millis();
  line.setEnd(mouseX, mouseY);
  end = millis();
  println("Time for vision update : " + (end-start));
  
  start = millis();
  view.update(line);
  end = millis();
  println("Time for update view : " + (end-start));
  
  start = millis();
  view.display();
  end = millis();
  println("Time for view display : " + (end-start));
  
  start = millis();
  view.displayCollision(terrain);
  end = millis();
  println("Time for collision display : " + (end-start));
  
  start = millis();
  view.display3d();
  end = millis();
  println("Time for collision display : " + (end-start));
  
  for (int i = 0; i < 15; i++) {
    println();
  }
  println("------------------------------------------------");
}
