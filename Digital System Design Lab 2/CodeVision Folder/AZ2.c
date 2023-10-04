/*
 * AZ2.c
 *
 * Created: 10/13/2022 2:40:23 PM
 * Author: user
 */
#include <header.h>
#include <port_fun_h.h>

void main(void)
{
    char data_out;
    data_out=Q3(4,500);
    while(1) {
//        data_out=Q1(port_D,port_B);
//        delay_ms(100);
//        data_out=Q2(port_B,0x55);
//        delay_ms(100);
//        Q4();
//        delay_ms(100);
        Q5(8976,port_C,port_D);
         
    }
}

