	;	Foot Sensor Assy Test Program
	;		Written by Shion Watanabe
	;			Approved by Toshiyuki Takeda
	;				Siska Tech Lab. - 2012/01/04

	LIST	P=PIC16F887
	INCLUDE	"P16F887.INC"

TEMP		EQU		020h
CHTEMP		EQU		021h
CHCOUNTER	EQU		022h
ADBUFFER	EQU		023h
MaxChRow	EQU		B'00110001' ; 50ch
MaxChCol	EQU		B'00001110' ; 14ch

	; Initialize...
	ORG		0

	; Set Buffer Pointer Address
	MOVLW	ADBUFFER
	MOVWF	FSR

	; Switch to Bank 3
	BSF		STATUS, RP0
	BSF		STATUS, RP1

	; Set all ADCs to active
	MOVLW	B'11111111'
	MOVWF	ANSEL
	MOVWF	ANSELH

	; Switch to Bank 1
	BCF		STATUS, RP1

	; Set AD Converter to Right Justified
	MOVLW	B'10000000'
	MOVWF	ADCON1

	; Set Digital output is disable
	MOVLW	B'11111111'
	MOVWF	TRISA
	MOVWF	TRISB
	MOVWF	TRISE

	; Set Digital output is enable
	MOVLW	B'10000000'
	MOVWF	TRISC
	MOVLW	B'00000000'
	MOVWF	TRISD

	; Settings up to Serial Communications
	; This program will drived at 20MHz clock speed
	; and baud rate is high speed (19200bps)
	;MOVLW	B'00100000'
	; ...or you can choose very high speed (115200bps)
	MOVLW	B'00100100'
	MOVWF	TXSTA

	; Set baud rate is 19200bps
	; MOVLW	D'15'
	; Set baud rate is 115200bps
	MOVLW	D'10'
	MOVWF	SPBRG

	; Switch to Bank 0
	BCF		STATUS, RP0

	MOVLW	B'10010000'
	MOVWF	RCSTA

	; Clear All Ports
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTC
	CLRF	PORTD
	CLRF	PORTE

SRHIGH

	; Input High to Shift Register
	MOVLW	b'00010010'
	MOVWF	PORTD

	MOVLW	MaxChRow
	MOVWF	TEMP

LOOP

	; Sending Clock
	MOVLW	b'00010001'
	MOVWF	PORTD

	MOVLW	b'00000000'
	MOVWF	PORTD

	; Channel Select Initialize
	MOVLW	B'10000001'
	MOVWF	CHTEMP

	MOVLW	MaxChCol
	MOVWF	CHCOUNTER

AD_CONVERTION
	; Set AD Convertion Channel
	MOVF	CHTEMP,W
	MOVWF	ADCON0

	; Select Next Channel
	ADDLW	B'100'
	MOVWF	CHTEMP

	; Start AD convertion
	BSF	ADCON0,GO

	; Waiting AD Result
AD_WAIT
	BTFSC	ADCON0,GO
	GOTO	AD_WAIT

	CLRF	INDF
	INCF	FSR,F
	CLRF	INDF
	INCF	FSR,F
	CLRF	INDF
	INCF	FSR,F
	CLRF	INDF
	INCF	FSR,F
	CLRF	INDF
	DECF	FSR,F

	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,0
	MOVLW	d'1'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,1
	MOVLW	d'2'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,2
	MOVLW	d'4'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,3
	MOVLW	d'8'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	DECF	FSR,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,4
	MOVLW	d'1'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	INCF	FSR,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,4
	MOVLW	d'6'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,5
	MOVLW	d'2'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	DECF	FSR,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,5
	MOVLW	d'3'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,6
	MOVLW	d'6'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	INCF	FSR,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,6
	MOVLW	d'4'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,7
	MOVLW	d'8'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	DECF	FSR,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,7
	MOVLW	d'2'

	BCF	STATUS,RP0
	ADDWF	INDF,F
	DECF	FSR,F
	BSF	STATUS,RP0

	CLRW
	BTFSC	ADRESL,7
	MOVLW	d'1'

	BCF	STATUS,RP0
	ADDWF	INDF,F

	CLRW
	BTFSC	ADRESH,0
	MOVLW	d'2'

	ADDWF	INDF,F
	INCF	FSR,F

	CLRW
	BTFSC	ADRESH,0
	MOVLW	d'5'

	ADDWF	INDF,F
	INCF	FSR,F

	CLRW
	BTFSC	ADRESH,0
	MOVLW	d'6'

	ADDWF	INDF,F

	CLRW
	BTFSC	ADRESH,0
	MOVLW	d'2'

	ADDWF	INDF,F
	DECF	FSR,F

	CLRW
	BTFSC	ADRESH,0
	MOVLW	d'1'

	ADDWF	INDF,F
	DECF	FSR,F

	CLRW
	BTFSC	ADRESH,0
	MOVLW	d'5'

	ADDWF	INDF,F

;--------------------------------------------------------------------------------

	MOVLW	d'10'
	INCF	FSR,F

First
	INCF	FSR,F
	SUBWF	INDF,F
	DECF	FSR,F
	INCF	INDF,F
	BTFSC	STATUS,C
	GOTO	First

	DECF	INDF,F
	INCF	FSR,F
	ADDWF	INDF,F
	DECF	FSR,F

Second
	INCF	FSR,F
	SUBWF	INDF,F
	DECF	FSR,F
	INCF	INDF,F
	BTFSC	STATUS,C
	GOTO	Second

	DECF	INDF,F
	INCF	FSR,F
	ADDWF	INDF,F
	DECF	FSR,F

	DECF	FSR,F

Third
	INCF	FSR,F
	SUBWF	INDF,F
	DECF	FSR,F
	INCF	INDF,F
	BTFSC	STATUS,C
	GOTO	Third

	DECF	INDF,F
	INCF	FSR,F
	ADDWF	INDF,F
	DECF	FSR,F

	DECF	FSR,F

Fourth
	INCF	FSR,F
	SUBWF	INDF,F
	DECF	FSR,F
	INCF	INDF,F
	BTFSC	STATUS,C
	GOTO	Fourth

	DECF	INDF,F
	INCF	FSR,F
	ADDWF	INDF,F
	DECF	FSR,F

	MOVLW	b'00110000'
	ADDWF	INDF,F

	INCF	FSR,F
	ADDWF	INDF,F

	INCF	FSR,F
	ADDWF	INDF,F

	INCF	FSR,F
	ADDWF	INDF,F

	INCF	FSR,F

	MOVLW	02Ch	; ','
	MOVWF	INDF

	INCF	FSR,F

	; Switch to Bank 1 & Copy Result Lower Bytes
	;BSF	STATUS, RP0
	;MOVF	ADRESL,W

	; Switch to Bank 0 & Copy Result to Buffer
	;BCF	STATUS, RP0
	;MOVWF	INDF

	; Increment Indirect Address Pointer
	;INCF	FSR,F

	; Copy Result Upper Bytes to Buffer
	;MOVF	ADRESH,W
	;MOVWF	INDF

	; Increment Indirect Address Pointer
	;INCF	FSR,F

	; Dec AD Channel Counting
	DECFSZ	CHCOUNTER
	GOTO AD_CONVERTION

	DECF	FSR,F
	MOVLW	040h	; '@'
	MOVWF	INDF

	; Reset Pointer
	MOVLW	ADBUFFER
	MOVWF	FSR

	; Reset Sending Data Counter
	MOVLW	MaxChCol
	ADDLW	MaxChCol
	ADDLW	MaxChCol
	ADDLW	MaxChCol
	ADDLW	MaxChCol
	MOVWF	CHCOUNTER

SEND_BLOCK
	; Switch to Bank 1
	BSF		STATUS,RP0

SEND_WAIT
	; Check Ready
	BTFSS	TXSTA,TRMT
	GOTO	SEND_WAIT

	; Switch to Bank 0
	BCF		STATUS,RP0

	; Get AD Result Data & Sending
	MOVF	INDF,W
	MOVWF	TXREG

	; In step to next pointer
	INCF	FSR,F
	DECFSZ	CHCOUNTER
	GOTO SEND_BLOCK

	; Reset Pointer
	MOVLW	ADBUFFER
	MOVWF	FSR

	; Dec Counter
	DECFSZ  TEMP,F

.	GOTO LOOP
	GOTO SRHIGH

	END