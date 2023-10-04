//q1 Student name and ID in 2 lines
//q2 "Welcome to the Microprocessor lab classes in Isfahan University of Technology"
#include <HeaderFiles.h>

//***----Q1----*** Timer_Watch
void chronometerkeycheck_INT1(){

    TurnOFF_AllTimers();
    TurnOn_SelectedTimer(0);
    //check pinb4(start) and 5 (stop)
    if(PINB.4==0)
    {
        //start
        pause=0;
        reset=0;
        start=1;


    }
    if(PINB.5==0){
        //stop
        reset=0;
        if(pause==1){
         reset=1;
        }
        pause=1;
        start=0;
    }


}

void chronometer_INT(){

    char hour[3]="00";
    char min[3]="00";
    char sec[3]="00";
    char mSec[3]="00";
    // Reinitialize Timer1 value
    TCNT1H=0xD8F0 >> 8;
    TCNT1L=0xD8F0 & 0xff;
    // Place your code here

    //shomaresh
    if(reset ==1){
     M_Sec=0;
     Sec=0;
     Minute=0;
     Hour=0;
     lcd_gotoxy(0,0);
     lcd_puts("               ");
      lcd_gotoxy(0,0);
     lcd_puts("00:00:00:00     ");

    }
    if(start==1){


        M_Sec+=1;// 10

        if(M_Sec==100){
            M_Sec=0;
            Sec+=1;
            if(Sec==60){
                Sec=0;
                Minute+=1;
                if(Minute==60){
                  Minute=0;
                  Hour+=1;
                }
            }
        }
        // tabdil be String
        if(M_Sec<10){
             sprintf(mSec,"0%d",M_Sec);
        }
        else{
            sprintf(mSec,"%d",M_Sec);
        }
        if(Sec<10){
            sprintf(sec,"0%d",Sec);
        }
        else{
            sprintf(sec,"%d",Sec);
        }
        if(Minute<10){
            sprintf(min,"0%d",Minute);
        }
        else{
            sprintf(min,"%d",Minute);
        }
        if(Hour<10){
            sprintf(hour,"0%d",Hour);
        }
        else{
            sprintf(hour,"%d",Hour);
        }
         lcd_gotoxy(0,0);

         lcd_putchar(hour[0]);
         lcd_putchar(hour[1]);
         lcd_putchar(':');
         lcd_putchar(min[0]) ;
         lcd_putchar(min[1]) ;
         lcd_putchar(':');
         lcd_putchar(sec[0])  ;
         lcd_putchar(sec[1])  ;
         lcd_putchar(':');
         lcd_putchar(mSec[0])  ;
         lcd_putchar(mSec[1])  ;

    }
}

//***----End_Q1----***
//=============================================================
//***----Q2----*** Car
void CarIntruptCheck(){


    if(PINB.7==0)
    {
        //in
        if(FreeParkingLot>=1){
          FreeParkingLot-=1;
        }

    }
    if(PINB.3==0){
        //out
        if(FreeParkingLot<=999){
          FreeParkingLot+=1;
        }

    }
    ParkingSpaceShow_LCD()  ;
}

void ParkingSpaceShow_LCD(){
    char STRING_FreeCarSpaceCount[6]="     ";
    sprintf(STRING_FreeCarSpaceCount,"%d       ",FreeParkingLot)    ;
    lcd_gotoxy(0,1);
    if( FreeParkingLot==0){
        lcd_puts("FULL");
    }
    else
        lcd_puts(STRING_FreeCarSpaceCount);
}

//***----End_Q2----***
// ==========================================================
//***----Q3 ------****

void TurnOFF_AllTimers(){
    TCCR0 = (0<<CS02)| (0<<CS01)| (0<<CS00);
    TCCR1B = (0<<CS12)| (0<<CS11)| (0<<CS10);
    TCCR2 = (0<<CS22)| (0<<CS21)| (0<<CS20);


}
//Only select Timer 1 or 0
void TurnOn_SelectedTimer(int SelectedTimer ){



    if(SelectedTimer==0){
      TCCR0 = (1<<CS02)| (0<<CS01)| (1<<CS00);
    }
    else if(SelectedTimer==1){
        if(Freq==8){
            TCCR1B =  (0<<CS12)| (1<<CS11)| (0<<CS10); //8MHz  -> Period = 0.256 ms
        }
        else
            TCCR1B =  (0<<CS12)| (0<<CS11)| (1<<CS10); //1Mhz  -> Period = 2.048 ms
    }
}

void FrequencySelect_INT2(){
    //change Frequency
    if(Freq==1){
        Freq=8;
    }
    else{
        Freq=1 ;
    }
   // timer pause:
    reset=0;

    pause=1;
    start=0;
    //Timers Status
    TurnOFF_AllTimers();
    TurnOn_SelectedTimer(1);
    PeriodDisplay();


}
void PeriodDisplay()
{
    lcd_gotoxy(8,1) ;
    if(  Freq==8){
        lcd_puts("2.048ms");
    }
    else
      lcd_puts("0.256ms");

}