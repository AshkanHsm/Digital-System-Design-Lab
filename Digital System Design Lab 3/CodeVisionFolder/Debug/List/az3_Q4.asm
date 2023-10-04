
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
;Global 'const' stored in FLASH: Yes
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x20003:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x20028:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
_0x2002C:
	.DB  0x54,0x65,0x6D,0x70,0x3A,0x3F,0x3F,0x28
	.DB  0x32,0x30,0x2D,0x38,0x30,0x43,0x29,0x0
	.DB  0x57,0x3A,0x3F,0x3F,0x28,0x30,0x2D,0x39
	.DB  0x39,0x6B,0x67,0x29,0x0,0x0,0x0,0x0
	.DB  0x54,0x69,0x6D,0x65,0x3A,0x3F,0x3F,0x28
	.DB  0x30,0x2D,0x39,0x39,0x73,0x29,0x0,0x0
	.DB  0x53,0x70,0x65,0x65,0x64,0x3A,0x3F,0x3F
	.DB  0x28,0x30,0x2D,0x35,0x30,0x72,0x29,0x0
_0x20000:
	.DB  0x45,0x6E,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _data_key
	.DW  _0x20003*2

	.DW  0x04
	.DW  _0x2007A
	.DW  _0x20000*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/24/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include <header.h>
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
;#include <mega16.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0021 {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
; 0000 0022 // Place your code here
; 0000 0023     DDRC.0=1;
	SBI  0x14,0
; 0000 0024     PORTC.0=~PORTC.0;
	SBIS 0x15,0
	RJMP _0x5
	CBI  0x15,0
	RJMP _0x6
_0x5:
	SBI  0x15,0
_0x6:
; 0000 0025 
; 0000 0026     //Q4();
; 0000 0027 
; 0000 0028 }
	RETI
; .FEND
;
;void main(void)
; 0000 002B {
_main:
; .FSTART _main
; 0000 002C // Declare your local variables here
; 0000 002D 
; 0000 002E // Input/Output Ports initialization
; 0000 002F // Port A initialization
; 0000 0030 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0031 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0032 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0033 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0034 
; 0000 0035 // Port B initialization
; 0000 0036 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0037 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0038 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0039 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 003A 
; 0000 003B // Port C initialization
; 0000 003C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 003E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0040 
; 0000 0041 // Port D initialization
; 0000 0042 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0043 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0044 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0045 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0046 
; 0000 0047 // External Interrupt(s) initialization
; 0000 0048 // INT0: Off
; 0000 0049 // INT1: On
; 0000 004A // INT1 Mode: Rising Edge
; 0000 004B // INT2: Off
; 0000 004C GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 004D MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0000 004E MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 004F GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0050 
; 0000 0051 // Alphanumeric LCD initialization
; 0000 0052 // Connections are specified in the
; 0000 0053 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0054 // RS - PORTA Bit 0
; 0000 0055 // RD - PORTA Bit 1
; 0000 0056 // EN - PORTA Bit 2
; 0000 0057 // D4 - PORTA Bit 4
; 0000 0058 // D5 - PORTA Bit 5
; 0000 0059 // D6 - PORTA Bit 6
; 0000 005A // D7 - PORTA Bit 7
; 0000 005B // Characters/line: 16
; 0000 005C lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 005D 
; 0000 005E // Global enable interrupts
; 0000 005F #asm("sei")
	sei
; 0000 0060   DDRB=0xf0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0061   PORTB=0xf0;
	OUT  0x18,R30
; 0000 0062   Q5();
	RCALL _Q5
; 0000 0063 while (1)
_0x7:
; 0000 0064       {
; 0000 0065            //Q5();
; 0000 0066       }
	RJMP _0x7
; 0000 0067 }
_0xA:
	RJMP _0xA
; .FEND
;#include <header.h>
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
;char data_key[]={
;    '0','1','2','3',
;    '4','5','6','7',
;    '8','9','A','B',
;    'C','D','E','F'};

	.DSEG
;//////////////////////////////////
;void call_LCD(void)
; 0001 0009 {

	.CSEG
; 0001 000A 
; 0001 000B // Declare your local variables here
; 0001 000C 
; 0001 000D     // Input/Output Ports initialization
; 0001 000E     // Port A initialization
; 0001 000F     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0010     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
; 0001 0011     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0012     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
; 0001 0013 
; 0001 0014     // Port B initialization
; 0001 0015     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0016     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
; 0001 0017     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0018     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
; 0001 0019 
; 0001 001A     // Port C initialization
; 0001 001B     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 001C     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
; 0001 001D     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 001E     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
; 0001 001F 
; 0001 0020     // Port D initialization
; 0001 0021     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0022     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
; 0001 0023     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0024     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
; 0001 0025 
; 0001 0026     // Alphanumeric LCD initialization
; 0001 0027     // Connections are specified in the
; 0001 0028     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0001 0029     // RS - PORTA Bit 0
; 0001 002A     // RD - PORTA Bit 1
; 0001 002B     // EN - PORTA Bit 2
; 0001 002C     // D4 - PORTA Bit 4
; 0001 002D     // D5 - PORTA Bit 5
; 0001 002E     // D6 - PORTA Bit 6
; 0001 002F     // D7 - PORTA Bit 7
; 0001 0030     // Characters/line: 16
; 0001 0031 
; 0001 0032     lcd_init(16);
; 0001 0033 }
;
;///////////////////////////////////
;void Q1(char *last_name,char *std_nu)
; 0001 0037 {
; 0001 0038     lcd_clear();
;	*last_name -> Y+2
;	*std_nu -> Y+0
; 0001 0039     lcd_puts(last_name);
; 0001 003A     lcd_gotoxy(0, 1);
; 0001 003B     lcd_puts(std_nu);
; 0001 003C }
;////////////////////////////////////
;void Q2(char *sentence)
; 0001 003F {
; 0001 0040     int i,j;
; 0001 0041     int length_sentence;
; 0001 0042     for(i=0;sentence[i]!='\0';i++)
;	*sentence -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	length_sentence -> R20,R21
; 0001 0043     {
; 0001 0044         length_sentence=i;
; 0001 0045     }
; 0001 0046     length_sentence++;
; 0001 0047     for(j=15;j>=0;j--)
; 0001 0048     {
; 0001 0049         lcd_gotoxy(j,1);
; 0001 004A         delay_ms(160);
; 0001 004B         for(i=0;i<16-j;i++)
; 0001 004C         {
; 0001 004D             lcd_putchar(sentence[i]);
; 0001 004E         }
; 0001 004F     }
; 0001 0050     for(j=0;j<length_sentence-15;j++){
; 0001 0051         lcd_gotoxy(0,1);
; 0001 0052         delay_ms(160);
; 0001 0053             for(i=j;i<16+j;i++)
; 0001 0054             {
; 0001 0055                 lcd_putchar(sentence[i]);
; 0001 0056             }
; 0001 0057     }
; 0001 0058 }
;///////////////////////////////////
;char Q3(void)
; 0001 005B {
_Q3:
; .FSTART _Q3
; 0001 005C     int r,c;
; 0001 005D     char key=100;
; 0001 005E     char row[]={0x10,0x20,0x40,0x80};
; 0001 005F     for (r=0;r<4;r++)
	SBIW R28,4
	LDI  R30,LOW(16)
	ST   Y,R30
	LDI  R30,LOW(32)
	STD  Y+1,R30
	LDI  R30,LOW(64)
	STD  Y+2,R30
	LDI  R30,LOW(128)
	STD  Y+3,R30
	CALL __SAVELOCR6
;	r -> R16,R17
;	c -> R18,R19
;	key -> R21
;	row -> Y+6
	LDI  R21,100
	__GETWRN 16,17,0
_0x20014:
	__CPWRN 16,17,4
	BRGE _0x20015
; 0001 0060     {
; 0001 0061         PORTB=row[r];
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x18,R30
; 0001 0062         c=20;
	__GETWRN 18,19,20
; 0001 0063         delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0001 0064         if (PINB.0==1) c=0;
	SBIS 0x16,0
	RJMP _0x20016
	__GETWRN 18,19,0
; 0001 0065         if (PINB.1==1) c=1;
_0x20016:
	SBIS 0x16,1
	RJMP _0x20017
	__GETWRN 18,19,1
; 0001 0066         if (PINB.2==1) c=2;
_0x20017:
	SBIS 0x16,2
	RJMP _0x20018
	__GETWRN 18,19,2
; 0001 0067         if (PINB.3==1) c=3;
_0x20018:
	SBIS 0x16,3
	RJMP _0x20019
	__GETWRN 18,19,3
; 0001 0068             if (!(c==20)){
_0x20019:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x2001A
; 0001 0069                 key=(r*4)+c;
	MOV  R30,R16
	LSL  R30
	LSL  R30
	ADD  R30,R18
	MOV  R21,R30
; 0001 006A                 PORTB=0xf0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0001 006B                 while (PINB.0==1) {}
_0x2001B:
	SBIC 0x16,0
	RJMP _0x2001B
; 0001 006C                 while (PINB.1==1) {}
_0x2001E:
	SBIC 0x16,1
	RJMP _0x2001E
; 0001 006D                 while (PINB.2==1) {}
_0x20021:
	SBIC 0x16,2
	RJMP _0x20021
; 0001 006E                 while (PINB.3==1) {}
_0x20024:
	SBIC 0x16,3
	RJMP _0x20024
; 0001 006F             }
; 0001 0070         PORTB=0xf0;
_0x2001A:
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0001 0071         }
	__ADDWRN 16,17,1
	RJMP _0x20014
_0x20015:
; 0001 0072     return data_key[key];
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-_data_key)
	SBCI R31,HIGH(-_data_key)
	LD   R30,Z
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; 0001 0073 }
; .FEND
;///////////////////////////////////
;void Q4(void){
; 0001 0075 void Q4(void){
; 0001 0076     char pinholder=PINB&0x0f;
; 0001 0077     if(pinholder!=0x00)
;	pinholder -> R17
; 0001 0078     {
; 0001 0079         lcd_gotoxy(0,0);
; 0001 007A         lcd_putchar(Q3());
; 0001 007B         delay_ms(200);
; 0001 007C     }
; 0001 007D }
;
;//////////////////////////////////////////
;void printMessage(char * Message) {
; 0001 0080 void printMessage(char * Message) {
_printMessage:
; .FSTART _printMessage
; 0001 0081     char myMessage[16]="               ";
; 0001 0082     char length=strlen(myMessage);
; 0001 0083     char i=0;
; 0001 0084     strcpy(myMessage,Message);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x20028*2)
	LDI  R31,HIGH(_0x20028*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	*Message -> Y+18
;	myMessage -> Y+2
;	length -> R17
;	i -> R16
	MOVW R26,R28
	ADIW R26,2
	CALL _strlen
	MOV  R17,R30
	LDI  R16,0
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL _strcpy
; 0001 0085     lcd_clear();
	CALL SUBOPT_0x0
; 0001 0086     lcd_gotoxy(0,0);
; 0001 0087 	for(i=0; i<length; i++) {
	LDI  R16,LOW(0)
_0x2002A:
	CP   R16,R17
	BRSH _0x2002B
; 0001 0088 		lcd_putchar(myMessage[i]);
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _lcd_putchar
; 0001 0089 	}
	SUBI R16,-1
	RJMP _0x2002A
_0x2002B:
; 0001 008A 
; 0001 008B }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,20
	RET
; .FEND
;void Q5() {
; 0001 008C void Q5() {
_Q5:
; .FSTART _Q5
; 0001 008D 	char InputValue1='x';
; 0001 008E 	char InputValue2='y';
; 0001 008F 	char CorrectValue=0;//True=1  false=0
; 0001 0090 	char Message1[16]="Speed:??(0-50r)";
; 0001 0091 	char Message2[16]="Time:??(0-99s)";
; 0001 0092 	char Message3[16]="W:??(0-99kg)";
; 0001 0093 	char Message4[16]="Temp:??(20-80C)";
; 0001 0094 	char QuestionIndex='1';
; 0001 0095 
; 0001 0096 
; 0001 0097 	for(QuestionIndex='1'; QuestionIndex<='4'; QuestionIndex++) {
	SBIW R28,63
	SBIW R28,1
	LDI  R24,64
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2002C*2)
	LDI  R31,HIGH(_0x2002C*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	InputValue1 -> R17
;	InputValue2 -> R16
;	CorrectValue -> R19
;	Message1 -> Y+52
;	Message2 -> Y+36
;	Message3 -> Y+20
;	Message4 -> Y+4
;	QuestionIndex -> R18
	LDI  R17,120
	LDI  R16,121
	LDI  R19,0
	LDI  R18,49
	LDI  R18,LOW(49)
_0x2002E:
	CPI  R18,53
	BRLO PC+2
	RJMP _0x2002F
; 0001 0098 
; 0001 0099 
; 0001 009A 		if(QuestionIndex=='1') {
	CPI  R18,49
	BREQ PC+2
	RJMP _0x20030
; 0001 009B 			lcd_clear();
	CALL SUBOPT_0x0
; 0001 009C 			lcd_gotoxy(0,0);
; 0001 009D 			printMessage(Message1);
	MOVW R26,R28
	ADIW R26,52
	RCALL _printMessage
; 0001 009E 			delay_ms(1000);
	CALL SUBOPT_0x1
; 0001 009F 
; 0001 00A0 			while(CorrectValue==0) {
_0x20031:
	CPI  R19,0
	BRNE _0x20033
; 0001 00A1 				InputValue1='t';
	LDI  R17,LOW(116)
; 0001 00A2 				InputValue2='t';
	LDI  R16,LOW(116)
; 0001 00A3 				lcd_gotoxy(6,0);
	CALL SUBOPT_0x2
; 0001 00A4 				lcd_putchar('?') ;
	CALL SUBOPT_0x3
; 0001 00A5 				lcd_putchar('?') ;
; 0001 00A6 				delay_ms(600);
; 0001 00A7 
; 0001 00A8 				while(!(InputValue1>='0' & InputValue1<='9')) {
_0x20034:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRNE _0x20036
; 0001 00A9 
; 0001 00AA 
; 0001 00AB 					while((PINB&0x0f)==0x00) {
_0x20037:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x20037
; 0001 00AC 
; 0001 00AD 					}
; 0001 00AE 
; 0001 00AF 
; 0001 00B0 					InputValue1=Q3();
	RCALL _Q3
	MOV  R17,R30
; 0001 00B1 				}
	RJMP _0x20034
_0x20036:
; 0001 00B2 				lcd_gotoxy(6,0);
	CALL SUBOPT_0x2
; 0001 00B3 				lcd_putchar(InputValue1) ;
	MOV  R26,R17
	RCALL _lcd_putchar
; 0001 00B4 
; 0001 00B5 
; 0001 00B6 				while(!(InputValue2>='0' & InputValue2<='9')) {
_0x2003A:
	CALL SUBOPT_0x6
	BRNE _0x2003C
; 0001 00B7 
; 0001 00B8 
; 0001 00B9 					while((PINB&0x0f)==0x00) {
_0x2003D:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x2003D
; 0001 00BA 
; 0001 00BB 					}
; 0001 00BC 
; 0001 00BD 
; 0001 00BE 					InputValue2=Q3();
	RCALL _Q3
	MOV  R16,R30
; 0001 00BF 				}
	RJMP _0x2003A
_0x2003C:
; 0001 00C0 				lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x7
; 0001 00C1 				lcd_putchar(InputValue2) ;
	CALL SUBOPT_0x8
; 0001 00C2 
; 0001 00C3 
; 0001 00C4 				delay_ms(500);
; 0001 00C5 				if(InputValue1>='0'& InputValue1<'5') {
	CALL SUBOPT_0x4
	LDI  R30,LOW(53)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x20040
; 0001 00C6 					if(InputValue2>='0'& InputValue2<='9') {
	CALL SUBOPT_0x6
	BREQ _0x20041
; 0001 00C7 
; 0001 00C8 						CorrectValue=1;
	LDI  R19,LOW(1)
; 0001 00C9 					}
; 0001 00CA 				} else if( InputValue1=='5'& InputValue2=='0') {
_0x20041:
	RJMP _0x20042
_0x20040:
	MOV  R26,R17
	LDI  R30,LOW(53)
	CALL SUBOPT_0x9
	BREQ _0x20043
; 0001 00CB 					CorrectValue=1;
	LDI  R19,LOW(1)
; 0001 00CC 				} else {
	RJMP _0x20044
_0x20043:
; 0001 00CD 					CorrectValue=0;
	LDI  R19,LOW(0)
; 0001 00CE 					lcd_gotoxy(6,0)  ;
	CALL SUBOPT_0x2
; 0001 00CF 					lcd_putchar('E') ;
	CALL SUBOPT_0xA
; 0001 00D0 					lcd_putchar('E') ;
; 0001 00D1 					delay_ms(1000);
; 0001 00D2 
; 0001 00D3 				}
_0x20044:
_0x20042:
; 0001 00D4 
; 0001 00D5 			}
	RJMP _0x20031
_0x20033:
; 0001 00D6 
; 0001 00D7 		}
; 0001 00D8 
; 0001 00D9 		if(QuestionIndex=='2') {
_0x20030:
	CPI  R18,50
	BRNE _0x20045
; 0001 00DA 			CorrectValue=0;
	LDI  R19,LOW(0)
; 0001 00DB 			lcd_clear();
	CALL SUBOPT_0x0
; 0001 00DC 			lcd_gotoxy(0,0);
; 0001 00DD 			printMessage(Message2);
	MOVW R26,R28
	ADIW R26,36
	RCALL _printMessage
; 0001 00DE 
; 0001 00DF 
; 0001 00E0 			while(CorrectValue==0) {
_0x20046:
	CPI  R19,0
	BRNE _0x20048
; 0001 00E1 				InputValue1='t';
	LDI  R17,LOW(116)
; 0001 00E2 				InputValue2='t';
	LDI  R16,LOW(116)
; 0001 00E3 				lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
; 0001 00E4 				lcd_putchar('?') ;
	CALL SUBOPT_0x3
; 0001 00E5 				lcd_putchar('?') ;
; 0001 00E6 				delay_ms(600);
; 0001 00E7 
; 0001 00E8 				while(!(InputValue1>='0' & InputValue1<='9')) {
_0x20049:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRNE _0x2004B
; 0001 00E9 
; 0001 00EA 
; 0001 00EB 					while((PINB&0x0f)==0x00) {
_0x2004C:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x2004C
; 0001 00EC 
; 0001 00ED 					}
; 0001 00EE 
; 0001 00EF 
; 0001 00F0 					InputValue1=Q3();
	RCALL _Q3
	MOV  R17,R30
; 0001 00F1 				}
	RJMP _0x20049
_0x2004B:
; 0001 00F2 				lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
; 0001 00F3 				lcd_putchar(InputValue1) ;
	MOV  R26,R17
	RCALL _lcd_putchar
; 0001 00F4 
; 0001 00F5 
; 0001 00F6 				while(!(InputValue2>='0' & InputValue2<='9')) {
_0x2004F:
	CALL SUBOPT_0x6
	BRNE _0x20051
; 0001 00F7 
; 0001 00F8 
; 0001 00F9 					while((PINB&0x0f)==0x00) {
_0x20052:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x20052
; 0001 00FA 
; 0001 00FB 					}
; 0001 00FC 
; 0001 00FD 					InputValue2=Q3();
	RCALL _Q3
	MOV  R16,R30
; 0001 00FE 				}
	RJMP _0x2004F
_0x20051:
; 0001 00FF 				lcd_gotoxy(6,0);
	CALL SUBOPT_0x2
; 0001 0100 				lcd_putchar(InputValue2) ;
	MOV  R26,R16
	RCALL _lcd_putchar
; 0001 0101 				delay_ms(1000);
	CALL SUBOPT_0x1
; 0001 0102 
; 0001 0103 
; 0001 0104 
; 0001 0105 				CorrectValue=1;
	LDI  R19,LOW(1)
; 0001 0106 			}
	RJMP _0x20046
_0x20048:
; 0001 0107 		}
; 0001 0108 
; 0001 0109 		if(QuestionIndex=='3') {
_0x20045:
	CPI  R18,51
	BRNE _0x20055
; 0001 010A 			CorrectValue=0;
	LDI  R19,LOW(0)
; 0001 010B 			lcd_clear();
	CALL SUBOPT_0x0
; 0001 010C 			lcd_gotoxy(0,0);
; 0001 010D 			printMessage(Message3);
	MOVW R26,R28
	ADIW R26,20
	RCALL _printMessage
; 0001 010E 
; 0001 010F 
; 0001 0110 			while(CorrectValue==0) {
_0x20056:
	CPI  R19,0
	BRNE _0x20058
; 0001 0111 				InputValue1='t';
	LDI  R17,LOW(116)
; 0001 0112 				InputValue2='t';
	LDI  R16,LOW(116)
; 0001 0113 				lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x7
; 0001 0114 				lcd_putchar('?') ;
	CALL SUBOPT_0x3
; 0001 0115 				lcd_putchar('?') ;
; 0001 0116 				delay_ms(600);
; 0001 0117 
; 0001 0118 				while(!(InputValue1>='0' & InputValue1<='9')) {
_0x20059:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRNE _0x2005B
; 0001 0119 
; 0001 011A 
; 0001 011B 					while((PINB&0x0f)==0x00) {
_0x2005C:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x2005C
; 0001 011C 
; 0001 011D 					}
; 0001 011E 
; 0001 011F 
; 0001 0120 					InputValue1=Q3();
	RCALL _Q3
	MOV  R17,R30
; 0001 0121 				}
	RJMP _0x20059
_0x2005B:
; 0001 0122 				lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x7
; 0001 0123 				lcd_putchar(InputValue1) ;
	MOV  R26,R17
	RCALL _lcd_putchar
; 0001 0124 
; 0001 0125 
; 0001 0126 				while(!(InputValue2>='0' & InputValue2<='9')) {
_0x2005F:
	CALL SUBOPT_0x6
	BRNE _0x20061
; 0001 0127 
; 0001 0128 
; 0001 0129 					while((PINB&0x0f)==0x00) {
_0x20062:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x20062
; 0001 012A 
; 0001 012B 					}
; 0001 012C 
; 0001 012D 
; 0001 012E 					InputValue2=Q3();
	RCALL _Q3
	MOV  R16,R30
; 0001 012F 				}
	RJMP _0x2005F
_0x20061:
; 0001 0130 				lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x7
; 0001 0131 				lcd_putchar(InputValue2) ;
	MOV  R26,R16
	RCALL _lcd_putchar
; 0001 0132 				delay_ms(1000);
	CALL SUBOPT_0x1
; 0001 0133 
; 0001 0134 
; 0001 0135 
; 0001 0136 				CorrectValue=1;
	LDI  R19,LOW(1)
; 0001 0137 			}
	RJMP _0x20056
_0x20058:
; 0001 0138 		}
; 0001 0139 
; 0001 013A 
; 0001 013B 		if(QuestionIndex=='4') {
_0x20055:
	CPI  R18,52
	BREQ PC+2
	RJMP _0x20065
; 0001 013C 			CorrectValue=0;
	LDI  R19,LOW(0)
; 0001 013D 			lcd_clear();
	CALL SUBOPT_0x0
; 0001 013E 			lcd_gotoxy(0,0);
; 0001 013F 			printMessage(Message4);
	MOVW R26,R28
	ADIW R26,4
	RCALL _printMessage
; 0001 0140 
; 0001 0141 
; 0001 0142 			while(CorrectValue==0) {
_0x20066:
	CPI  R19,0
	BREQ PC+2
	RJMP _0x20068
; 0001 0143 				InputValue1='t';
	LDI  R17,LOW(116)
; 0001 0144 				InputValue2='t';
	LDI  R16,LOW(116)
; 0001 0145 				lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
; 0001 0146 				lcd_putchar('?') ;
	CALL SUBOPT_0x3
; 0001 0147 				lcd_putchar('?') ;
; 0001 0148 				delay_ms(600);
; 0001 0149 
; 0001 014A 				while(!(InputValue1>='0' & InputValue1<='9')) {
_0x20069:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRNE _0x2006B
; 0001 014B 
; 0001 014C 
; 0001 014D 					while((PINB&0x0f)==0x00) {
_0x2006C:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x2006C
; 0001 014E 
; 0001 014F 					}
; 0001 0150 
; 0001 0151 
; 0001 0152 					InputValue1=Q3();
	RCALL _Q3
	MOV  R17,R30
; 0001 0153 				}
	RJMP _0x20069
_0x2006B:
; 0001 0154 				lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
; 0001 0155 				lcd_putchar(InputValue1) ;
	MOV  R26,R17
	RCALL _lcd_putchar
; 0001 0156 
; 0001 0157 
; 0001 0158 				while(!(InputValue2>='0' & InputValue2<='9')) {
_0x2006F:
	CALL SUBOPT_0x6
	BRNE _0x20071
; 0001 0159 
; 0001 015A 
; 0001 015B 					while((PINB&0x0f)==0x00) {
_0x20072:
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	BREQ _0x20072
; 0001 015C 
; 0001 015D 					}
; 0001 015E 
; 0001 015F 
; 0001 0160 					InputValue2=Q3();
	RCALL _Q3
	MOV  R16,R30
; 0001 0161 				}
	RJMP _0x2006F
_0x20071:
; 0001 0162 				lcd_gotoxy(6,0);
	CALL SUBOPT_0x2
; 0001 0163 				lcd_putchar(InputValue2) ;
	CALL SUBOPT_0x8
; 0001 0164 
; 0001 0165 
; 0001 0166 
; 0001 0167 				delay_ms(500);
; 0001 0168 				if(InputValue1>='2'& InputValue1<='7') {
	MOV  R26,R17
	LDI  R30,LOW(50)
	CALL __GEB12U
	MOV  R0,R30
	LDI  R30,LOW(55)
	CALL __LEB12U
	AND  R30,R0
	BREQ _0x20075
; 0001 0169 					if(InputValue2>='0'& InputValue2<='9') {
	CALL SUBOPT_0x6
	BREQ _0x20076
; 0001 016A 
; 0001 016B 						CorrectValue=1;
	LDI  R19,LOW(1)
; 0001 016C 					}
; 0001 016D 				} else if(InputValue1=='8'& InputValue2=='0') {
_0x20076:
	RJMP _0x20077
_0x20075:
	MOV  R26,R17
	LDI  R30,LOW(56)
	CALL SUBOPT_0x9
	BREQ _0x20078
; 0001 016E 					CorrectValue=1;
	LDI  R19,LOW(1)
; 0001 016F 				} else {
	RJMP _0x20079
_0x20078:
; 0001 0170 					CorrectValue=0;
	LDI  R19,LOW(0)
; 0001 0171 					lcd_gotoxy(5,0)  ;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
; 0001 0172 					lcd_putchar('E') ;
	CALL SUBOPT_0xA
; 0001 0173 					lcd_putchar('E') ;
; 0001 0174 					delay_ms(1000);
; 0001 0175 
; 0001 0176                 }
_0x20079:
_0x20077:
; 0001 0177             }
	RJMP _0x20066
_0x20068:
; 0001 0178         }
; 0001 0179 
; 0001 017A 
; 0001 017B     }
_0x20065:
	SUBI R18,-1
	RJMP _0x2002E
_0x2002F:
; 0001 017C     printMessage("End");
	__POINTW2MN _0x2007A,0
	RCALL _printMessage
; 0001 017D     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0001 017E 
; 0001 017F }
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,5
	RET
; .FEND

	.DSEG
_0x2007A:
	.BYTE 0x4
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xB
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xB
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080001
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND
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

	.CSEG

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND

	.CSEG

	.DSEG
_data_key:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(63)
	CALL _lcd_putchar
	LDI  R26,LOW(63)
	CALL _lcd_putchar
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	MOV  R26,R17
	LDI  R30,LOW(48)
	CALL __GEB12U
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(57)
	CALL __LEB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x6:
	MOV  R26,R16
	LDI  R30,LOW(48)
	CALL __GEB12U
	MOV  R0,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	MOV  R26,R16
	CALL _lcd_putchar
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R16
	LDI  R30,LOW(48)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(69)
	CALL _lcd_putchar
	LDI  R26,LOW(69)
	CALL _lcd_putchar
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LEB12U:
	CP   R30,R26
	LDI  R30,1
	BRSH __LEB12U1
	CLR  R30
__LEB12U1:
	RET

__GEB12U:
	CP   R26,R30
	LDI  R30,1
	BRSH __GEB12U1
	CLR  R30
__GEB12U1:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
