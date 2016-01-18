public class Governer {
  public float governerDecisionRate = difficulty*0.2;
  public int day;
  public int AQI;
  public Governer (int _day, int _AQI){
    day = _day;

    AQI = _AQI;
  }
  public boolean reporting(){
    if(AQI>=100 && AQI <= 300 && day%18==0)
    {
    return true;
    }else 
    {
      return false;
    }
  }
  
  public boolean  reduction(){
    if(day == 15 ||day ==32 || day==50 || day ==75)
    {
    return true;
    }else 
    {
      return false;
    }
  }
  
  public boolean  regulation(){
        if(AQI>=300 && day%13 ==0 )
    {
    return true;
    }else 
    {
      return false;
    }
  }
  
  public boolean  specialDay(){
    return false;
  }
  
  
  
}
