/*
 * AZ1.c
 *
 * Created: 10/5/2022 6:15:12 PM
 */

#include <io.h>


#include <mega16.h>
#include <delay.h>
const int Delaytime=37500;

void Start();
void BlinkLED_Q1();
void LedLightDance_Q2();
void SwitchToLed_Q3();
void UpDownCount_Q4();
void SevenSegDecrease_Q5();
void SevenSegShowNumber(int SegmentNumber,int dot);
void SevenSegZeroButton_Q6();

//Main---------------------------------------------------
void main(void)
{
    Start();
  BlinkLED_Q1();  
   LedLightDance_Q2();    
    UpDownCount_Q4()  ;
    SevenSegDecrease_Q5();

while (1)
    {
         SwitchToLed_Q3();
         SevenSegZeroButton_Q6();
    }
}

//-----------------------------------------------------------


void Start(){
    DDRA=0x00;
    DDRB=0xff;
    DDRC=0xff;
    DDRD=0x0f;
}
void BlinkLED_Q1()
{
    int i=0;
    for(i=0;i<4;i++){
        PORTB=0xff;
        delay_ms(500);
        PORTB=0x00;
        delay_ms(500);
    }
}
void LedLightDance_Q2()
{
    PORTB=0b10000000;
    delay_us(Delaytime);
    PORTB=0b01000000;
    delay_us(Delaytime);
    PORTB=0b00100000;
    delay_us(Delaytime);
    PORTB=0b00010000;
    delay_us(Delaytime);
    PORTB=0b00001000;
    delay_us(Delaytime);
    PORTB=0b00000100;
    delay_us(Delaytime);
    PORTB=0b00000010;
    delay_us(Delaytime);
    PORTB=0b00000001;
    delay_us(Delaytime);
    PORTB=0b10000000;
}

void SwitchToLed_Q3()
{
    PORTB=PINA;
}

void UpDownCount_Q4()
{
    int DelayTime=700;
    PORTD=0x00;
      PORTC=0b01101111;      
      delay_ms(DelayTime);
      PORTC= 0b01111111;
      delay_ms(DelayTime);
      PORTC= 0b00000111;
      delay_ms(DelayTime);
      PORTC=  0b01111101;
      delay_ms(DelayTime);
      PORTC=  0b01101101;    
      delay_ms(DelayTime);
      PORTC=   0b01100110;
      delay_ms(DelayTime);
      PORTC=   0b01001111;
      delay_ms(DelayTime);
      PORTC=    0b01011011;
      delay_ms(DelayTime);
      PORTC=    0b00000110;
      delay_ms(DelayTime);
      PORTC=   0b00111111;
      delay_ms(DelayTime);

}




void SevenSegDecrease_Q5()
{
    int h,d,u,dp;
    int x,y;
    int i;
    x=PINA;
    y=PINA;
    
    y=y*10;
    while (y+2){
    for (i=0;i<10;i++) {
    x=y;
    h=x/1000;
    x=x-h*1000;
    PORTD=0x0E;
    SevenSegShowNumber(h,0);
    delay_ms(5);
    d=x/100;
    x=x-d*100;
    PORTD=0x0D;
    SevenSegShowNumber(d,0);
    delay_ms(5);
    u=x/10;
    x=x-u*10;
    PORTD=0x0B; 
    SevenSegShowNumber(u,1);
    delay_ms(5);
    dp=x;
    PORTD=0x07;
    SevenSegShowNumber(dp,0);
    delay_ms(5);}
    y=y-2;
    
    }



}


void SevenSegShowNumber(int SegmentNumber,int dot)
{

    int b= SegmentNumber;
    if (b==0)
    {
        PORTC=0b00111111;
    }
    else if(b==1)
    {
        PORTC=    0b00000110;
    }
    else if(b==2)
    {
       PORTC=    0b01011011;
    }
    else if(b==3)
    {
        PORTC=   0b01001111;
    }
    else if(b==4){
        PORTC=   0b01100110;
    }
    else if(b==5){
         PORTC=  0b01101101;
    }  
    else if(b==6){
        PORTC=  0b01111101;
    }
    else if(b==7){
        PORTC= 0b00000111;
    }
    else if(b==8){
         PORTC= 0b01111111;
    }
    else
     {
      PORTC=0b01101111;
     }
    if (dot==1){
        PORTC.7=1;
    }

}


void SevenSegZeroButton_Q6()
{
        int h,d,u,dp;
    int x,y;
    char D4,D5,D6,D7; 
    char Doff4,Doff5,Doff6,Doff7;
    
     int i;
    
    x=PINA;
    y=PINA;
    
    y=y*10;
    while (y+2){
    D4=PIND.4;
    D5=PIND.5;
    D6=PIND.6;
    D7=PIND.7;

    for (i=0;i<10;i++) {   
    x=y;
    
    h=x/1000;
    x=x-h*1000;
    PORTD=0x0E;
    if(!D4){
    SevenSegShowNumber(0,0);
    }
    else{
    SevenSegShowNumber(h,0);
    }
    
    delay_ms(5);
    d=x/100;
    x=x-d*100;
    PORTD=0x0D;
    if(!D5){
    SevenSegShowNumber(0,0);
    }
    else{
    SevenSegShowNumber(d,0);
    }
    
    delay_ms(5);
    u=x/10;
    x=x-u*10;
    PORTD=0x0B;
    if(!D6){
    SevenSegShowNumber(0,0);
    }
    else{
    SevenSegShowNumber(u,1);
    } 
    
    delay_ms(5);
    dp=x;
    PORTD=0x07;
    if(!D7){
    SevenSegShowNumber(0,0);
    }
    else{
    SevenSegShowNumber(dp,0);
    }
    
    delay_ms(5);}
    y=y-2;
    }
}