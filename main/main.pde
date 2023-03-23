Map terrain = new Map((int)random(300,600), (int)random(300,600), 50, 50);
Point a = new Point((int)random(0,400), (int)random(0,400));
Point b = new Point((int)random(0,400), (int)random(0,400));
Line line = new Line(a, b); 
Vision view = new Vision(line, 1, 100);

boolean [] obstacles = new boolean[terrain.nbCell];





void setup() {
  size(700, 700);
  
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i] = ((int)random(50))%3 == 1;
  }


  terrain.setObstacle(obstacles);
}

void draw() {
  background(200);
  terrain.display();
  line.setEnd(mouseX, mouseY);
  view.update(line);
  view.display();
  view.displayCollision(terrain);
}
