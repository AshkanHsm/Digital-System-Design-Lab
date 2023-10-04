#include <HeaderFiles.h>


void ADC_init_Q1()
{

    // ADC initialization
    // ADC Clock frequency: 1000.000 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Auto Trigger Source: Free Running
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

}
void ADC_init_Q2()
{
    // ADC initialization
    // ADC Clock frequency: 1000.000 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Auto Trigger Source: Free Running
    ADMUX=FIRST_ADC_INPUT | ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADATE) | (0<<ADIF) | (1<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
}
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}

int ADC_To_Voltage(char adc_Channel,int adc_Value)
{
     int voltage=0;
    ADC_Value=read_adc(adc_Channel);
    //convert Dout to Voltage_mv
    voltage=ADC_Value*4.88;   // taghriban !!!   Vin= Dout*5*1000/1024

    return voltage;

}

void Save_Voltage_ADC_ByChannel_Q1(char adc_Channel)
{
     int voltage=0;
     ADC_Value=read_adc(adc_Channel);
     voltage =ADC_To_Voltage(adc_Channel,ADC_Value);
     MySaved_Voltage[adc_Channel]= voltage;
}
void Display_Voltage_ByChannel(char adc_Channel){
        sprintf(adcStringINPUT,"Ch:%d (%d mv)",adc_Channel,MySaved_Voltage[adc_Channel]);
        lcd_puts(adcStringINPUT);
}


void Display_Voltage_AllChannels(){
       int i=0;
       while(i<=7){
           Display_Voltage_ByChannel(i);
           delay_ms(500);
           lcd_clear();
           i++;
       }
}


// ===============QUEstion 1 !! ======================================
void Question1(){
       int i=0;
       while(i<=7){   // first capture ADC values and convert them to voltage and save them to [MySaved_Voltage]
           Save_Voltage_ADC_ByChannel_Q1(i);
           i++;
       }
       Display_Voltage_AllChannels();
}

//---------------q2
 void interupt_ADC_Q2(){

    static unsigned char input_index=0;
    // Read the AD conversion result
    adc_data[input_index]=ADCW;
    // Select next ADC input
    if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
       input_index=0;
    ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
 }


 void Detect_Voltage_change(){
   int i =0;
   int New_Voltage=0;
   int deltaVoltage=0;
   char Changed=0;
   while(i<=7)
   {
      New_Voltage=adc_data[i]*4.88;
      if( New_Voltage< MySaved_Voltage[i]) {
        deltaVoltage=MySaved_Voltage[i]-New_Voltage;
      }
      else  {
      deltaVoltage=New_Voltage-MySaved_Voltage[i];
      }


      if(MySaved_Voltage[i]/20<deltaVoltage){

            MySaved_Voltage[i]=New_Voltage;
            changedValue_Channel=i;
            Changed=1;
            break;

      }
      i++;

   }
   if (Changed==0)
     changedValue_Channel=10; // mean No change

 }

 void Question2(){
    Detect_Voltage_change();
    if( changedValue_Channel<=7 &&changedValue_Channel>=0){
        lcd_clear();
        Display_Voltage_ByChannel(changedValue_Channel);
         delay_ms(100);

    }
 }
 void Display_changedVoltages_Q2(){
       Display_Voltage_ByChannel(changedValue_Channel);
}

 void Question3(){
    OCR0=adc_data[0]/4;
 }
