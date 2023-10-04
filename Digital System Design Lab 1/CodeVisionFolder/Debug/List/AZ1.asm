
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x7C,0x92

__GLOBAL_INI_TBL:
_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*
; * AZ1.c
; *
; * Created: 10/5/2022 6:15:12 PM
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;#include <mega16.h>
;#include <delay.h>
;const int Delaytime=37500;

	.DSEG
;
;void Start();
;void BlinkLED_Q1();
;void LedLightDance_Q2();
;void SwitchToLed_Q3();
;void UpDownCount_Q4();
;void SevenSegDecrease_Q5();
;void SevenSegShowNumber(int SegmentNumber,int dot);
;void SevenSegZeroButton_Q6();
;
;//Main---------------------------------------------------
;void main(void)
; 0000 0019 {

	.CSEG
_main:
; .FSTART _main
; 0000 001A     Start();
	RCALL _Start
; 0000 001B   BlinkLED_Q1();
	RCALL _BlinkLED_Q1
; 0000 001C    LedLightDance_Q2();
	RCALL _LedLightDance_Q2
; 0000 001D     UpDownCount_Q4()  ;
	RCALL _UpDownCount_Q4
; 0000 001E     SevenSegDecrease_Q5();
	RCALL _SevenSegDecrease_Q5
; 0000 001F 
; 0000 0020 while (1)
_0x4:
; 0000 0021     {
; 0000 0022          SwitchToLed_Q3();
	RCALL _SwitchToLed_Q3
; 0000 0023          SevenSegZeroButton_Q6();
	RCALL _SevenSegZeroButton_Q6
; 0000 0024     }
	RJMP _0x4
; 0000 0025 }
_0x7:
	RJMP _0x7
; .FEND
;
;//-----------------------------------------------------------
;
;
;void Start(){
; 0000 002A void Start(){
_Start:
; .FSTART _Start
; 0000 002B     DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 002C     DDRB=0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 002D     DDRC=0xff;
	OUT  0x14,R30
; 0000 002E     DDRD=0x0f;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 002F }
	RET
; .FEND
;void BlinkLED_Q1()
; 0000 0031 {
_BlinkLED_Q1:
; .FSTART _BlinkLED_Q1
; 0000 0032     int i=0;
; 0000 0033     for(i=0;i<4;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x9:
	__CPWRN 16,17,4
	BRGE _0xA
; 0000 0034         PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0035         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0036         PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0037         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0038     }
	__ADDWRN 16,17,1
	RJMP _0x9
_0xA:
; 0000 0039 }
	RJMP _0x2000001
; .FEND
;void LedLightDance_Q2()
; 0000 003B {
_LedLightDance_Q2:
; .FSTART _LedLightDance_Q2
; 0000 003C     PORTB=0b10000000;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x0
; 0000 003D     delay_us(Delaytime);
; 0000 003E     PORTB=0b01000000;
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x0
; 0000 003F     delay_us(Delaytime);
; 0000 0040     PORTB=0b00100000;
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x0
; 0000 0041     delay_us(Delaytime);
; 0000 0042     PORTB=0b00010000;
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x0
; 0000 0043     delay_us(Delaytime);
; 0000 0044     PORTB=0b00001000;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x0
; 0000 0045     delay_us(Delaytime);
; 0000 0046     PORTB=0b00000100;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x0
; 0000 0047     delay_us(Delaytime);
; 0000 0048     PORTB=0b00000010;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x0
; 0000 0049     delay_us(Delaytime);
; 0000 004A     PORTB=0b00000001;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x0
; 0000 004B     delay_us(Delaytime);
; 0000 004C     PORTB=0b10000000;
	LDI  R30,LOW(128)
	RJMP _0x2000002
; 0000 004D }
; .FEND
;
;void SwitchToLed_Q3()
; 0000 0050 {
_SwitchToLed_Q3:
; .FSTART _SwitchToLed_Q3
; 0000 0051     PORTB=PINA;
	IN   R30,0x19
_0x2000002:
	OUT  0x18,R30
; 0000 0052 }
	RET
; .FEND
;
;void UpDownCount_Q4()
; 0000 0055 {
_UpDownCount_Q4:
; .FSTART _UpDownCount_Q4
; 0000 0056     int DelayTime=700;
; 0000 0057     PORTD=0x00;
	ST   -Y,R17
	ST   -Y,R16
;	DelayTime -> R16,R17
	__GETWRN 16,17,700
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0058       PORTC=0b01101111;
	LDI  R30,LOW(111)
	RCALL SUBOPT_0x1
; 0000 0059       delay_ms(DelayTime);
; 0000 005A       PORTC= 0b01111111;
	LDI  R30,LOW(127)
	RCALL SUBOPT_0x1
; 0000 005B       delay_ms(DelayTime);
; 0000 005C       PORTC= 0b00000111;
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x1
; 0000 005D       delay_ms(DelayTime);
; 0000 005E       PORTC=  0b01111101;
	LDI  R30,LOW(125)
	RCALL SUBOPT_0x1
; 0000 005F       delay_ms(DelayTime);
; 0000 0060       PORTC=  0b01101101;
	LDI  R30,LOW(109)
	RCALL SUBOPT_0x1
; 0000 0061       delay_ms(DelayTime);
; 0000 0062       PORTC=   0b01100110;
	LDI  R30,LOW(102)
	RCALL SUBOPT_0x1
; 0000 0063       delay_ms(DelayTime);
; 0000 0064       PORTC=   0b01001111;
	LDI  R30,LOW(79)
	RCALL SUBOPT_0x1
; 0000 0065       delay_ms(DelayTime);
; 0000 0066       PORTC=    0b01011011;
	LDI  R30,LOW(91)
	RCALL SUBOPT_0x1
; 0000 0067       delay_ms(DelayTime);
; 0000 0068       PORTC=    0b00000110;
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x1
; 0000 0069       delay_ms(DelayTime);
; 0000 006A       PORTC=   0b00111111;
	LDI  R30,LOW(63)
	RCALL SUBOPT_0x1
; 0000 006B       delay_ms(DelayTime);
; 0000 006C 
; 0000 006D }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;
;
;void SevenSegDecrease_Q5()
; 0000 0073 {
_SevenSegDecrease_Q5:
; .FSTART _SevenSegDecrease_Q5
; 0000 0074     int h,d,u,dp;
; 0000 0075     int x,y;
; 0000 0076     int i;
; 0000 0077     x=PINA;
	SBIW R28,8
	CALL __SAVELOCR6
;	h -> R16,R17
;	d -> R18,R19
;	u -> R20,R21
;	dp -> Y+12
;	x -> Y+10
;	y -> Y+8
;	i -> Y+6
	IN   R30,0x19
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0078     y=PINA;
	IN   R30,0x19
	LDI  R31,0
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0079 
; 0000 007A     y=y*10;
	RCALL SUBOPT_0x2
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 007B     while (y+2){
_0xB:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,2
	BREQ _0xD
; 0000 007C     for (i=0;i<10;i++) {
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xF:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,10
	BRGE _0x10
; 0000 007D     x=y;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 007E     h=x/1000;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x3
; 0000 007F     x=x-h*1000;
	RCALL SUBOPT_0x4
; 0000 0080     PORTD=0x0E;
	LDI  R30,LOW(14)
	OUT  0x12,R30
; 0000 0081     SevenSegShowNumber(h,0);
	ST   -Y,R17
	ST   -Y,R16
	RCALL SUBOPT_0x5
; 0000 0082     delay_ms(5);
; 0000 0083     d=x/100;
	RCALL SUBOPT_0x6
; 0000 0084     x=x-d*100;
	RCALL SUBOPT_0x4
; 0000 0085     PORTD=0x0D;
	LDI  R30,LOW(13)
	OUT  0x12,R30
; 0000 0086     SevenSegShowNumber(d,0);
	ST   -Y,R19
	ST   -Y,R18
	RCALL SUBOPT_0x5
; 0000 0087     delay_ms(5);
; 0000 0088     u=x/10;
	RCALL SUBOPT_0x7
; 0000 0089     x=x-u*10;
	RCALL SUBOPT_0x4
; 0000 008A     PORTD=0x0B;
	LDI  R30,LOW(11)
	OUT  0x12,R30
; 0000 008B     SevenSegShowNumber(u,1);
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x8
; 0000 008C     delay_ms(5);
; 0000 008D     dp=x;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 008E     PORTD=0x07;
	LDI  R30,LOW(7)
	OUT  0x12,R30
; 0000 008F     SevenSegShowNumber(dp,0);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x8
; 0000 0090     delay_ms(5);}
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0xF
_0x10:
; 0000 0091     y=y-2;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,2
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0092 
; 0000 0093     }
	RJMP _0xB
_0xD:
; 0000 0094 
; 0000 0095 
; 0000 0096 
; 0000 0097 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
;
;
;void SevenSegShowNumber(int SegmentNumber,int dot)
; 0000 009B {
_SevenSegShowNumber:
; .FSTART _SevenSegShowNumber
; 0000 009C 
; 0000 009D     int b= SegmentNumber;
; 0000 009E     if (b==0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	SegmentNumber -> Y+4
;	dot -> Y+2
;	b -> R16,R17
	__GETWRS 16,17,4
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x11
; 0000 009F     {
; 0000 00A0         PORTC=0b00111111;
	LDI  R30,LOW(63)
	RJMP _0x34
; 0000 00A1     }
; 0000 00A2     else if(b==1)
_0x11:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x13
; 0000 00A3     {
; 0000 00A4         PORTC=    0b00000110;
	LDI  R30,LOW(6)
	RJMP _0x34
; 0000 00A5     }
; 0000 00A6     else if(b==2)
_0x13:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x15
; 0000 00A7     {
; 0000 00A8        PORTC=    0b01011011;
	LDI  R30,LOW(91)
	RJMP _0x34
; 0000 00A9     }
; 0000 00AA     else if(b==3)
_0x15:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x17
; 0000 00AB     {
; 0000 00AC         PORTC=   0b01001111;
	LDI  R30,LOW(79)
	RJMP _0x34
; 0000 00AD     }
; 0000 00AE     else if(b==4){
_0x17:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x19
; 0000 00AF         PORTC=   0b01100110;
	LDI  R30,LOW(102)
	RJMP _0x34
; 0000 00B0     }
; 0000 00B1     else if(b==5){
_0x19:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1B
; 0000 00B2          PORTC=  0b01101101;
	LDI  R30,LOW(109)
	RJMP _0x34
; 0000 00B3     }
; 0000 00B4     else if(b==6){
_0x1B:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1D
; 0000 00B5         PORTC=  0b01111101;
	LDI  R30,LOW(125)
	RJMP _0x34
; 0000 00B6     }
; 0000 00B7     else if(b==7){
_0x1D:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1F
; 0000 00B8         PORTC= 0b00000111;
	RJMP _0x34
; 0000 00B9     }
; 0000 00BA     else if(b==8){
_0x1F:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x21
; 0000 00BB          PORTC= 0b01111111;
	LDI  R30,LOW(127)
	RJMP _0x34
; 0000 00BC     }
; 0000 00BD     else
_0x21:
; 0000 00BE      {
; 0000 00BF       PORTC=0b01101111;
	LDI  R30,LOW(111)
_0x34:
	OUT  0x15,R30
; 0000 00C0      }
; 0000 00C1     if (dot==1){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x23
; 0000 00C2         PORTC.7=1;
	SBI  0x15,7
; 0000 00C3     }
; 0000 00C4 
; 0000 00C5 }
_0x23:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND
;
;
;void SevenSegZeroButton_Q6()
; 0000 00C9 {
_SevenSegZeroButton_Q6:
; .FSTART _SevenSegZeroButton_Q6
; 0000 00CA         int h,d,u,dp;
; 0000 00CB     int x,y;
; 0000 00CC     char D4,D5,D6,D7;
; 0000 00CD     char Doff4,Doff5,Doff6,Doff7;
; 0000 00CE 
; 0000 00CF      int i;
; 0000 00D0 
; 0000 00D1     x=PINA;
	SBIW R28,16
	CALL __SAVELOCR6
;	h -> R16,R17
;	d -> R18,R19
;	u -> R20,R21
;	dp -> Y+20
;	x -> Y+18
;	y -> Y+16
;	D4 -> Y+15
;	D5 -> Y+14
;	D6 -> Y+13
;	D7 -> Y+12
;	Doff4 -> Y+11
;	Doff5 -> Y+10
;	Doff6 -> Y+9
;	Doff7 -> Y+8
;	i -> Y+6
	IN   R30,0x19
	LDI  R31,0
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 00D2     y=PINA;
	IN   R30,0x19
	LDI  R31,0
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 00D3 
; 0000 00D4     y=y*10;
	RCALL SUBOPT_0x2
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 00D5     while (y+2){
_0x26:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,2
	BRNE PC+2
	RJMP _0x28
; 0000 00D6     D4=PIND.4;
	LDI  R30,0
	SBIC 0x10,4
	LDI  R30,1
	STD  Y+15,R30
; 0000 00D7     D5=PIND.5;
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	STD  Y+14,R30
; 0000 00D8     D6=PIND.6;
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	STD  Y+13,R30
; 0000 00D9     D7=PIND.7;
	LDI  R30,0
	SBIC 0x10,7
	LDI  R30,1
	STD  Y+12,R30
; 0000 00DA 
; 0000 00DB     for (i=0;i<10;i++) {
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x2A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,10
	BRLT PC+2
	RJMP _0x2B
; 0000 00DC     x=y;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 00DD 
; 0000 00DE     h=x/1000;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RCALL SUBOPT_0x3
; 0000 00DF     x=x-h*1000;
	RCALL SUBOPT_0x9
; 0000 00E0     PORTD=0x0E;
	LDI  R30,LOW(14)
	OUT  0x12,R30
; 0000 00E1     if(!D4){
	LDD  R30,Y+15
	CPI  R30,0
	BRNE _0x2C
; 0000 00E2     SevenSegShowNumber(0,0);
	RCALL SUBOPT_0xA
	RJMP _0x35
; 0000 00E3     }
; 0000 00E4     else{
_0x2C:
; 0000 00E5     SevenSegShowNumber(h,0);
	ST   -Y,R17
	ST   -Y,R16
_0x35:
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _SevenSegShowNumber
; 0000 00E6     }
; 0000 00E7 
; 0000 00E8     delay_ms(5);
	RCALL SUBOPT_0xB
; 0000 00E9     d=x/100;
	RCALL SUBOPT_0x6
; 0000 00EA     x=x-d*100;
	RCALL SUBOPT_0x9
; 0000 00EB     PORTD=0x0D;
	LDI  R30,LOW(13)
	OUT  0x12,R30
; 0000 00EC     if(!D5){
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0x2E
; 0000 00ED     SevenSegShowNumber(0,0);
	RCALL SUBOPT_0xA
	RJMP _0x36
; 0000 00EE     }
; 0000 00EF     else{
_0x2E:
; 0000 00F0     SevenSegShowNumber(d,0);
	ST   -Y,R19
	ST   -Y,R18
_0x36:
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _SevenSegShowNumber
; 0000 00F1     }
; 0000 00F2 
; 0000 00F3     delay_ms(5);
	RCALL SUBOPT_0xB
; 0000 00F4     u=x/10;
	RCALL SUBOPT_0x7
; 0000 00F5     x=x-u*10;
	RCALL SUBOPT_0x9
; 0000 00F6     PORTD=0x0B;
	LDI  R30,LOW(11)
	OUT  0x12,R30
; 0000 00F7     if(!D6){
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x30
; 0000 00F8     SevenSegShowNumber(0,0);
	RCALL SUBOPT_0xA
	LDI  R26,LOW(0)
	RJMP _0x37
; 0000 00F9     }
; 0000 00FA     else{
_0x30:
; 0000 00FB     SevenSegShowNumber(u,1);
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(1)
_0x37:
	LDI  R27,0
	RCALL _SevenSegShowNumber
; 0000 00FC     }
; 0000 00FD 
; 0000 00FE     delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 00FF     dp=x;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 0100     PORTD=0x07;
	LDI  R30,LOW(7)
	OUT  0x12,R30
; 0000 0101     if(!D7){
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x32
; 0000 0102     SevenSegShowNumber(0,0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x38
; 0000 0103     }
; 0000 0104     else{
_0x32:
; 0000 0105     SevenSegShowNumber(dp,0);
	LDD  R30,Y+20
	LDD  R31,Y+20+1
_0x38:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _SevenSegShowNumber
; 0000 0106     }
; 0000 0107 
; 0000 0108     delay_ms(5);}
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2A
_0x2B:
; 0000 0109     y=y-2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,2
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 010A     }
	RJMP _0x26
_0x28:
; 0000 010B }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x0:
	OUT  0x18,R30
	__DELAY_USW 9464
	__DELAY_USW 65535
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	OUT  0x15,R30
	MOVW R26,R16
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R16,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+10,R26
	STD  Y+10+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _SevenSegShowNumber
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R18,R30
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R20,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R27,0
	RCALL _SevenSegShowNumber
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+18,R26
	STD  Y+18+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
