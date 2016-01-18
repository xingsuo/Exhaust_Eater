public class Polluter{
  
  public String polluterKind;
  int pollterLevel;
  public int pollutionProduceAmount;
  //public int produceFactor;
  
  
  
  public Polluter (String _kind, int _level){
    polluterKind = _kind;
    pollterLevel = _level;
    // produceFactor = _produceFactor;
    
  }
  
  /*
  public int pollutionProduceCaculator(){
    pollutionProduceAmount =  produceFactor * pullterLevel;
    return pollutionProduceAmount;
  }
  */
  
  public void polluterLevelListener(int decision)
  {
    pollterLevel = pollterLevel + decision;
    
  }
  
  public int getLevel()
  {
    return pollterLevel;
  }
}










/*
public class Polluter {
  public int initalFactoryProduceAmount = 5;
  public int initalVehicleProduceAmount = 5;
  public int AQIFactorOfFactory = 1;
  public int AQIFactorOfVehicle = 1.3;
  public int x, y;
  
  public int pollutionProduceCaculator(String kind, int level, int amount){
    int pollutionAmount = 0;
    if (kind == "factory")
    {
      pollutionAmount = level * amount * initalFactoryProduceAmount;
    }
    if (kind == "vehicle")
    {
      pollutionAmount = level * amount * initalVehicleProduceAmount;
    }
    
    return pollutionAmount;
  }
  
    public int level(int polluterUpgradDecisionAmount, int governerDowngradDecisionAmount) 
    {
    int level = 1;
    level = level + factoryUpgradDecisionAmount - governerDowngradDecisionAmount;
    return level;
    }
  
  public int polluterAQICaculator(String kind, int level, int amount){
    int AQIOfThisPolluter;
    switch(kind){
        case "factory":
              AQIOfThisPolluter = level * amount * AQIFactorOfFactory ;
        case "vehicle":
               AQIOfThisPolluter = level * amount * AQIFactorOfVehicle ;
        break;
    }
    return AQIOfThisPolluter;
  }
  
  void polluterRender(){
    
  }
  

  
}

*/
