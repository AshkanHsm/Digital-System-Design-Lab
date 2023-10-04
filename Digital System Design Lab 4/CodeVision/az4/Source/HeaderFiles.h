#ifndef _HeaderFiles_h_INCLUDED_
#define _HeaderFiles_h_INCLUDED_

    #include <stdio.h>
    #include <mega16.h>
    #include <alcd.h>
    #include <string.h>
    #include <delay.h>
    #include <alcd.h>
    #include <My_Functions.h>


    //*****---------Variables----------*****

    //Car====================
    extern int FreeParkingLot;
    //=======================
    //timer====================
    extern int M_Sec;
    extern int Sec;    // 1 Sec ==1000 M_Sec
    extern int Minute; //1 Minute==60Sec
    extern int Hour; // 1 Houre=60 minute

    extern char pause; // set them 1 to action this 3 functions!
    extern char reset;
    extern char start;
    //=========================
    //=========== Osiloscope pulse!
    extern char Freq; // 1 or 8

    //*****---------End_Variables----------*****

#endif

