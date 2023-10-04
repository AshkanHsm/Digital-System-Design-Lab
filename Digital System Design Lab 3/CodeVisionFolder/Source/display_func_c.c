#include <header.h>
char data_key[]={
    '0','1','2','3',
    '4','5','6','7',
    '8','9','A','B',
    'C','D','E','F'};
//////////////////////////////////
void call_LCD(void)  
{
   
// Declare your local variables here

    // Input/Output Ports initialization
    // Port A initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    // Port B initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

    // Alphanumeric LCD initialization
    // Connections are specified in the
    // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
    // RS - PORTA Bit 0
    // RD - PORTA Bit 1
    // EN - PORTA Bit 2
    // D4 - PORTA Bit 4
    // D5 - PORTA Bit 5
    // D6 - PORTA Bit 6
    // D7 - PORTA Bit 7
    // Characters/line: 16

    lcd_init(16);
}

///////////////////////////////////
void Q1(char *last_name,char *std_nu)
{
    lcd_clear();
    lcd_puts(last_name);
    lcd_gotoxy(0, 1);
    lcd_puts(std_nu);    
}
////////////////////////////////////
void Q2(char *sentence)
{
    int i,j;
    int length_sentence;
    for(i=0;sentence[i]!='\0';i++)
    {
        length_sentence=i;  
    }
    length_sentence++;
    for(j=15;j>=0;j--)
    { 
        lcd_gotoxy(j,1);
        delay_ms(160);
        for(i=0;i<16-j;i++)
        {
            lcd_putchar(sentence[i]);    
        }           
    }
    for(j=0;j<length_sentence-15;j++){
        lcd_gotoxy(0,1);
        delay_ms(160);
            for(i=j;i<16+j;i++)
            {
                lcd_putchar(sentence[i]);    
            }
    }
}
///////////////////////////////////
char Q3(void)
{
    int r,c;
    char key=100;
    char row[]={0x10,0x20,0x40,0x80};
    for (r=0;r<4;r++)
    {
        PORTB=row[r];
        c=20;
        delay_ms(10);
        if (PINB.0==1) c=0;
        if (PINB.1==1) c=1;
        if (PINB.2==1) c=2;
        if (PINB.3==1) c=3;
            if (!(c==20)){
                key=(r*4)+c;
                PORTB=0xf0;
                while (PINB.0==1) {}
                while (PINB.1==1) {}
                while (PINB.2==1) {}
                while (PINB.3==1) {}
            }
        PORTB=0xf0;
        }
    return data_key[key];
}
///////////////////////////////////
void Q4(void){    
    char pinholder=PINB&0x0f;
    if(pinholder!=0x00)
    {
        lcd_gotoxy(0,0);
        lcd_putchar(Q3());
        delay_ms(200);
    }
}

//////////////////////////////////////////
void printMessage(char * Message) {
    char myMessage[16]="               ";
    char length=strlen(myMessage);
    char i=0;
    strcpy(myMessage,Message);
    lcd_clear();
    lcd_gotoxy(0,0);
	for(i=0; i<length; i++) {
		lcd_putchar(myMessage[i]);
	}

}
void Q5() {
	char InputValue1='x';
	char InputValue2='y';
	char CorrectValue=0;//True=1  false=0
	char Message1[16]="Speed:??(0-50r)";
	char Message2[16]="Time:??(0-99s)";
	char Message3[16]="W:??(0-99kg)";
	char Message4[16]="Temp:??(20-80C)";
	char QuestionIndex='1';


	for(QuestionIndex='1'; QuestionIndex<='4'; QuestionIndex++) {


		if(QuestionIndex=='1') {
			lcd_clear();
			lcd_gotoxy(0,0);
			printMessage(Message1);
			delay_ms(1000);

			while(CorrectValue==0) {
				InputValue1='t';
				InputValue2='t';
				lcd_gotoxy(6,0);
				lcd_putchar('?') ;
				lcd_putchar('?') ;
				delay_ms(600);

				while(!(InputValue1>='0' & InputValue1<='9')) { 


					while((PINB&0x0f)==0x00) {
						
					}

					
					InputValue1=Q3();
				}
				lcd_gotoxy(6,0);
				lcd_putchar(InputValue1) ;
				

				while(!(InputValue2>='0' & InputValue2<='9')) { 


					while((PINB&0x0f)==0x00) {
						
					}

					
					InputValue2=Q3();
				}
				lcd_gotoxy(7,0);
				lcd_putchar(InputValue2) ;

				
				delay_ms(500);
				if(InputValue1>='0'& InputValue1<'5') {
					if(InputValue2>='0'& InputValue2<='9') {

						CorrectValue=1;
					}
				} else if( InputValue1=='5'& InputValue2=='0') {
					CorrectValue=1;
				} else {
					CorrectValue=0;
					lcd_gotoxy(6,0)  ;
					lcd_putchar('E') ;
					lcd_putchar('E') ;
					delay_ms(1000);

				}
				
			} 

		}

		if(QuestionIndex=='2') {
			CorrectValue=0;
			lcd_clear();
			lcd_gotoxy(0,0);
			printMessage(Message2);


			while(CorrectValue==0) {
				InputValue1='t';
				InputValue2='t';
				lcd_gotoxy(5,0);
				lcd_putchar('?') ;
				lcd_putchar('?') ;
				delay_ms(600);

				while(!(InputValue1>='0' & InputValue1<='9')) { 


					while((PINB&0x0f)==0x00) {

					}

				
					InputValue1=Q3();
				}
				lcd_gotoxy(5,0);
				lcd_putchar(InputValue1) ;
				

				while(!(InputValue2>='0' & InputValue2<='9')) {


					while((PINB&0x0f)==0x00) {

					}

					InputValue2=Q3();
				}
				lcd_gotoxy(6,0);
				lcd_putchar(InputValue2) ;
				delay_ms(1000);


				
				CorrectValue=1;
			} 
		}

		if(QuestionIndex=='3') {
			CorrectValue=0;
			lcd_clear();
			lcd_gotoxy(0,0);
			printMessage(Message3);


			while(CorrectValue==0) {
				InputValue1='t';
				InputValue2='t';
				lcd_gotoxy(2,0);
				lcd_putchar('?') ;
				lcd_putchar('?') ;
				delay_ms(600);

				while(!(InputValue1>='0' & InputValue1<='9')) { 


					while((PINB&0x0f)==0x00) {
						
					}

					
					InputValue1=Q3();
				}
				lcd_gotoxy(2,0);
				lcd_putchar(InputValue1) ;
				

				while(!(InputValue2>='0' & InputValue2<='9')) { 


					while((PINB&0x0f)==0x00) {
						
					}

					
					InputValue2=Q3();
				}
				lcd_gotoxy(3,0);
				lcd_putchar(InputValue2) ;
				delay_ms(1000);

				
				
				CorrectValue=1;
			} 
		}


		if(QuestionIndex=='4') {
			CorrectValue=0;
			lcd_clear();
			lcd_gotoxy(0,0);
			printMessage(Message4);


			while(CorrectValue==0) {
				InputValue1='t';
				InputValue2='t';
				lcd_gotoxy(5,0);
				lcd_putchar('?') ;
				lcd_putchar('?') ;
				delay_ms(600);

				while(!(InputValue1>='0' & InputValue1<='9')) { 


					while((PINB&0x0f)==0x00) {
						
					}

					
					InputValue1=Q3();
				}
				lcd_gotoxy(5,0);
				lcd_putchar(InputValue1) ;
				

				while(!(InputValue2>='0' & InputValue2<='9')) { 


					while((PINB&0x0f)==0x00) {
					
					}

					
					InputValue2=Q3();
				}
				lcd_gotoxy(6,0);
				lcd_putchar(InputValue2) ;


				
				delay_ms(500);
				if(InputValue1>='2'& InputValue1<='7') {
					if(InputValue2>='0'& InputValue2<='9') {

						CorrectValue=1;
					}
				} else if(InputValue1=='8'& InputValue2=='0') {
					CorrectValue=1;
				} else {
					CorrectValue=0;
					lcd_gotoxy(5,0)  ;
					lcd_putchar('E') ;
					lcd_putchar('E') ;
					delay_ms(1000);

                }
            }
        }


    }
    printMessage("End");
    delay_ms(2000);

}