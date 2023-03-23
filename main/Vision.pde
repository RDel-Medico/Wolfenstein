class Vision {
  Line[] lines;
  int ecart;
  int nbLine;
  
  Vision(Line line, int ecart, int nbLine) {
    this.lines = new Line[nbLine+1];
    this.ecart = ecart;
    this.nbLine = nbLine;
    
    update(line);
  }
  
  void update(Line line) {
    int ecartX;
    int ecartY;
    
    if (abs(line.end.x-line.start.x) < abs(line.end.y-line.start.y)) { //Si c'est plutôt sur le côté
      ecartX = this.ecart;
      ecartY = 0;
    } else {  //Si c'est plutôt sur le haut
      ecartY = this.ecart;
      ecartX = 0;
    }
    
    for (int i = 0; i < (this.nbLine - (this.nbLine%2)) / 2; i++) { // On trace toutes les lignes de vision à gauche de la ligne centrale
      lines[i] = new Line(new Point(line.start.x, line.start.y), new Point(line.end.x-i*ecartX, line.end.y-i*ecartY));
    }
    
    lines[(nbLine - (nbLine%2)) / 2] = line; // On trace la ligne centrale
    
    for (int i = ((nbLine - (nbLine%2)) / 2) + 1; i < nbLine + 1; i++) {  // On trace toutes les lignes de vision à droite de la ligne centrale
      lines[i] = new Line(new Point(line.start.x, line.start.y), new Point(line.end.x+(i-((nbLine - (nbLine%2)) / 2))*ecartX, line.end.y+(i-((nbLine - (nbLine%2)) / 2))*ecartY));
    }
  }
  
  
  void display() {
    for (int i = 0; i < lines.length; i++) {
      if (i == (lines.length - (lines.length%2)) / 2) {
        lines[i].display(true);
      } else {
        lines[i].display(false); 
      }
    }
  }
  
  void displayCollision(Map map) {
    for (int i = 0; i < this.lines.length; i++) {
      for (int j = 0; j < map.map.length; j++) {
        if (map.map[j].obstacle) {
          if (this.lines[i].start.x < map.map[j].posX) { // Si on est a gauche de l'obstacle
            //Detection collision entre lines[i] && ligne gauche de l'obstacle
          } else if (this.lines[i].start.x > map.map[j].posX + map.map[j].largeur) { // Si on est a droite de l'obstable
            //Detection collision entre lines[i] && ligne droite de l'obstacle
          }
          
          if (this.lines[i].start.y > map.map[j].posY + map.map[j].longeur) { // Si on est dessous l'obstable
            //Detection collision entre lines[i] && ligne dessous de l'obstacle
          } else if (this.lines[i].start.y < map.map[j].posY) { // Si on est au dessus de l'obstacle
            //Detection collision entre lines[i] && ligne haut de l'obstacle
          }
        }
      }
    }
  }
  
}
