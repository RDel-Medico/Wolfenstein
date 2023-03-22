class Vision {
  LineOfSight[] lines;
  int ecart;
  int nbLine;
  
  Vision(LineOfSight line, int ecart, int nbLine) {
    this.lines = new LineOfSight[nbLine+1];
    this.ecart = ecart;
    this.nbLine = nbLine;
    
    update(line);
  }
  
  void update(LineOfSight line) {
    int ecartX;
    int ecartY;
    
    if (abs(line.x2-line.x1) < abs(line.y2-line.y1)) { //Si c'est plutôt sur le côté
      ecartX = this.ecart;
      ecartY = 0;
    } else {  //Si c'est plutôt sur le haut
      ecartY = this.ecart;
      ecartX = 0;
    }
    
    for (int i = 0; i < (this.nbLine - (this.nbLine%2)) / 2; i++) { // On trace toutes les lignes de vision à gauche de la ligne centrale
      lines[i] = new LineOfSight(line.x1, line.y1, line.x2-i*ecartX, line.y2-i*ecartY);
    }
    
    lines[(nbLine - (nbLine%2)) / 2] = line; // On trace la ligne centrale
    
    for (int i = ((nbLine - (nbLine%2)) / 2) + 1; i < nbLine + 1; i++) {  // On trace toutes les lignes de vision à droite de la ligne centrale
      lines[i] = new LineOfSight(line.x1, line.y1, line.x2+(i-((nbLine - (nbLine%2)) / 2))*ecartX, line.y2+(i-((nbLine - (nbLine%2)) / 2))*ecartY);
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
    for (int i = 0; i < this.nbLine; i++) {
      for (int j = 0; j < map.nbCell; j++) {
        
        
        if (surfaceCrossedByLine(lines[i], map.map[j])) {
          fill(0,255,0);
          strokeWeight(2);
          stroke(0);
          rect(map.map[j].posX, map.map[j].posY, map.map[j].longeur, map.map[j].largeur);
        }
      }
    }
  }
  
}




boolean surfaceCrossedByLine(LineOfSight line, Cell surface) {
  int top = line.y2 > line.y1 ? line.y2 : line.y1;
  int bot = line.y2 <= line.y1 ? line.y2 : line.y1;
        
  int right = line.x2 > line.x1 ? line.x2 : line.x1;
  int left = line.x2 <= line.x1 ? line.x2 : line.x1;
        
  if (left < surface.posX) { // Si la ligne part a gauche de la surface
    if (right < surface.posX) { // Si la ligne finit a gauche de la surface
      return false;
    } else { //Croise la surface d'un point de vue x
      if (bot < surface.posY) { // Part d'au dessus
        if (top > surface.posY) {
          return true;
        } else {
          return false;
        }
      } else if (surface.posY < bot && bot < surface.posY + surface.longeur) { // part au même niveau d'un point de vue y
        return true;
      } else { // part d'en dessous
        return false;
      }
    }
  } else if (surface.posX < left && left < surface.posX + surface.largeur) { // Si la ligne part aligné à la surface en x
    if (bot < surface.posY) { //Si la ligne part d'au dessus de la surface
      if (top > surface.posY) {
        return true;
      } else {
        return false;
      }
    } else if (surface.posY < bot && bot < surface.posY + surface.longeur) { // Si la ligne part aligné à la surface en y
      return true;
    } else {
      return false;
    }
    
  } else { //Si la ligne part à droite de la surface
    return false;
  }
}
