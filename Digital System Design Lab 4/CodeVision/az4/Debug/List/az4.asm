
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
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0x5
_0x5:
	.DB  0x1
_0x20006:
	.DB  0x30,0x30,0x0,0x30,0x30,0x0,0x30,0x30
	.DB  0x0,0x30,0x30,0x0
_0x20000:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x30,0x30,0x3A,0x30,0x30,0x3A,0x30,0x30
	.DB  0x3A,0x30,0x30,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x30,0x25,0x64,0x0,0x25,0x64,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x46
	.DB  0x55,0x4C,0x4C,0x0,0x32,0x2E,0x30,0x34
	.DB  0x38,0x6D,0x73,0x0,0x30,0x2E,0x32,0x35
	.DB  0x36,0x6D,0x73,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _pause
	.DW  _0x3*2

	.DW  0x01
	.DW  _FreeParkingLot
	.DW  _0x4*2

	.DW  0x01
	.DW  _Freq
	.DW  _0x5*2

	.DW  0x10
	.DW  _0x20008
	.DW  _0x20000*2

	.DW  0x11
	.DW  _0x20008+16
	.DW  _0x20000*2+16

	.DW  0x05
	.DW  _0x2001A
	.DW  _0x20000*2+47

	.DW  0x08
	.DW  _0x20024
	.DW  _0x20000*2+52

	.DW  0x08
	.DW  _0x20024+8
	.DW  _0x20000*2+60

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/29/2022
;Author  : Ashkan Hashemi
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
;
;
;#include <HeaderFiles.h>
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
;// Declare your global variables here
;
;int M_Sec=0;
;int Sec=0;    // 1 Sec ==1000 M_Sec
;int Minute=0; //1 Minute==60Sec
;int Hour=0; // 1 Houre=60 minute
;//----------
;//chronometer
;char pause=1;

	.DSEG
;char reset=0;
;char start=0;
;//Car
;int FreeParkingLot=5;
;//Q3
;char Freq=1;
;
;
;
;
;//===========================
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0031 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x0
; 0000 0032 // Place your code here
; 0000 0033   CarIntruptCheck();
	RCALL _CarIntruptCheck
; 0000 0034 }
	RJMP _0xE
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0038 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x0
; 0000 0039 // Place your code here
; 0000 003A chronometerkeycheck_INT1();
	RCALL _chronometerkeycheck_INT1
; 0000 003B }
	RJMP _0xE
; .FEND
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 003F {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	CALL SUBOPT_0x0
; 0000 0040 // Place your code here
; 0000 0041     FrequencySelect_INT2()  ;
	RCALL _FrequencySelect_INT2
; 0000 0042 
; 0000 0043 }
	RJMP _0xE
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0047 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x0
; 0000 0048 // Reinitialize Timer 0 value
; 0000 0049 TCNT0=0xB0;
	LDI  R30,LOW(176)
	OUT  0x32,R30
; 0000 004A // Place your code here
; 0000 004B chronometer_INT();
	RCALL _chronometer_INT
; 0000 004C }
_0xE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 004F {
_main:
; .FSTART _main
; 0000 0050 // Declare your local variables here
; 0000 0051 
; 0000 0052 // Input/Output Ports initialization
; 0000 0053 // Port A initialization
; 0000 0054 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0055 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0056 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0057 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0058 
; 0000 0059 // Port B initialization
; 0000 005A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005B DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 005C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 005D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 005E 
; 0000 005F // Port C initialization
; 0000 0060 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0061 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0062 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0063 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0064 
; 0000 0065 // Port D initialization
; 0000 0066 // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0067 DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 0068 // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0069 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 006A 
; 0000 006B // Timer/Counter 0 initialization
; 0000 006C // Clock source: System Clock
; 0000 006D // Clock value: 7.813 kHz
; 0000 006E // Mode: Normal top=0xFF
; 0000 006F // OC0 output: Disconnected
; 0000 0070 // Timer Period: 9.984 ms
; 0000 0071 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0072 TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 0073 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0074 
; 0000 0075 // Timer/Counter 1 initialization
; 0000 0076 // Clock source: System Clock
; 0000 0077 // Clock value: 1000.000 kHz
; 0000 0078 // Mode: Fast PWM top=0x03FF
; 0000 0079 // OC1A output: Non-Inverted PWM
; 0000 007A // OC1B output: Inverted PWM
; 0000 007B // Noise Canceler: Off
; 0000 007C // Input Capture on Falling Edge
; 0000 007D // Timer Period: 1.024 ms
; 0000 007E // Output Pulse(s):
; 0000 007F // OC1A Period: 1.024 ms Width: 0.25625 ms// OC1B Period: 1.024 ms Width: 0.76775 ms
; 0000 0080 // Timer1 Overflow Interrupt: Off
; 0000 0081 // Input Capture Interrupt: Off
; 0000 0082 // Compare A Match Interrupt: Off
; 0000 0083 // Compare B Match Interrupt: Off
; 0000 0084 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(179)
	OUT  0x2F,R30
; 0000 0085 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 0086 TCNT1H=0xD8;
	LDI  R30,LOW(216)
	OUT  0x2D,R30
; 0000 0087 TCNT1L=0xF0;
	LDI  R30,LOW(240)
	OUT  0x2C,R30
; 0000 0088 ICR1H=0x27;
	LDI  R30,LOW(39)
	OUT  0x27,R30
; 0000 0089 ICR1L=0x0F;
	LDI  R30,LOW(15)
	OUT  0x26,R30
; 0000 008A OCR1AH=0x01;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 008B OCR1AL=0x00;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
; 0000 008C OCR1BH=0x01;
	LDI  R30,LOW(1)
	OUT  0x29,R30
; 0000 008D OCR1BL=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 008E 
; 0000 008F // Timer/Counter 2 initialization
; 0000 0090 // Clock source: System Clock
; 0000 0091 // Clock value: Timer2 Stopped
; 0000 0092 // Mode: Normal top=0xFF
; 0000 0093 // OC2 output: Disconnected
; 0000 0094 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0095 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0096 TCNT2=0xB2;
	LDI  R30,LOW(178)
	OUT  0x24,R30
; 0000 0097 OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 0098 
; 0000 0099 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 009B 
; 0000 009C // External Interrupt(s) initialization
; 0000 009D // INT0: On
; 0000 009E // INT0 Mode: Falling Edge
; 0000 009F // INT1: On
; 0000 00A0 // INT1 Mode: Falling Edge
; 0000 00A1 // INT2: On
; 0000 00A2 // INT2 Mode: Falling Edge
; 0000 00A3 GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 00A4 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 00A5 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00A6 GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 00A7 
; 0000 00A8 // USART initialization
; 0000 00A9 // USART disabled
; 0000 00AA UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00AB 
; 0000 00AC // Analog Comparator initialization
; 0000 00AD // Analog Comparator: Off
; 0000 00AE // The Analog Comparator's positive input is
; 0000 00AF // connected to the AIN0 pin
; 0000 00B0 // The Analog Comparator's negative input is
; 0000 00B1 // connected to the AIN1 pin
; 0000 00B2 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B3 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B4 
; 0000 00B5 // ADC initialization
; 0000 00B6 // ADC disabled
; 0000 00B7 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B8 
; 0000 00B9 // SPI initialization
; 0000 00BA // SPI disabled
; 0000 00BB SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00BC 
; 0000 00BD // TWI initialization
; 0000 00BE // TWI disabled
; 0000 00BF TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00C0 
; 0000 00C1 // Alphanumeric LCD initialization
; 0000 00C2 // Connections are specified in the
; 0000 00C3 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00C4 // RS - PORTC Bit 0
; 0000 00C5 // RD - PORTC Bit 1
; 0000 00C6 // EN - PORTC Bit 2
; 0000 00C7 // D4 - PORTC Bit 4
; 0000 00C8 // D5 - PORTC Bit 5
; 0000 00C9 // D6 - PORTC Bit 6
; 0000 00CA // D7 - PORTC Bit 7
; 0000 00CB // Characters/line: 16
; 0000 00CC lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00CD 
; 0000 00CE // Global enable interrupts
; 0000 00CF #asm("sei")
	sei
; 0000 00D0 
; 0000 00D1 //port setting:
; 0000 00D2 DDRB.4=0;
	CBI  0x17,4
; 0000 00D3 DDRB.5=0;
	CBI  0x17,5
; 0000 00D4 ParkingSpaceShow_LCD()  ;
	RCALL _ParkingSpaceShow_LCD
; 0000 00D5 
; 0000 00D6 TurnOFF_AllTimers();
	RCALL _TurnOFF_AllTimers
; 0000 00D7 while (1)
_0xA:
; 0000 00D8       {
; 0000 00D9       // Place your code here
; 0000 00DA 
; 0000 00DB       }
	RJMP _0xA
; 0000 00DC }
_0xD:
	RJMP _0xD
; .FEND
;//q1 Student name and ID in 2 lines
;//q2 "Welcome to the Microprocessor lab classes in Isfahan University of Technology"
;#include <HeaderFiles.h>
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
;//***----Q1----*** Timer_Watch
;void chronometerkeycheck_INT1(){
; 0001 0006 void chronometerkeycheck_INT1(){

	.CSEG
_chronometerkeycheck_INT1:
; .FSTART _chronometerkeycheck_INT1
; 0001 0007 
; 0001 0008     TurnOFF_AllTimers();
	RCALL _TurnOFF_AllTimers
; 0001 0009     TurnOn_SelectedTimer(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _TurnOn_SelectedTimer
; 0001 000A     //check pinb4(start) and 5 (stop)
; 0001 000B     if(PINB.4==0)
	SBIC 0x16,4
	RJMP _0x20003
; 0001 000C     {
; 0001 000D         //start
; 0001 000E         pause=0;
	LDI  R30,LOW(0)
	STS  _pause,R30
; 0001 000F         reset=0;
	STS  _reset,R30
; 0001 0010         start=1;
	LDI  R30,LOW(1)
	STS  _start,R30
; 0001 0011 
; 0001 0012 
; 0001 0013     }
; 0001 0014     if(PINB.5==0){
_0x20003:
	SBIC 0x16,5
	RJMP _0x20004
; 0001 0015         //stop
; 0001 0016         reset=0;
	LDI  R30,LOW(0)
	STS  _reset,R30
; 0001 0017         if(pause==1){
	LDS  R26,_pause
	CPI  R26,LOW(0x1)
	BRNE _0x20005
; 0001 0018          reset=1;
	LDI  R30,LOW(1)
	STS  _reset,R30
; 0001 0019         }
; 0001 001A         pause=1;
_0x20005:
	CALL SUBOPT_0x1
; 0001 001B         start=0;
; 0001 001C     }
; 0001 001D 
; 0001 001E 
; 0001 001F }
_0x20004:
	RET
; .FEND
;
;void chronometer_INT(){
; 0001 0021 void chronometer_INT(){
_chronometer_INT:
; .FSTART _chronometer_INT
; 0001 0022 
; 0001 0023     char hour[3]="00";
; 0001 0024     char min[3]="00";
; 0001 0025     char sec[3]="00";
; 0001 0026     char mSec[3]="00";
; 0001 0027     // Reinitialize Timer1 value
; 0001 0028     TCNT1H=0xD8F0 >> 8;
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x20006*2)
	LDI  R31,HIGH(_0x20006*2)
	CALL __INITLOCB
;	hour -> Y+9
;	min -> Y+6
;	sec -> Y+3
;	mSec -> Y+0
	LDI  R30,LOW(216)
	OUT  0x2D,R30
; 0001 0029     TCNT1L=0xD8F0 & 0xff;
	LDI  R30,LOW(240)
	OUT  0x2C,R30
; 0001 002A     // Place your code here
; 0001 002B 
; 0001 002C     //shomaresh
; 0001 002D     if(reset ==1){
	LDS  R26,_reset
	CPI  R26,LOW(0x1)
	BRNE _0x20007
; 0001 002E      M_Sec=0;
	LDI  R30,LOW(0)
	STS  _M_Sec,R30
	STS  _M_Sec+1,R30
; 0001 002F      Sec=0;
	STS  _Sec,R30
	STS  _Sec+1,R30
; 0001 0030      Minute=0;
	STS  _Minute,R30
	STS  _Minute+1,R30
; 0001 0031      Hour=0;
	STS  _Hour,R30
	STS  _Hour+1,R30
; 0001 0032      lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
; 0001 0033      lcd_puts("               ");
	__POINTW2MN _0x20008,0
	CALL _lcd_puts
; 0001 0034       lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
; 0001 0035      lcd_puts("00:00:00:00     ");
	__POINTW2MN _0x20008,16
	CALL _lcd_puts
; 0001 0036 
; 0001 0037     }
; 0001 0038     if(start==1){
_0x20007:
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x20009
; 0001 0039 
; 0001 003A 
; 0001 003B         M_Sec+=1;// 10
	LDS  R30,_M_Sec
	LDS  R31,_M_Sec+1
	ADIW R30,1
	STS  _M_Sec,R30
	STS  _M_Sec+1,R31
; 0001 003C 
; 0001 003D         if(M_Sec==100){
	LDS  R26,_M_Sec
	LDS  R27,_M_Sec+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRNE _0x2000A
; 0001 003E             M_Sec=0;
	LDI  R30,LOW(0)
	STS  _M_Sec,R30
	STS  _M_Sec+1,R30
; 0001 003F             Sec+=1;
	LDS  R30,_Sec
	LDS  R31,_Sec+1
	ADIW R30,1
	STS  _Sec,R30
	STS  _Sec+1,R31
; 0001 0040             if(Sec==60){
	LDS  R26,_Sec
	LDS  R27,_Sec+1
	SBIW R26,60
	BRNE _0x2000B
; 0001 0041                 Sec=0;
	LDI  R30,LOW(0)
	STS  _Sec,R30
	STS  _Sec+1,R30
; 0001 0042                 Minute+=1;
	LDS  R30,_Minute
	LDS  R31,_Minute+1
	ADIW R30,1
	STS  _Minute,R30
	STS  _Minute+1,R31
; 0001 0043                 if(Minute==60){
	LDS  R26,_Minute
	LDS  R27,_Minute+1
	SBIW R26,60
	BRNE _0x2000C
; 0001 0044                   Minute=0;
	LDI  R30,LOW(0)
	STS  _Minute,R30
	STS  _Minute+1,R30
; 0001 0045                   Hour+=1;
	LDS  R30,_Hour
	LDS  R31,_Hour+1
	ADIW R30,1
	STS  _Hour,R30
	STS  _Hour+1,R31
; 0001 0046                 }
; 0001 0047             }
_0x2000C:
; 0001 0048         }
_0x2000B:
; 0001 0049         // tabdil be String
; 0001 004A         if(M_Sec<10){
_0x2000A:
	LDS  R26,_M_Sec
	LDS  R27,_M_Sec+1
	SBIW R26,10
	BRGE _0x2000D
; 0001 004B              sprintf(mSec,"0%d",M_Sec);
	CALL SUBOPT_0x3
	__POINTW1FN _0x20000,33
	RJMP _0x20026
; 0001 004C         }
; 0001 004D         else{
_0x2000D:
; 0001 004E             sprintf(mSec,"%d",M_Sec);
	CALL SUBOPT_0x3
	__POINTW1FN _0x20000,34
_0x20026:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_M_Sec
	LDS  R31,_M_Sec+1
	CALL SUBOPT_0x4
; 0001 004F         }
; 0001 0050         if(Sec<10){
	LDS  R26,_Sec
	LDS  R27,_Sec+1
	SBIW R26,10
	BRGE _0x2000F
; 0001 0051             sprintf(sec,"0%d",Sec);
	MOVW R30,R28
	ADIW R30,3
	CALL SUBOPT_0x5
	RJMP _0x20027
; 0001 0052         }
; 0001 0053         else{
_0x2000F:
; 0001 0054             sprintf(sec,"%d",Sec);
	MOVW R30,R28
	ADIW R30,3
	CALL SUBOPT_0x6
_0x20027:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Sec
	LDS  R31,_Sec+1
	CALL SUBOPT_0x4
; 0001 0055         }
; 0001 0056         if(Minute<10){
	LDS  R26,_Minute
	LDS  R27,_Minute+1
	SBIW R26,10
	BRGE _0x20011
; 0001 0057             sprintf(min,"0%d",Minute);
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x5
	RJMP _0x20028
; 0001 0058         }
; 0001 0059         else{
_0x20011:
; 0001 005A             sprintf(min,"%d",Minute);
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x6
_0x20028:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Minute
	LDS  R31,_Minute+1
	CALL SUBOPT_0x4
; 0001 005B         }
; 0001 005C         if(Hour<10){
	LDS  R26,_Hour
	LDS  R27,_Hour+1
	SBIW R26,10
	BRGE _0x20013
; 0001 005D             sprintf(hour,"0%d",Hour);
	MOVW R30,R28
	ADIW R30,9
	CALL SUBOPT_0x5
	RJMP _0x20029
; 0001 005E         }
; 0001 005F         else{
_0x20013:
; 0001 0060             sprintf(hour,"%d",Hour);
	MOVW R30,R28
	ADIW R30,9
	CALL SUBOPT_0x6
_0x20029:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Hour
	LDS  R31,_Hour+1
	CALL SUBOPT_0x4
; 0001 0061         }
; 0001 0062          lcd_gotoxy(0,0);
	CALL SUBOPT_0x2
; 0001 0063 
; 0001 0064          lcd_putchar(hour[0]);
	LDD  R26,Y+9
	CALL _lcd_putchar
; 0001 0065          lcd_putchar(hour[1]);
	LDD  R26,Y+10
	CALL SUBOPT_0x7
; 0001 0066          lcd_putchar(':');
; 0001 0067          lcd_putchar(min[0]) ;
	LDD  R26,Y+6
	CALL _lcd_putchar
; 0001 0068          lcd_putchar(min[1]) ;
	LDD  R26,Y+7
	CALL SUBOPT_0x7
; 0001 0069          lcd_putchar(':');
; 0001 006A          lcd_putchar(sec[0])  ;
	LDD  R26,Y+3
	CALL _lcd_putchar
; 0001 006B          lcd_putchar(sec[1])  ;
	LDD  R26,Y+4
	CALL SUBOPT_0x7
; 0001 006C          lcd_putchar(':');
; 0001 006D          lcd_putchar(mSec[0])  ;
	LD   R26,Y
	CALL _lcd_putchar
; 0001 006E          lcd_putchar(mSec[1])  ;
	LDD  R26,Y+1
	CALL _lcd_putchar
; 0001 006F 
; 0001 0070     }
; 0001 0071 }
_0x20009:
	ADIW R28,12
	RET
; .FEND

	.DSEG
_0x20008:
	.BYTE 0x21
;
;//***----End_Q1----***
;//=============================================================
;//***----Q2----*** Car
;void CarIntruptCheck(){
; 0001 0076 void CarIntruptCheck(){

	.CSEG
_CarIntruptCheck:
; .FSTART _CarIntruptCheck
; 0001 0077 
; 0001 0078 
; 0001 0079     if(PINB.7==0)
	SBIC 0x16,7
	RJMP _0x20015
; 0001 007A     {
; 0001 007B         //in
; 0001 007C         if(FreeParkingLot>=1){
	LDS  R26,_FreeParkingLot
	LDS  R27,_FreeParkingLot+1
	SBIW R26,1
	BRLT _0x20016
; 0001 007D           FreeParkingLot-=1;
	CALL SUBOPT_0x8
	SBIW R30,1
	STS  _FreeParkingLot,R30
	STS  _FreeParkingLot+1,R31
; 0001 007E         }
; 0001 007F 
; 0001 0080     }
_0x20016:
; 0001 0081     if(PINB.3==0){
_0x20015:
	SBIC 0x16,3
	RJMP _0x20017
; 0001 0082         //out
; 0001 0083         if(FreeParkingLot<=999){
	LDS  R26,_FreeParkingLot
	LDS  R27,_FreeParkingLot+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRGE _0x20018
; 0001 0084           FreeParkingLot+=1;
	CALL SUBOPT_0x8
	ADIW R30,1
	STS  _FreeParkingLot,R30
	STS  _FreeParkingLot+1,R31
; 0001 0085         }
; 0001 0086 
; 0001 0087     }
_0x20018:
; 0001 0088     ParkingSpaceShow_LCD()  ;
_0x20017:
	RCALL _ParkingSpaceShow_LCD
; 0001 0089 }
	RET
; .FEND
;
;void ParkingSpaceShow_LCD(){
; 0001 008B void ParkingSpaceShow_LCD(){
_ParkingSpaceShow_LCD:
; .FSTART _ParkingSpaceShow_LCD
; 0001 008C     char STRING_FreeCarSpaceCount[6]="     ";
; 0001 008D     sprintf(STRING_FreeCarSpaceCount,"%d       ",FreeParkingLot)    ;
	SBIW R28,6
	LDI  R30,LOW(32)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	LDI  R30,LOW(0)
	STD  Y+5,R30
;	STRING_FreeCarSpaceCount -> Y+0
	CALL SUBOPT_0x3
	__POINTW1FN _0x20000,37
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x4
; 0001 008E     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0001 008F     if( FreeParkingLot==0){
	CALL SUBOPT_0x8
	SBIW R30,0
	BRNE _0x20019
; 0001 0090         lcd_puts("FULL");
	__POINTW2MN _0x2001A,0
	RJMP _0x2002A
; 0001 0091     }
; 0001 0092     else
_0x20019:
; 0001 0093         lcd_puts(STRING_FreeCarSpaceCount);
	MOVW R26,R28
_0x2002A:
	CALL _lcd_puts
; 0001 0094 }
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0x2001A:
	.BYTE 0x5
;
;//***----End_Q2----***
;// ==========================================================
;//***----Q3 ------****
;
;void TurnOFF_AllTimers(){
; 0001 009A void TurnOFF_AllTimers(){

	.CSEG
_TurnOFF_AllTimers:
; .FSTART _TurnOFF_AllTimers
; 0001 009B     TCCR0 = (0<<CS02)| (0<<CS01)| (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0001 009C     TCCR1B = (0<<CS12)| (0<<CS11)| (0<<CS10);
	OUT  0x2E,R30
; 0001 009D     TCCR2 = (0<<CS22)| (0<<CS21)| (0<<CS20);
	OUT  0x25,R30
; 0001 009E 
; 0001 009F 
; 0001 00A0 }
	RET
; .FEND
;//Only select Timer 1 or 0
;void TurnOn_SelectedTimer(int SelectedTimer ){
; 0001 00A2 void TurnOn_SelectedTimer(int SelectedTimer ){
_TurnOn_SelectedTimer:
; .FSTART _TurnOn_SelectedTimer
; 0001 00A3 
; 0001 00A4 
; 0001 00A5 
; 0001 00A6     if(SelectedTimer==0){
	ST   -Y,R27
	ST   -Y,R26
;	SelectedTimer -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x2001C
; 0001 00A7       TCCR0 = (1<<CS02)| (0<<CS01)| (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0001 00A8     }
; 0001 00A9     else if(SelectedTimer==1){
	RJMP _0x2001D
_0x2001C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x2001E
; 0001 00AA         if(Freq==8){
	LDS  R26,_Freq
	CPI  R26,LOW(0x8)
	BRNE _0x2001F
; 0001 00AB             TCCR1B =  (0<<CS12)| (1<<CS11)| (0<<CS10); //8MHz  -> Period = 0.256 ms
	LDI  R30,LOW(2)
	RJMP _0x2002B
; 0001 00AC         }
; 0001 00AD         else
_0x2001F:
; 0001 00AE             TCCR1B =  (0<<CS12)| (0<<CS11)| (1<<CS10); //1Mhz  -> Period = 2.048 ms
	LDI  R30,LOW(1)
_0x2002B:
	OUT  0x2E,R30
; 0001 00AF     }
; 0001 00B0 }
_0x2001E:
_0x2001D:
	JMP  _0x2080002
; .FEND
;
;void FrequencySelect_INT2(){
; 0001 00B2 void FrequencySelect_INT2(){
_FrequencySelect_INT2:
; .FSTART _FrequencySelect_INT2
; 0001 00B3     //change Frequency
; 0001 00B4     if(Freq==1){
	LDS  R26,_Freq
	CPI  R26,LOW(0x1)
	BRNE _0x20021
; 0001 00B5         Freq=8;
	LDI  R30,LOW(8)
	RJMP _0x2002C
; 0001 00B6     }
; 0001 00B7     else{
_0x20021:
; 0001 00B8         Freq=1 ;
	LDI  R30,LOW(1)
_0x2002C:
	STS  _Freq,R30
; 0001 00B9     }
; 0001 00BA    // timer pause:
; 0001 00BB     reset=0;
	LDI  R30,LOW(0)
	STS  _reset,R30
; 0001 00BC 
; 0001 00BD     pause=1;
	CALL SUBOPT_0x1
; 0001 00BE     start=0;
; 0001 00BF     //Timers Status
; 0001 00C0     TurnOFF_AllTimers();
	RCALL _TurnOFF_AllTimers
; 0001 00C1     TurnOn_SelectedTimer(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _TurnOn_SelectedTimer
; 0001 00C2     PeriodDisplay();
	RCALL _PeriodDisplay
; 0001 00C3 
; 0001 00C4 
; 0001 00C5 }
	RET
; .FEND
;void PeriodDisplay()
; 0001 00C7 {
_PeriodDisplay:
; .FSTART _PeriodDisplay
; 0001 00C8     lcd_gotoxy(8,1) ;
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0001 00C9     if(  Freq==8){
	LDS  R26,_Freq
	CPI  R26,LOW(0x8)
	BRNE _0x20023
; 0001 00CA         lcd_puts("2.048ms");
	__POINTW2MN _0x20024,0
	RJMP _0x2002D
; 0001 00CB     }
; 0001 00CC     else
_0x20023:
; 0001 00CD       lcd_puts("0.256ms");
	__POINTW2MN _0x20024,8
_0x2002D:
	CALL _lcd_puts
; 0001 00CE 
; 0001 00CF }
	RET
; .FEND

	.DSEG
_0x20024:
	.BYTE 0x10
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
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x9
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x9
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0xA
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xB
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x9
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xB
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xE
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xE
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
_0x2080002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xF
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xF
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
	BREQ _0x2020005
	CP   R5,R7
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x2080001
_0x2020007:
_0x2020004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
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

	.CSEG
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
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
_FreeParkingLot:
	.BYTE 0x2
_M_Sec:
	.BYTE 0x2
_Sec:
	.BYTE 0x2
_Minute:
	.BYTE 0x2
_Hour:
	.BYTE 0x2
_pause:
	.BYTE 0x1
_reset:
	.BYTE 0x1
_start:
	.BYTE 0x1
_Freq:
	.BYTE 0x1
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	STS  _pause,R30
	LDI  R30,LOW(0)
	STS  _start,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,33
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	CALL _lcd_putchar
	LDI  R26,LOW(58)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R30,_FreeParkingLot
	LDS  R31,_FreeParkingLot+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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
