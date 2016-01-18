import game2dai.entities.*;
import game2dai.entityshapes.ps.*;
import game2dai.maths.*;
import game2dai.*;
import game2dai.entityshapes.*;
import game2dai.fsm.*;
import game2dai.steering.*;
import game2dai.utils.*;
import game2dai.graph.*;

import java.awt.Point;
import java.awt.Rectangle;
import processing.video.*;
import processing.sound.*;

SoundFile file;
Movie intro;

Domain wd;
World world;
Building[] buildings;
Obstacle[] stalls;
Vehicle[] tourists, patrolLeader;

Graph routes;
GraphNode[] nodes;
GraphNode dest = null;
GraphEdge[] edges;

StopWatch watch;


public int worldTime;
public int worldDay;
int timeScale = 3;

ArrayList<Factory> factory = new ArrayList<Factory>();
ArrayList<Vehicles> vehicles = new ArrayList<Vehicles>();
ArrayList<Pollutant> pollutants = new ArrayList<Pollutant>();

public int difficulty = 1; 
public int AQI;

public int currentMoney = 5000;
int bubbleGather;
int today = 0;
int tomorrow = 1;
int worldPreTime=0;
static int factoryAmountfactor = 1;
static int vehiclesAmountfactor = 1;
int policyType;



ArrayList<Vector2D> factPos = new ArrayList<Vector2D>();

  int levelOfFact = 1;
  int levelOfVeh = 1;
  float radius = 2;
  float max_force = 3000;
  
  
  
  PImage bg;
  //factory
  PImage fac; 
  PImage veh;
  PImage chooseVeh;
  //AQI pic
  PImage AQIpic;
  //pollutant
  PImage status1;
  PImage status2;
  PImage status3;
  PImage status4;
  PImage status5;
  PImage status6;
  //fog
  PImage fog;
  //lung
  PImage lung;
  //money & pollutants
  PImage IconFact;
  PImage IconVeh;
  PImage IconDay;
  PImage IconMoney;
  PImage IconMounts;
  PImage IconBack;
  PImage IconPur;
  PImage IconUp;
  PImage howMuch;
  PImage IconConfirm;
  PImage Light;
  PImage lightFac;
  PImage lightVeh;
  PImage IconCancel;
  PImage chooseFact;
  PImage alarm;
  PImage report;
  PImage shade;
  
 int vehFrame = 1;
  
  PFont f;
  
  boolean pause = false;
  boolean purchaseFact = false;
  boolean purchaseVeh = false;
  boolean introVideo = false;
  boolean confirmedFacPage = false;
  boolean lightFact = false;
  boolean _pause = false;
  boolean lightVehi = false;
  boolean confirmedVehPage = false;
  boolean pausePolicy;
  boolean pauseWork;
  
  int reportDay;
  

void setup(){
  size(667, 375);
  world = new World(667, 375);
  
  
  
  
  f = createFont("DINPro-Regular.otf", 20);
  textFont(f);
  
  
  factPos.add(new Vector2D(465, 185));
  factPos.add(new Vector2D(430, 170));
  factPos.add(new Vector2D(435, 150));
  factPos.add(new Vector2D(445, 135));
  factPos.add(new Vector2D(490, 140));
  
  introVideo = initial();
  
  watch = new StopWatch();
  
  file = new SoundFile(this, "Suzuki-Tosca.mp3");
  file.play();
}


public void draw(){
  if(pausePolicy == true)
  {

  
    switch(policyType)
    {
    case 1:
    reportDay = today;
    pauseWork = true;
    break;
    case 2:
      for(int i = 0; i<pollutants.size(); i++)
    {
      pollutants.remove(i);
    }
    break;
    case 3:
    if(levelOfFact>1)
    {
    for(int i=0; i<  factory.size(); i++)
    {
      Factory fact = factory.get(i);
      fact.polluterLevelListener(-1);
    }
    levelOfFact -=1;
    }
    if(levelOfVeh>1)
    {
        for(int i=0; i<  vehicles.size(); i++)
    {
      Vehicles veh = vehicles.get(i);
      veh.polluterLevelListener(1);
    }
    levelOfVeh -=1;
    }
    break;
    }
      if(mousePressed ==true)
    {
      pausePolicy = false;
    }
 
  }
  

  if(introVideo == true)
  {
    if (intro.available()) {
    intro.read();
    }
    if(mouseX> 280 &&mouseX<370 && mouseY >280 && mouseY <300)
    {
      introVideo = false;
    }
    else if(intro.time()<21.033333)
    {
    image(intro, 0, 0, width, height);
    }else
    {
      //intro.noLoop();
      introVideo = false;
    }
    fill(238,248,25);
    text("Skip Video", 280,300);
    //rect(280,280,90,20);
  }
  if(pause == false && _pause == false && introVideo == false &&pausePolicy ==false)
  {
  
  mainInterface();
 
  
  if(pauseWork == true)
  {
    
    if(reportDay == today - 3)
    {
      pauseWork = false;
      today +=1;
    }
  }
  
   //Factory fact = factory.get(0);
   //Vehicles veh = vehicles.get(0);
   //levelOfFact = fact.getLevel();
   //levelOfVeh = 1;
  
  
   dayCaculator();
  
  
  if(today==tomorrow)
  {
    bubbleMaker();
    tomorrow = tomorrow + 1;
  }
  
  AQICaculator();
  bubbleRender();
  policyType = policy();
  
  }
  
   manuInterface();
   
   if(AQI>=500 && pollutants.size() > 70)
   {
    shade =loadImage("Shade.png");
    image(shade,0,0);
     fill(0,200);
     rect(width,height,0,0);
     fill(234,255,20);
     textSize(100);
     text("YOU WIN!", 130,200);
     textSize(20);
     text("You have colonized the city in" +" "+ today + " " +"days", 150,300);
     noLoop();
   }
  
}

public void mainInterface(){
  
  
  
  
  //factory
  println(factory.size());
  bg = loadImage("fuzzyEnder_667_375_bg_S.jpg");
  image(bg,0,0);
  switch(factory.size())
  {     
    case 1:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_S_1fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv2_fac1.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv3_fac1.png"); 
          image(fac, 0, 0);
    }
           break;
    case 2:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_S_2fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv2_fac2.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv3_fac2.png"); 
          image(fac, 0, 0);
    }
           break;
    case 3:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_S_3fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv2_fac3.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv3_fac3.png"); 
          image(fac, 0, 0);
    }
        break;
    case 4:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_S_4fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv2_fac4.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv3_fac4.png"); 
          image(fac, 0, 0);
    }
        break;
     case 5:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_S_5fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv2_fac5.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_S_Lv3_fac5.png"); 
          image(fac, 0, 0);
    }
        break;
     default:
       break;
  }
  
  //vehicles
  if(vehicles.size()>0)
  {
  if(levelOfVeh ==1)
    {
      if(vehFrame ==1)
      {
    veh = loadImage("V_S_Lv1_Frame 1.png"); 
          image(veh, 0, 0);
          vehFrame = -1*vehFrame;
      }else if(vehFrame == -1)
      {
        veh = loadImage("V_S_Lv1_Frame 2.png"); 
          image(veh, 0, 0);
          vehFrame = -1*vehFrame;
      }
    }else if(levelOfVeh ==2)
    {
       if(vehFrame ==1)
      {
      veh = loadImage("V_S_Lv2_Frame 1.png"); 
          image(veh, 0, 0);
           vehFrame = -1*vehFrame;
            }else if(vehFrame == -1)
      {
        veh = loadImage("V_S_Lv2_Frame 2.png"); 
          image(veh, 0, 0);
          vehFrame = -1*vehFrame;
      }
    }else if(levelOfVeh == 3)
    {
      if(vehFrame ==1)
      {
      veh = loadImage("V_S_Lv3_Frame 1.png"); 
          image(veh, 0, 0);
           vehFrame = -1*vehFrame;
            }else if(vehFrame == -1)
      {
        veh = loadImage("V_S_Lv3_Frame 2.png"); 
          image(veh, 0, 0);
          vehFrame = -1*vehFrame;
      }
    }
  }

  
  
  //show AQI, lung and Fog

  if(AQI<50)
  {
    fog = loadImage("fuzzyEnder_667_375_haze_Lv1.png");
    image(fog,0,0);
    AQIpic = loadImage("New Slice5 - Tube icon - status1.png");
    image(AQIpic,0,0);
  }
  else if(AQI>=50 && AQI < 100)
  {
     fog = loadImage("fuzzyEnder_667_375_haze_Lv2.png");
    image(fog,0,0);
    AQIpic = loadImage("New Slice5 - Tube icon - status2.png");
    image(AQIpic,0,0);

    
  }
  else if (AQI>=100 && AQI < 150)
  {
     fog = loadImage("fuzzyEnder_667_375_haze_Lv3.png");
    image(fog,0,0);
    AQIpic = loadImage("New Slice5 - Tube icon - status3.png");
    image(AQIpic,0,0);

  }
  else if (AQI >=150 && AQI < 200)
  {
     fog = loadImage("fuzzyEnder_667_375_haze_Lv4.png");
    image(fog,0,0);
    AQIpic = loadImage("New Slice5 - Tube icon - status4.png");
    image(AQIpic,0,0);

  }
  else if (AQI>=200 && AQI <300)
  {
     fog = loadImage("fuzzyEnder_667_375_haze_Lv5.png");
    image(fog,0,0);
    AQIpic = loadImage("New Slice5 - Tube icon - status5.png");
    image(AQIpic,0,0);

  }
  else if (AQI >=300 )
  {
     fog = loadImage("fuzzyEnder_667_375_haze_Lv6.png");
    image(fog,0,0);
    AQIpic = loadImage("New Slice5 - Tube icon - status6.png");
    image(AQIpic,0,0);

  }
  fill(0);
  if(AQI<100)
  {
  text(AQI, 605, 335);
  }
  else
  {
    text(AQI, 600, 335);
  }
  
  //show molecules icon status
  
  if(levelOfFact == 1 )
  {
    status1 = loadImage("New Slice2 - 6 molecules icon - status1.png");
    image(status1,0,0);
    if(vehicles.size() != 0)
    {
    switch(levelOfVeh)
    {
          case 1:
          status4 = loadImage("New Slice2 - 6 molecules icon - status4.png");
          image(status4,0,0);
          break;
          case 2:
          status5 = loadImage("New Slice2 - 6 molecules icon - status5.png");
          image(status5,0,0);
          break;
          case 3:
          status6 = loadImage("New Slice2 - 6 molecules icon - status6.png");
          image(status6,0,0);
          break;
    }
    }
  }
  else if(levelOfFact == 2)
  {
    status1 = loadImage("New Slice2 - 6 molecules icon - status1.png");
    image(status1,0,0);
    status2 = loadImage("New Slice2 - 6 molecules icon - status2.png");
    image(status2,0,0);
        if(vehicles.size() != 0)
    {
        switch(levelOfVeh)
    {
          case 1:
          status4 = loadImage("New Slice2 - 6 molecules icon - status4.png");
          image(status4,0,0);
          break;
          case 2:
          status5 = loadImage("New Slice2 - 6 molecules icon - status5.png");
          image(status5,0,0);
          break;
          case 3:
          status6 = loadImage("New Slice2 - 6 molecules icon - status6.png");
          image(status6,0,0);
          break;
    }
    }
  }
  else if(levelOfFact == 3)
  {
     status1 = loadImage("New Slice2 - 6 molecules icon - status1.png");
    image(status1,0,0);
    status2 = loadImage("New Slice2 - 6 molecules icon - status2.png");
    image(status2,0,0);
     status3 = loadImage("New Slice2 - 6 molecules icon - status3.png");
    image(status3,0,0);
        if(vehicles.size() != 0)
    {
        switch(levelOfVeh)
    {
          case 1:
          status4 = loadImage("New Slice2 - 6 molecules icon - status4.png");
          image(status4,0,0);
          break;
          case 2:
          status5 = loadImage("New Slice2 - 6 molecules icon - status5.png");
          image(status5,0,0);
          break;
          case 3:
          status5 = loadImage("New Slice2 - 6 molecules icon - status6.png");
          image(status5,0,0);
          break;
    }
    }
  }
  
  //money & pollutants
  fill(229, 255, 0);
  IconDay = loadImage("IconDay_cc.png");
  image(IconDay, 0,0);
  textSize(20);
  if(today<10)
  {
  text(today, 33, 53);
  }
  else if(today<100)
  {
  text(today, 27, 53);
  }
  IconMoney = loadImage("IconMoney.png");
  image(IconMoney,0,0);
  textSize(14);
  text(currentMoney, 63, 60);
  IconMounts = loadImage("IconMounts.png");
  image(IconMounts,0,0);
  textSize(14);
  text(pollutants.size(), 101,60);
  IconFact = loadImage("IconFactory_cc + Oval 93.png");
  image(IconFact,0,0);
  textSize(20);
  text(factory.size(), 28,195);
  text("Lv." + levelOfFact,45,195);
  IconVeh = loadImage("IconVehicle_cc + Oval 93.png");
  image(IconVeh,0,0);
  textSize(20);
  text(vehicles.size(),28, 265);
  text("Lv." + levelOfVeh,45,265);
  //IconBack = loadImage("IconBack.png");
  //image(IconBack,0,0);
  alarm = loadImage("3 - icon - alarming(off).png");
  image(alarm,-6,0);

}

public boolean initial(){
  
    Vector2D pos = factPos.get(0);
    factory.add(new Factory("factory", levelOfFact, pos));
    
    //vehicles.add(new Vehicles("vehichle", levelOfVeh, 1));
    intro = new Movie(this, "intro.mp4"); 
    intro.play();
    println(intro.duration());
    
   return true;
}

public void dayCaculator(){
  worldTime = (int)watch.getRunTime();
  if(worldTime != worldPreTime)
  {
   //world.update(elapsedTime);
   //world.draw(elapsedTime);
   if(worldTime%timeScale ==0)
   {
    today = today + 1;
    print((int)worldTime + "\n" );
    //print(day);
    worldPreTime = worldTime;
    }
   }
}

public void AQICaculator(){

   AQI = max((factory.size()*levelOfFact*10), (vehicles.size()*levelOfVeh * 60));
   /*
   print(factory.size() + "\n");
   print(levelOfFact + "\n");
   print(vehicles.size() + "\n");
   print(levelOfVeh + "\n");
   */
}


public void bubbleMaker()
{
  int sizeOfFact = factory.size();
  int sizeOfVeh = vehicles.size();
 
  if(pauseWork == false)
  {
  for(int i=0; i<sizeOfFact; i++)
    {
      Factory fac = factory.get(i);
      for(int j = 0; j< levelOfFact * factoryAmountfactor; j++)
      {
      pollutants.add(new Pollutant 
      (
      "factory", //name
      //levelOfFact, // level
      new Vector2D(fac.getPosition().x+random(-30,+30),  fac.getPosition().y+random(-30,+30)),// position
      random(0,3), //radius
      Vector2D.ZERO,  // velocity
      60, // maximum speed
      new Vector2D(random(-2.5,0.5 ),random(-2, 0.3)),  // heading
      levelOfFact, // mass
      0.2f, // turning rate
      max_force //max_force
      
      ));
      }
    }
  

  for(int i=0; i<sizeOfVeh; i++)
    {
      Vehicles ve = vehicles.get(i);
      for(int j = 0; j< levelOfVeh *  vehiclesAmountfactor; j++)
      {
      pollutants.add(new Pollutant 
      (
      "vehicle", //name
      //levelOfVeh, // level
      new Vector2D(ve.getPosition().x+random(-10,+10),  ve.getPosition().y+random(-20,+100)),// position
      random(0,3), //radius
      new Vector2D(3, 3),  // velocity
      random(55,65), // maximum speed
      new Vector2D(random(-1, 3.5),random(-0.3,3)),  // heading
      levelOfVeh, // mass
      0.2f, // turning rate
      max_force //max_force
      
      ));
      }
    }
    }
    
}

public void bubbleRender(){
  for(int i = 0; i< pollutants.size(); i++)
  {
    Pollutant poll = pollutants.get(i);
    Vector2D pos = poll.pos();
    String name = poll.name();
    if(pos.x>(width+10)||pos.x<(-10)||pos.y>(height+10)||pos.y<(-10))
    {
      pollutants.remove(i);
    }
    else
    {
      if(name.equals("factory"))
      {
        poll.popUp(levelOfFact); 
      }else if(name.equals("vehicle"))
      {
         poll.popUp(levelOfVeh); 
      }
    }
  }
}


public void mousePressed() {
  if(pause == false && mouseX>70 && mouseX < 92 && mouseY> 144 && mouseY < 171 )
  {
    pause = true;
    
  }else if(_pause == false && mouseX>70 && mouseX < 92 && mouseY> 220 && mouseY < 249 )
  {
    _pause = true;
    
  }
}
  

  
public void manuInterface(){
  
  
    if(mousePressed == true && bubbleCollector()!= -1 && pause == false )
  {
    pollutants.remove(bubbleCollector());
    currentMoney +=1;
  }
  

//factory store

//  mouseX>70 && mouseX < 92 && mouseY> 144 && mouseY < 171 

else if(pause == true && purchaseFact == false && confirmedFacPage == false && lightFact == false)
  { 
    if(mousePressed == true && mouseX>147 && mouseX <317 && mouseY>266 && mouseY < 314)
    {
      purchaseFact = true;
    }
    else if(mousePressed == true && mouseX>70 && mouseX < 92 && mouseY> 144 && mouseY < 171)
    {
      pause = false;
      print("good");
      print(pause);
      
    }
    else if(mousePressed == true && mouseX>344&&mouseX<514&&mouseY>266&&mouseY<314 && levelOfFact>=3) 
    {
      fill(135,30,72);
      text("REMIND: You factories are already highest level!",  100,80);
    }
    else if(mousePressed == true && mouseX>344&&mouseX<514&&mouseY>266&&mouseY<314 && levelOfFact<3)    //upgrad
    {
      if(currentMoney - 100 * levelOfFact * levelOfFact <0)
      {
        fill(135,30,72);
        text("REMIND: You money is not enough!",  100,80);
      }
      else if(currentMoney - 100 * levelOfFact * levelOfFact >=0)
      {
      currentMoney = currentMoney - 100 * levelOfFact * levelOfFact; //(1,100),(2, 400)
    for(int i=0; i<  factory.size(); i++)
    {
      Factory fact = factory.get(i);
      fact.polluterLevelListener(1);
    }
    levelOfFact +=1;
    
    bg = loadImage("fuzzyEnder_667_375_bg_L_fac.jpg");
    image(bg,0,0);
    
    switch(factory.size())
  {     
    case 1:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_L_1fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_L_1fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_L_1fac.png"); 
          image(fac, 0, 0);
    }
          Light = loadImage("4 factories left.png");
         // image(Light, 0, 0);
           break;
    case 2:
    if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_L_2fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac2.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac2.png"); 
          image(fac, 0, 0);
    }
          Light = loadImage("3 factories left.png");
         // image(Light, 0, 0);
           break;
    case 3:
      if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_L_3fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac3.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac3.png"); 
          image(fac, 0, 0);
    }
       image(fac,0,0);
       Light = loadImage("2 factories left.png");
          //image(Light, 0, 0);
        break;
    case 4:
         if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_L_4fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac4.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac4.png"); 
          image(fac, 0, 0);
    }
       //image(fac,0,0);
       Light = loadImage("1 factory left.png");
          image(Light, 0, 0);
        break;
     case 5:
              if(levelOfFact ==1)
    {
    fac = loadImage("fuzzyEnder_667_375_L_5fac.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact ==2)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac5.png"); 
          image(fac, 0, 0);
    }else if(levelOfFact == 3)
    {
      fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac5.png"); 
          image(fac, 0, 0);
    }
       //image(fac,0,0);
        break;
     default:
       break;
  }
      }
    }
    
    
    bg = loadImage("fuzzyEnder_667_375_bg_L_fac.jpg");
    
    image(bg,0,0);
    
    switch(factory.size())
  {     
    case 1:
        Light = loadImage("4 factories left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
          case 1:
          fac = loadImage("fuzzyEnder_667_375_L_1fac.png");   
          break;
          case 2:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac1.png");
          break;
          case 3:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac1.png"); 
          break;
        }
        image(fac, 0, 0);
        break;
    case 2:
        Light = loadImage("3 factories left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
          case 1:
          fac = loadImage("fuzzyEnder_667_375_L_2fac.png");  
          break;
          case 2:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac2.png"); 
          break;
          case 3:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac2.png"); 
          break;
        }
        image(fac,0,0);
        break;
    case 3:
        Light = loadImage("2 factories left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
        case 1:
        fac = loadImage("fuzzyEnder_667_375_L_3fac.png");     
        break;
        case 2:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac3.png"); 
        break;
        case 3:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac3.png"); 
        break;
        }
        image(fac,0,0);
        break;
    case 4:
        Light = loadImage("1 factory left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
        case 1:
        fac = loadImage("fuzzyEnder_667_375_L_4fac.png"); 
        break;
        case 2:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac4.png"); 
        break;
        case 3:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac4.png"); 
        break;
        }
       image(fac,0,0);
        break;
     case 5:
     switch(levelOfFact)
    {case 1:
      fac = loadImage("fuzzyEnder_667_375_L_5fac.png");     
      break;
     case 2:
     fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac5.png"); 
     break;
     case 3:
     fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac5.png"); 
     break;
    }
       image(fac,0,0);
        break;
     default:
       break;
  }
    IconUp = loadImage("IconUpgrad.png");
    image(IconUp,0,0);
    IconPur = loadImage("IconPurchase.png");
    image(IconPur,0,0);
    

  
  //money & pollutants
  fill(229, 255, 0);
  IconDay = loadImage("IconDay_cc.png");
  image(IconDay, 0,0);
  textSize(20);
  if(today<10)
  {
  text(today, 33, 53);
  }
  else if(today<100)
  {
  text(today, 27, 53);
  }
  IconMoney = loadImage("IconMoney.png");
  image(IconMoney,0,0);
  textSize(14);
  text(currentMoney, 63, 60);
  IconMounts = loadImage("IconMounts.png");
  image(IconMounts,0,0);
  textSize(14);
  text(pollutants.size(), 101,60);
  
  IconFact = loadImage("5-3 - icon - check factory (to zoom out).png");
  image(IconFact,0,0);
  IconVeh = loadImage("6-2 - icon - check vehicle (to zoom in - alpha 40%).png");
  image(IconVeh,0,0);
  
  textSize(20);
  text(factory.size(), 28,195);
  text("Lv." + levelOfFact,45,195);
textSize(20);
  text(vehicles.size(),28, 265);
  text("Lv." + levelOfVeh,45,265);
  
  
  }
   
 
  //enter the buying factory page
  else if(pause == true && purchaseFact == true && confirmedFacPage == false && lightFact == false)
  {

    int fac1X = 103;
    int fac1Y = 154;
    int fac2X = 241;
    int fac2Y = 154;
    int fac3X = 386;
    int fac3Y = 164;
    int fac4X = 518;
    int fac4Y = 164;
    int widthFact = 90;
    int heightFact = 45;
    int facButtonX =1000;
    int facButtonY = 1000;
    
    switch(factory.size())
    {
      case 1 :
      facButtonX = fac1X;
      facButtonY = fac1Y;
      break;
      case 2 :
      facButtonX = fac2X;
      facButtonY = fac2Y;
      break;
      case 3 :
      facButtonX = fac3X;
      facButtonY = fac3Y;
      break;
      case 4 :
      facButtonX = fac4X;
      facButtonY = fac4Y;
      break;
      case 5 :
      text("You have own all the factories!", 160,300);
      break;
    }
    
    if(mousePressed == true && mouseX>facButtonX &&mouseX <facButtonX+widthFact && mouseY >facButtonY && mouseY <facButtonY+heightFact )
    {
      if(currentMoney > 10* factory.size())
      {
      lightFact = true;
      }else
      {
        text("Your money is not enough!", 160,300);
      }
    }
     
    
    else if(mousePressed == true && mouseX>18 && mouseX<62 && mouseY >165 && mouseY < 209)
    {
      purchaseFact = false;
    }
 
    
    bg = loadImage("fuzzyEnder_667_375_bg_L_fac.jpg");
    
    image(bg,0,0);
    
    switch(factory.size())
  {     
    case 1:
        Light = loadImage("4 factories left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
          case 1:
          fac = loadImage("fuzzyEnder_667_375_L_1fac.png");   
          break;
          case 2:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac1.png");
          break;
          case 3:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac1.png"); 
          break;
        }
        image(fac, 0, 0);
        break;
    case 2:
        Light = loadImage("3 factories left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
          case 1:
          fac = loadImage("fuzzyEnder_667_375_L_1fac.png");   
          break;
          case 2:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac2.png"); 
          break;
          case 3:
          fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac2.png"); 
          break;
        }
        image(fac,0,0);
        break;
    case 3:
        Light = loadImage("2 factories left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
        case 1:
        fac = loadImage("fuzzyEnder_667_375_L_1fac.png");     
        break;
        case 2:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac3.png"); 
        break;
        case 3:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac3.png"); 
        break;
        }
        image(fac,0,0);
        break;
    case 4:
        Light = loadImage("1 factory left.png");
        image(Light, 0, 0);
        switch(levelOfFact)
        {
        case 1:
        fac = loadImage("fuzzyEnder_667_375_L_1fac.png"); 
        break;
        case 2:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac4.png"); 
        break;
        case 3:
        fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac4.png"); 
        break;
        }
       image(fac,0,0);
        break;
     case 5:
     switch(levelOfFact)
    {case 1:
      fac = loadImage("fuzzyEnder_667_375_L_1fac.png");     
      break;
     case 2:
     fac = loadImage("fuzzyEnder_667_375_order_L_Lv2_fac5.png"); 
     break;
     case 3:
     fac = loadImage("fuzzyEnder_667_375_order_L_Lv3_fac5.png"); 
     break;
    }
       image(fac,0,0);
        break;
     default:
       break;
  }
    
    
    
    
    fill(10,150);
    rect(0,0, width, height);
    
     //front
        fac = loadImage("p_fact1st.png"); 
          image(fac, 0, 0);
          
    switch(factory.size())
  {     
    case 2:
    lightFac = loadImage("Glow Factory 2nd.png");
          image(lightFac,0,0);
           break;
    case 3:
    lightFac = loadImage("Glow Factory 3rd.png");
     image(lightFac,0,0);
        break;
    case 4:
           lightFac = loadImage("Glow Factory 4th.png");
          image(lightFac,0,0);
        break;
     case 5:
         lightFac = loadImage("Glow Factory 5th.png");
          image(lightFac,0,0);
       break;
     default:
       break;
  }
   
   //IconConfirm = loadImage("IconConfirm.png");
   //image(IconConfirm,0,0);
  
  //money & pollutants
  fill(229, 255, 0);
  IconDay = loadImage("IconDay_cc.png");
  image(IconDay, 0,0);
  textSize(20);
  if(today<10)
  {
  text(today, 33, 53);
  }
  else if(today<100)
  {
  text(today, 27, 53);
  }
  IconMoney = loadImage("IconMoney.png");
  image(IconMoney,0,0);
  textSize(14);
  text(currentMoney, 63, 60);
  IconMounts = loadImage("IconMounts.png");
  image(IconMounts,0,0);
  textSize(14);
  text(pollutants.size(), 101,60);
  IconBack = loadImage("IconBack.png");
  image(IconBack,0,0);
  howMuch = loadImage("FactoryHowMuch.png");
  image(howMuch,0,0);
  textSize(20);
  text("Setting up NEW factory costs money!", 180,80);
  
  }
  
else if(pause == true && purchaseFact == true && confirmedFacPage == false && lightFact == true)    
    {
      switch(factory.size())
    {
         case 1:
          chooseFact = loadImage("p_choosefact1.png");
          image(chooseFact,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
         IconCancel = loadImage("IconCancelNormal.png");
         image(IconCancel,0,0);
       confirmedFacPage = true;  
       break;
        case 2:
          chooseFact = loadImage("p_choosefact2.png");
          image(chooseFact,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
         IconCancel = loadImage("IconCancelNormal.png");
         image(IconCancel,0,0);
         confirmedFacPage = true;
         break;
        case 3:
        chooseFact = loadImage("p_choosefact3.png");
          image(chooseFact,0,0);
             IconConfirm = loadImage("IconConfirm.png");
   image(IconConfirm,0,0);
   IconCancel = loadImage("IconCancelNormal.png");
   image(IconCancel,0,0);
   confirmedFacPage = true;
   break;
        case 4:
         chooseFact = loadImage("p_choosefact4.png");
          image(chooseFact,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
   IconCancel = loadImage("IconCancelNormal.png");
   image(IconCancel,0,0);
   confirmedFacPage = true;  
   break;
         
    }
      
      
    }
   

  
  //confirmBuying
  else if(pause == true && purchaseFact == true && confirmedFacPage == true && lightFact == true)
  {
    int confirmButtonX = 340;
    int confirmButtonY = 265;
    int cancelButtonX = 146;
    int cancelButtonY = 265;
    int buttonWidth = 170;
    int buttonHeight = 49;
    if(mousePressed == true && mouseX>confirmButtonX && mouseX < confirmButtonX + buttonWidth && mouseY > confirmButtonY && mouseY < confirmButtonY + buttonHeight)
    {
     currentMoney = currentMoney - 10 * (factory.size()+1) * levelOfFact;
     int i = factory.size();
     Vector2D pos = factPos.get(i);
     factory.add(new Factory("factory", levelOfFact, pos));
     
     /*
     switch(factory.size())
  {     
    case 2:
    lightFac = loadImage("Glow Factory 2nd.png");
          image(lightFac,0,0);
           break;
    case 3:
    lightFac = loadImage("Glow Factory 3nd.png");
     image(lightFac,0,0);
        break;
    case 4:
           lightFac = loadImage("Glow Factory 4nd.png");
          image(lightFac,0,0);
        break;
     case 5:
         lightFac = loadImage("Glow Factory 5nd.png");
          image(lightFac,0,0);
       break;
     default:
       break;
  }
  */
  confirmedFacPage = false;
  lightFact = false;
    }
    
    else if(mousePressed == true && mouseX>cancelButtonX && mouseX < cancelButtonX + buttonWidth && mouseY > cancelButtonY && mouseY < cancelButtonY + buttonHeight)
    {
      confirmedFacPage = false;
      lightFact = false;
      
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  //factory store

//  mouseX>70 && mouseX < 92 && mouseY> 144 && mouseY < 171 

else if(_pause == true && purchaseVeh == false && confirmedVehPage == false && lightVehi == false)
  { 
    if(mousePressed == true && mouseX>147 && mouseX <317 && mouseY>266 && mouseY < 314)
    {
      purchaseVeh = true;
    }
    else if(mousePressed == true && mouseX>70 && mouseX < 92 && mouseY> 220 && mouseY < 249 )
    {
      _pause = false;
      print("good");
      print(pause);
      
    }
    else if(mousePressed == true && mouseX>344&&mouseX<514&&mouseY>266&&mouseY<314 && levelOfVeh >=3) 
    {
      fill(135,30,72);
      text("REMIND: You vehicles are already highest level!",  100,80);
    }
    else if(mousePressed == true && mouseX>344&&mouseX<514&&mouseY>266&&mouseY<314 && levelOfVeh <3)    //upgrad
    {
       if(currentMoney - 100 * levelOfVeh * levelOfVeh < 0)
      {
        fill(135,30,72);
        text("REMIND: You money is not enough!",  100,80);
      }
      else{
      currentMoney = currentMoney - 100 * levelOfVeh * levelOfVeh; //(1,100),(2, 400)
    for(int i=0; i<  vehicles.size(); i++)
    {
      Vehicles veh = vehicles.get(i);
      veh.polluterLevelListener(1);
    }
    levelOfVeh +=1;
    
    
    bg = loadImage("fuzzyEnder_667_375_bg_L_veh.jpg");
    image(bg,0,0);
    
    switch(vehicles.size())
  {     
    case 1:
    if(levelOfVeh ==1)
    {
      if(vehFrame >0)
      {
    veh = loadImage("V_L_Lv1_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv1_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
          
    }else if(levelOfVeh ==2)
    {
            if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv2_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv2_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }else if(levelOfVeh == 3)
    {
      if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv3_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv3_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }
          Light = loadImage("4 factories left.png");
          image(Light, 0, 0);
           break;
    case 2:
     if(levelOfVeh ==1)
    {
      if(vehFrame >0)
      {
    veh = loadImage("V_L_Lv1_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv1_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
          
    }else if(levelOfVeh ==2)
    {
            if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv2_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv2_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }else if(levelOfVeh == 3)
    {
      if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv3_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv3_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }
          image(veh,0,0);
          Light = loadImage("3 factories left.png");
          image(Light, 0, 0);
           break;
    case 3:
     if(levelOfVeh ==1)
    {
      if(vehFrame >0)
      {
    veh = loadImage("V_L_Lv1_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv1_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
          
    }else if(levelOfVeh ==2)
    {
            if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv2_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv2_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }else if(levelOfVeh == 3)
    {
      if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv3_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv3_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }
       image(veh,0,0);
       Light = loadImage("2 factories left.png");
          image(Light, 0, 0);
        break;
    case 4:
     if(levelOfVeh ==1)
    {
      if(vehFrame >0)
      {
    veh = loadImage("V_L_Lv1_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv1_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
          
    }else if(levelOfVeh ==2)
    {
            if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv2_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv2_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }else if(levelOfVeh == 3)
    {
      if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv3_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv3_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }
       image(veh,0,0);

        break;
     case 5:
   if(levelOfVeh ==1)
    {
      if(vehFrame >0)
      {
    veh = loadImage("V_L_Lv1_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv1_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
          
    }else if(levelOfVeh ==2)
    {
            if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv2_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv2_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }else if(levelOfVeh == 3)
    {
      if(vehFrame >0)
      {
      veh = loadImage("V_L_Lv3_Frame 1.png"); 
      }else{
        veh = loadImage("V_L_Lv3_Frame 2.png"); 
      }
          image(fac, 0, 0);
          vehFrame = vehFrame*(-1);
    }
       image(veh,0,0);
        break;
     default:
       break;
  }
    }
    }
    
    
    bg = loadImage("fuzzyEnder_667_375_bg_L_veh.jpg");
    
    image(bg,0,0);
    
    switch(vehicles.size())
  {     
    case 1:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
        image(fac, 0, 0);
        break;
    case 2:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
        image(veh,0,0);
        break;
    case 3:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
        image(veh,0,0);
        break;
    case 4:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
       image(veh,0,0);
        break;
     case 5:
     switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
       image(veh,0,0);
        break;
     default:
       break;
  }
    IconUp = loadImage("IconUpgrad.png");
    image(IconUp,0,0);
    IconPur = loadImage("IconPurchase.png");
    image(IconPur,0,0);
    

  
  //money & pollutants
  fill(229, 255, 0);
  IconDay = loadImage("IconDay_cc.png");
  image(IconDay, 0,0);
  textSize(20);
  if(today<10)
  {
  text(today, 33, 53);
  }
  else if(today<100)
  {
  text(today, 27, 53);
  }
  IconMoney = loadImage("IconMoney.png");
  image(IconMoney,0,0);
  textSize(14);
  text(currentMoney, 63, 60);
  IconMounts = loadImage("IconMounts.png");
  image(IconMounts,0,0);
  textSize(14);
  text(pollutants.size(), 101,60);
  
  IconFact = loadImage("5-2 - icon - check factory (to zoom in - alpha 40%).png");
  image(IconFact,0,0);
  IconVeh = loadImage("6-3 - icon - check vehicle (to zoom out).png");
  image(IconVeh,0,0);
  textSize(20);
  text(factory.size(), 28,195);
  text("Lv." + levelOfFact,45,195);
textSize(20);
  text(vehicles.size(),28, 265);
  text("Lv." + levelOfVeh,45,265);
  
  
  }
   
 
  //enter the buying factory page
  else if(_pause == true && purchaseVeh == true && confirmedVehPage == false && lightVehi == false)
  {

    int fac1X = 79;
    int fac1Y = 170;
    int fac2X = 197;
    int fac2Y = 170;
    int fac3X = 311;
    int fac3Y = 170;
    int fac4X = 435;
    int fac4Y = 170;
    int fac5X = 539;
    int fac5Y = 170;
    int widthFact = 90;
    int heightFact = 45;
    int facButtonX =1000;
    int facButtonY = 1000;
    
    switch(vehicles.size())
    {
      case 0 :
      facButtonX = fac1X;
      facButtonY = fac1Y;
      break;
      case 1 :
      facButtonX = fac2X;
      facButtonY = fac2Y;
      break;
      case 2 :
      facButtonX = fac3X;
      facButtonY = fac3Y;
      break;
      case 3 :
      facButtonX = fac4X;
      facButtonY = fac4Y;
      break;
      case 4 :
       facButtonX = fac5X;
      facButtonY = fac5Y;
      break;
      case 6:
      text("You have own all the vehicles!", 160,300);
      break;
    }
    
    if(mousePressed == true && mouseX>facButtonX &&mouseX <facButtonX+widthFact && mouseY >facButtonY && mouseY <facButtonY+heightFact )
    {
      if(currentMoney > 10* vehicles.size())
      {
      lightVehi = true;
      }else
      {
        text("Your money is not enough!", 160,300);
      }
    }
     
    
    else if(mousePressed == true && mouseX>18 && mouseX<62 && mouseY >165 && mouseY < 209)
    {
      purchaseVeh = false;
    }
 
    
    bg = loadImage("fuzzyEnder_667_375_bg_L_veh.jpg");
    
    image(bg,0,0);
    
    switch(vehicles.size())
  {     
    case 1:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
        image(fac, 0, 0);
        break;
    case 2:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
        image(veh,0,0);
        break;
    case 3:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
        image(veh,0,0);
        break;
    case 4:
        switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
       image(veh,0,0);
        break;
     case 5:
     switch(levelOfVeh)
        {
          case 1:
          veh = loadImage("V_L_Lv1_Frame 1.png");   
          break;
          case 2:
          veh = loadImage("V_L_Lv2_Frame 1.png");
          break;
          case 3:
          veh = loadImage("V_L_Lv3_Frame 1.png"); 
          break;
        }
       image(veh,0,0);
        break;
     default:
       break;
  }
    
    
    
    
    fill(10,150);
    rect(0,0, width, height);
    
     //front
        veh = loadImage("Vehicle block_1.png"); 
          image(veh, 0, 0);
          
    switch(vehicles.size())
  {   
    case 1:
     lightVeh = loadImage("Glow Vehicle 1st.png");
          image(lightVeh,0,0);
           break;
    case 2:
    lightVeh = loadImage("Glow Vehicle 2nd.png");
          image(lightVeh,0,0);
           break;
    case 3:
    lightVeh = loadImage("Glow Vehicle 3th.png");
     image(lightVeh,0,0);
        break;
    case 4:
           lightVeh = loadImage("Glow Vehicle 4th.png");
          image(lightVeh,0,0);
        break;
     case 5:
         lightVeh = loadImage("Glow Vehicle 5th.png");
          image(lightVeh,0,0);
       break;
     default:
       break;
  }
   
   //IconConfirm = loadImage("IconConfirm.png");
   //image(IconConfirm,0,0);
  
  //money & pollutants
  fill(229, 255, 0);
  IconDay = loadImage("IconDay_cc.png");
  image(IconDay, 0,0);
  textSize(20);
  if(today<10)
  {
  text(today, 33, 53);
  }
  else if(today<100)
  {
  text(today, 27, 53);
  }
  IconMoney = loadImage("IconMoney.png");
  image(IconMoney,0,0);
  textSize(14);
  text(currentMoney, 63, 60);
  IconMounts = loadImage("IconMounts.png");
  image(IconMounts,0,0);
  textSize(14);
  text(pollutants.size(), 101,60);
  IconBack = loadImage("IconBack.png");
  image(IconBack,0,0);
  howMuch = loadImage("FactoryHowMuch.png");
  image(howMuch,0,0);
  textSize(20);
  text("Setting up NEW vehicle costs money!", 180,80);
  
  }
  
else if(_pause == true && purchaseVeh == true && confirmedVehPage == false && lightVehi == true)    
    {
      switch(vehicles.size())
    {
         case 0:
          chooseVeh = loadImage("Vehicle block colored_1.png");
          image(chooseVeh,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
         IconCancel = loadImage("IconCancelNormal.png");
         image(IconCancel,0,0);
       confirmedVehPage = true;  
       break;
        case 1:
          chooseVeh = loadImage("Vehicle block colored_2.png");
          image(chooseVeh,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
         IconCancel = loadImage("IconCancelNormal.png");
         image(IconCancel,0,0);
         confirmedVehPage = true; 
         break;
        case 2:
          chooseVeh = loadImage("Vehicle block colored_3.png");
          image(chooseVeh,0,0);
             IconConfirm = loadImage("IconConfirm.png");
   image(IconConfirm,0,0);
   IconCancel = loadImage("IconCancelNormal.png");
   image(IconCancel,0,0);
   confirmedVehPage = true; 
   break;
        case 3:
          chooseVeh = loadImage("Vehicle block colored_4.png");
          image(chooseVeh,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
   IconCancel = loadImage("IconCancelNormal.png");
   image(IconCancel,0,0);
  confirmedVehPage = true; 
   break;
   case 4:
          chooseVeh = loadImage("Vehicle block colored_5.png");
          image(chooseVeh,0,0);
             IconConfirm = loadImage("IconConfirm.png");
         image(IconConfirm,0,0);
   IconCancel = loadImage("IconCancelNormal.png");
   image(IconCancel,0,0);
  confirmedVehPage = true; 
   break;
         
    }
      
      
    }
   

  
  //confirmBuying
  else if(_pause == true && purchaseVeh == true && confirmedVehPage == true && lightVehi == true)
  {
    int confirmButtonX = 340;
    int confirmButtonY = 265;
    int cancelButtonX = 146;
    int cancelButtonY = 265;
    int buttonWidth = 170;
    int buttonHeight = 49;
    if(mousePressed == true && mouseX>confirmButtonX && mouseX < confirmButtonX + buttonWidth && mouseY > confirmButtonY && mouseY < confirmButtonY + buttonHeight)
    {
     currentMoney = currentMoney - 10 * (factory.size()+1) * levelOfFact;
     //int i = vehicles.size();
     //Vector2D pos = vehPos.get(i);
     vehicles.add(new Vehicles("vehichle", levelOfVeh, 1));
     
     /*
     switch(factory.size())
  {     
    case 2:
    lightFac = loadImage("Glow Factory 2nd.png");
          image(lightFac,0,0);
           break;
    case 3:
    lightFac = loadImage("Glow Factory 3nd.png");
     image(lightFac,0,0);
        break;
    case 4:
           lightFac = loadImage("Glow Factory 4nd.png");
          image(lightFac,0,0);
        break;
     case 5:
         lightFac = loadImage("Glow Factory 5nd.png");
          image(lightFac,0,0);
       break;
     default:
       break;
  }
  */
  confirmedVehPage = false;
  lightVehi= false;
    }
    
    else if(mousePressed == true && mouseX>cancelButtonX && mouseX < cancelButtonX + buttonWidth && mouseY > cancelButtonY && mouseY < cancelButtonY + buttonHeight)
    {
      confirmedVehPage = false;
      lightVehi = false;
      
    }
    
  }
  

  
  
  
  
  
}


public int bubbleCollector()
{
  int j = -1;
  for(int i = 0 ; i< pollutants.size(); i++)
  {
    Pollutant poll = pollutants.get(i);
    if(mouseX>(poll.pos().x+30 ) && mouseX<(poll.pos().x+90) && mouseY>(poll.pos().y+ 30) && mouseY<(poll.pos().y+90))
    {
      j = i;
    }
  }
  return j;
}

public int policy()
{
  Governer govener = new Governer(today, AQI);
  if(govener.reporting())
  {
    shade =loadImage("Shade.png");
    image(shade,0,0);
          alarm = loadImage("4 - icon - alarming(on).png");
  image(alarm,-11,2);
      report = loadImage("Regulation Slice 1 - content 1.png");
    image(report,0,0);
    fill(220,109,103);
    text("The factories and vehicles are forced to pause for 3 days",100,300);
    text("Click to continue ",230,320);
    pausePolicy = true;
    return 1;
  }else if(govener.reduction())
  {       
     shade =loadImage("Shade.png");
    image(shade,0,0);
              alarm = loadImage("4 - icon - alarming(on).png");
  image(alarm,-11,2);
  report = loadImage("Regulation Slice 1 - content 2.png");
    image(report,0,0);
    fill(220,109,103);
    text("All the molecules on the map are cleared by government",100,300);
    text("Click to continue ",230,320);
    pausePolicy = true;
    
    
    return 2;
  }else if(govener.regulation())
  {
     shade =loadImage("Shade.png");
    image(shade,0,0);
              alarm = loadImage("4 - icon - alarming(on).png");
  image(alarm,-11,2);
    report = loadImage("Regulation Slice 1 - content 3.png");
    image(report,0,0);
    fill(220,109,103);
    text("The factories and vehicles are forced to downgrade ",100,300);
    text("Click to continue ",230,320);
    pausePolicy = true;
    return 3;
  }else if(govener.specialDay())
  {
    return 0;
  }else 
  {
    return 0;
  }
  
}
