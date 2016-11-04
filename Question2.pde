class Survivor
{
  String name;
  float x, y;
  boolean infected, injured;
  int bullets;
  float speed;
  
  Survivor(String n, float newx, float newy, int bull, boolean inj, boolean inf)
  {
    name = n;
    x = newx;
    y = newy;
    bullets = bull;
    infected = inf;
    
    //If survivor is already injured, don't make them infected as well
    if (infected)
    {
      injured = false;
      speed = 0.8; 
    }
    else
    {
      injured = inj;
      
      if (injured)
      {
        speed = 0.4;
      }
      else
      {
        speed = 0.8;
      }
    }

  }
  
}

int numSurvivors = 11;
int numZombies = 1;
int nameIndex = 0;

String[] names = {"Harry", "Hermione", "Ron", "Ginny", "Draco", "Voldemort", "Dobby", "Luna", "Neville", "Dean", "Lucius",
"Snape", "Hagrid", "Fred", "George", "Bellatrix", "Lockhart", "Pettigrew", "Sirius", "McGonagall", "Umbridge", "Lupin"};

color[] sColours = 
{
  color(47, 213, 103), //green; healthy
  color(242, 64, 60), //red; injured
  color(50, 50, 48), //grey; zombie/infected
};

float[] sDirections = new float[numSurvivors];

int sWidth = 30;
int sHeight = 60;

Survivor[] mySurvivors = new Survivor[numSurvivors];

void setup()
{
  size(750, 750);
  int zombieIndex = (int) random (10);
  
  for (int i=0; i<mySurvivors.length; i++)
  {  
    //Create only one zombie to start
    if (i==zombieIndex)
    {
      mySurvivors[i] = new Survivor(names[i], (int) random(sWidth/2, width - sWidth/2 - 20), 
      (int) random(sHeight/2, height - sHeight/2 - 10), (int)random(5,10), randomBool(0.2), randomBool(1));
    }
    else
    {
      mySurvivors[i] = new Survivor(names[i], (int) random(sWidth/2, width - sWidth/2 - 20), 
      (int) random(sHeight/2, height - sHeight/2 - 10), (int)random(5,10), randomBool(0.2), randomBool(0));
    }
  }
}

boolean randomBool(float percentage)
{
  return random(1) < percentage;
}

void draw()
{
  background(255);
  drawSurvivors(mySurvivors);
  moveSurvivors(mySurvivors);
  textSize(12);
  text("Healthy survivors: "+healthySurvivors(mySurvivors)+ " %", width/16, height*15/16);
  text("Total bullets remaining: "+numBullets(mySurvivors), width*3/4, height*15/16);
  
  if (healthySurvivors(mySurvivors) < 20)
  {
    spawnNew();
  }
}

void drawSurvivors(Survivor[] s)
{
  for (int i=0; i<s.length; i++)
  {
    if (s[i].injured)
    {
      fill(sColours[1]);
    }
    else if (s[i].infected)
    {
      fill(sColours[2]);
    }
    else
    {
      fill(sColours[0]);
    }
    ellipse(s[i].x, s[i].y, sWidth, sHeight);
    textSize(10);
    fill(0);
    text(s[i].name, s[i].x, s[i].y + sHeight/2 + 10);
  }
}

void moveSurvivors(Survivor[] s)
{
  int targetIndex = 0;

  for (int i=0; i<s.length; i++)
  {
    float nextX = s[i].x + s[i].speed * cos(sDirections[i]);
    float nextY = s[i].y + s[i].speed * sin(sDirections[i]);
    
    float crossProduct;
    boolean found = false;
    
    //Find closest healthy or injured person
    if (s[i].infected)
    {
      float min = dist(s[i].x, s[i].y, s[0].x, s[0].y);
      Survivor target = s[0];
       
       //Prevent zombie from thinking itself is the target
       while (!found && numZombies < numSurvivors)
       {
         targetIndex = (int) random (numSurvivors);
         if (!s[targetIndex].infected)
         {
           target = s[targetIndex];
           found = true;
         }
       }
       

      for (int  j=1; j<s.length; j++)
      {        
        if (dist(s[i].x, s[i].y, s[j].x, s[j].y) < min && !s[j].infected)
        {
          min = dist(s[i].x, s[i].y, s[j].x, s[j].y);
          target = s[j];
          targetIndex = j;
        }
      }
      
    
    crossProduct = (nextX - s[i].x)*(target.y - s[i].y) -
                       (nextY - s[i].y)*(target.x - s[i].x);
      
      //Check collision with nearest target
      if (checkCollision(s[i], target) && numZombies < numSurvivors)
      {
        if (target.injured)
        {
          if (randomBool(0.6))
          {
            s[targetIndex].infected = true;
            s[targetIndex].injured = false;
            println("infected");
            numZombies ++;
          }
        }
        else 
        {
          if (randomBool(0.3))
          {
            s[targetIndex].infected = true;
            println(s[targetIndex].name+" healthy infected");
            numZombies ++;
          }
        }
      }
                       
    }
    
    //Find closest zombie if healthy/injured
    else
    {
     float min = dist(s[i].x, s[i].y, s[0].x, s[0].y);
      Survivor target = s[0];
     
     for (int  j=1; j<s.length; j++)
      {        
        if (dist(s[i].x, s[i].y, s[j].x, s[j].y) < min && s[j].infected)
        {
          min = dist(s[i].x, s[i].y, s[j].x, s[j].y);
          target = s[j];
        }
      }
      
      //Only move away if certain distance to zombie
      if (min <= 100)
      {  
        // Multiply by negative one - move AWAY from zombie
        crossProduct = ((nextX - s[i].x)*(target.y - s[i].y) -
                         (nextY - s[i].y)*(target.x - s[i].x)) * -1;
      }
      
      //Otherwise, move randomly
      else
      {
        crossProduct = (nextX - s[i].x)*(random(height) - s[i].y) -
                       (nextY - s[i].y)*(random(width) - s[i].x);
      }
    }

  if (nextX < 20)
  {
    nextX += 2;
  }
  
  else if (nextX > width-40)
  {
    nextX -= 2;
  }
  
  if (nextY < 40)
  {
    nextY += 2;
  }
  else if (nextY > height-40)
  {
    nextY -= 2;
  }
      
      s[i].x = nextX;
      s[i].y = nextY;
    
    // 10% of the time, we'll turn left or right
    if (random(1) < 0.1)
    {
      final int angleToTurn = 30;
      if (crossProduct < 0) 
      {
        
        sDirections[i] -= radians(angleToTurn 
                                  + random(angleToTurn/4) 
                                  - angleToTurn/8);
                                  
      }
      else 
      {
        sDirections[i] += radians(angleToTurn 
                                  + random(angleToTurn/4) 
                                  - angleToTurn/8);
      }
    }
  }
}

float healthySurvivors (Survivor[] s)
{
  int num = 0;
  
  for (int i=0; i<s.length; i++)
  {
    if (!s[i].infected && !s[i].injured)
    {
      num++;
    }
  }
  
  return (float) num/s.length * 100;
}

int numBullets(Survivor[] s)
{
  int sum = 0;
  for (int i=0; i<s.length; i++)
  {
    sum += s[i].bullets;
  }
  return sum;
}

boolean checkCollision(Survivor s1, Survivor s2)
{
  
  if (s1.x <= s2.x + sWidth/2 && s1.x >= s2.x - sWidth/2 &&
  s1.y <= s2.y + sHeight/2 && s1.y >= s2.y - sHeight/2)
  {
    return true;
  }
  
  else
  {
    return false;
  }
}

void spawnNew()
{
  Survivor[] temp = mySurvivors;
  mySurvivors = new Survivor[numSurvivors+2];
  float[] temp2 = sDirections;
  sDirections = new float[numSurvivors+2];
  
  for (int i=0; i<temp.length; i++) //<>//
  {
    mySurvivors[i] = temp[i];
    sDirections[i] = temp2[i];
    
  }
  
  int index; 
   if(numSurvivors < names.length - 1)
   {
     index = numSurvivors;
   }
   else
   {
     if(nameIndex > names.length - 1)
     {
       nameIndex = 0;
     }
     
     index = nameIndex;
     nameIndex += 2;
   }
   
   println(nameIndex);
  mySurvivors[mySurvivors.length-2] = new Survivor(names[index], (int) random(sWidth/2, width - sWidth/2 - 20),  //<>//
      (int) random(sHeight/2, height - sHeight/2 - 10), (int)random(5,10), randomBool(0.25), randomBool(0));
  mySurvivors[mySurvivors.length-1] = new Survivor(names[index+1], (int) random(sWidth/2, width - sWidth/2 - 20), 
      (int) random(sHeight/2, height - sHeight/2 - 10), (int)random(5,10), randomBool(0.25), randomBool(0));
  numSurvivors += 2;
  
}