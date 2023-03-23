Map terrain = new Map(700, 700, 50, 50);
Point a = new Point((int)random(0,400), (int)random(0,400));
Point b = new Point((int)random(0,400), (int)random(0,400));
LineOfSight line = new LineOfSight(a, b); 
Vision view = new Vision(line, 1, 300);

boolean [] obstacles = new boolean[terrain.nbCell];

int start, end;



void setup() {
  size(700, 700);
  
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i] = ((int)random(50))%3 == 1;
  }


  terrain.setObstacle(obstacles);
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
  
  for (int i = 0; i < 15; i++) {
    println();
  }
  println("------------------------------------------------");
}
