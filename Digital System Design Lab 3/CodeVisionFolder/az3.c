/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/19/2022
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include <header.h>
// Alphanumeric LCD functions


// Declare your global variables here

void main(void)
{
    char m='\0';
    call_LCD();
    Q1("Hashemi","9830113");
    delay_ms(5000);
    lcd_clear();
    Q2("Welcome to the Microprocessor Laboratory at Isfahan University of Technology.");   
    lcd_clear();
    while (1)
          {
           DDRB=0xf0;
           m=Q3();
           while (m!='\0'){
                lcd_gotoxy(0,0);
                lcd_putchar(m);
                m=Q3();
          }
}
}
