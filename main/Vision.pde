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
    
    if (abs(line.end.x-line.start.x) < abs(line.end.y-line.start.y)) { //Si c'est plutôt sur le côté
      ecartX = this.ecart;
      ecartY = 0;
    } else {  //Si c'est plutôt sur le haut
      ecartY = this.ecart;
      ecartX = 0;
    }
    
    for (int i = 0; i < (this.nbLine - (this.nbLine%2)) / 2; i++) { // On trace toutes les lignes de vision à gauche de la ligne centrale
      lines[i] = new LineOfSight(new Point(line.start.x, line.start.y), new Point(line.end.x-i*ecartX, line.end.y-i*ecartY));
    }
    
    lines[(nbLine - (nbLine%2)) / 2] = line; // On trace la ligne centrale
    
    for (int i = ((nbLine - (nbLine%2)) / 2) + 1; i < nbLine + 1; i++) {  // On trace toutes les lignes de vision à droite de la ligne centrale
      lines[i] = new LineOfSight(new Point(line.start.x, line.start.y), new Point(line.end.x+(i-((nbLine - (nbLine%2)) / 2))*ecartX, line.end.y+(i-((nbLine - (nbLine%2)) / 2))*ecartY));
    }
  }
  
  
  void display() {
    for (int i = 0; i < lines.length; i++) {
      lines[i].display();
    }
  }
  
  void updateCollision(Map map) {
    for (int i = 0; i < this.lines.length; i++) {
      Point [] allCollision = new Point[0];
      for (int j = 0; j < map.map.length; j++) {
        if (map.map[j].obstacle) {
          Point collid = null;
          if (this.lines[i].start.x < map.map[j].posX) { // Si on est a gauche de l'obstacle
            //Detection collision entre lines[i] && ligne gauche de l'obstacle
            collid = this.lines[i].SegmentIntersect(new Line(new Point(map.map[j].posX, map.map[j].posY), new Point(map.map[j].posX, map.map[j].posY + map.map[j].longeur)));
          } else if (this.lines[i].start.x > map.map[j].posX + map.map[j].largeur) { // Si on est a droite de l'obstable
            //Detection collision entre lines[i] && ligne droite de l'obstacle
            collid = this.lines[i].SegmentIntersect(new Line(new Point(map.map[j].posX + map.map[j].largeur, map.map[j].posY), new Point(map.map[j].posX + map.map[j].largeur, map.map[j].posY + map.map[j].longeur)));
          }
          
          if (collid != null) {
              Point[] temp = new Point [allCollision.length + 1];
              for (int k = 0; k < allCollision.length; k++) {
                temp[k] = allCollision[k];
              }
              temp[allCollision.length] = collid;
              allCollision = temp;
            }
            
            
          if (this.lines[i].start.y > map.map[j].posY + map.map[j].longeur) { // Si on est dessous l'obstable
            //Detection collision entre lines[i] && ligne dessous de l'obstacle
            collid = this.lines[i].SegmentIntersect(new Line(new Point(map.map[j].posX, map.map[j].posY + map.map[j].longeur), new Point(map.map[j].posX + map.map[j].largeur, map.map[j].posY + map.map[j].longeur)));
          } else if (this.lines[i].start.y < map.map[j].posY) { // Si on est au dessus de l'obstacle
            //Detection collision entre lines[i] && ligne haut de l'obstacle
            collid = this.lines[i].SegmentIntersect(new Line(new Point(map.map[j].posX, map.map[j].posY), new Point(map.map[j].posX + map.map[j].largeur, map.map[j].posY)));
          }
          if (collid != null) {
              Point[] temp = new Point [allCollision.length + 1];
              for (int k = 0; k < allCollision.length; k++) {
                temp[k] = allCollision[k];
              }
              temp[allCollision.length] = collid;
              allCollision = temp;
            }
        }
      }
      
      int indexPlusProche = 0;
      int distanceMin = 3000;
      for (int j = 0; j < allCollision.length; j++) { // Uniquement le plus proche
        if (distanceMin > (int)sqrt((max(allCollision[j].x, this.lines[i].start.x)-min(allCollision[j].x, this.lines[i].start.x))+(max(allCollision[j].y, this.lines[i].start.y)-min(allCollision[j].y, this.lines[i].start.y)))) {
          indexPlusProche = j;
          distanceMin = (int)sqrt((max(allCollision[j].x, this.lines[i].start.x)-min(allCollision[j].x, this.lines[i].start.x))+(max(allCollision[j].y, this.lines[i].start.y)-min(allCollision[j].y, this.lines[i].start.y)));
        }
      }
      if (allCollision.length > 0) {
        if (distanceMin <= this.lines[i].distanceToObstacle) {
          this.lines[i].distanceToObstacle = distanceMin;
          this.lines[i].SetCollision(allCollision[indexPlusProche]);
        }
      }
    } 
  }
  
  void displayCollision(Map map) {
    updateCollision(map);
    for (int i = 0; i < this.lines.length; i++) {
      this.lines[i].displayCollision(); 
    }
  }
}
