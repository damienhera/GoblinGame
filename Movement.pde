boolean left, right, up, down, shift, leftClick, rightClick, mouseClick; //is set to true when mouse buttons are clicked;

void keyPressed()
{
  //check button pushed
  if(key == 'w' || key == 'W'){up = true;}
  if(key == 'a' || key == 'A'){left = true;}
  if(key == 's' || key == 'S'){down = true;}
  if(key == 'd' || key == 'D'){right = true;}
}
  
void keyReleased()
{
  //check button released
  if(key == 'w' || key == 'W'){up = false;}
  if(key == 'a' || key == 'A'){left = false;}
  if(key == 's' || key == 'S'){down = false;}
  if(key == 'd' || key == 'D'){right = false;}
}
  
void mousePressed() //check mouse buttons clicked
{
  if(menuCheck)
  {
    if (mouseX >= x && mouseX <= x+bWidth && mouseY >= y && mouseY <= y+bHeight) {
      // Start the game
      game = GameMode.RUNNING;
    }

    int newY = y+bHeight+gap;
  // Check if mouse is over Quit button
    if (mouseX >= x && mouseX <= x+bWidth && mouseY >= newY && mouseY <= newY+bHeight) {
    // Quit the program
       exit();
    }
  }
  
  if(endScreenCheck)
  {
    if (mouseX >= x && mouseX <= x+bWidth && mouseY >= y && mouseY <= y+bHeight) {
      // Start the game
      game = GameMode.MENU;
    }
  }
   
  mouseClick = true;
  if (mouseButton == LEFT) {leftClick = true;} //if left button is clicked, leftClick is set to true
  if (mouseButton == RIGHT){rightClick = true;}//if right button is clicked, rightClick is set to true
}


void mouseReleased() //check mouse buttons released
{
  mouseClick = false;
  if (mouseButton == LEFT) {leftClick = false;} //if its released leftClick is set to false
  if (mouseButton == RIGHT){rightClick = false;} // if right button is released, rightClick is set to false
}
