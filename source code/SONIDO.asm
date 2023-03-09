;;en este módulo va todo lo relacionado a sonidos

sonido:

;;	RECIBE:	
;;		BX: Formula: BX = 1,193,180 \ frecuencia deseada
;;		CX: contador para bucles
;;		DX: cantidad de bucles, debe ser por lo menos 1. no cero

	;RETORNA:
;;		NADA

;;parámetros:

;;para SonidoEstrellarse: DX = 3, CX = 0xFFFF, BX = 0xBA6
;;para comerFrutita: DX = 1, CX = 0x FFF, BX = 0xF
;,paramover: DX = 1, CX = 0x800, BX = 0xF6
	
	
	
	

push ax
push bx
push cx
push dx

;;MOV     BX, 0xBA6            ; 
						; A menor valor de BX, mas agudo, y viceversa

MOV     AL, 10110110B   ; Palabra de Control para regular el temporizador.
OUT     43H, AL         ; Mandamos la Palabra de control.

.alargarNota:

	MOV     AX, BX           ; Movemos el valor de la frecuencia a AX.
	
	INC BX ;; aumentamos la frecuencia en 1 para lograr el extraño sonido "de tono descendente"
	
	OUT     42H, AL          ; mandamos el byte menos Significativo al puerto 42h
	MOV     AL, AH           ;movemos el byte MAS signnificativo a AL
	OUT     42H, AL          ;mandamos el byte MAS significativo por el puerto 42h


	IN      AL, 61H          ; conseguimos el valor que se mando al parlante.
	OR      AL, 00000011B    ; ;Forzamos a 1 los dos primeros bits
	OUT     61H, AL          ; Mandamos AL por el puerto 61H (parlante) para encenderlo



	LOOP    .alargarNota       ; hacemos el bucle 0xFFFF veces para prolongar la nota.
		DEC DX ;;con DX haremos que el bucle .alargarNotase repita cuatro veces mas.
		JNZ .alargarNota ;;Hago el JUMP por cuatro veces.

	IN      AL, 61H          ; conseguimos el valor que se mando al parlante.
	AND     AL, 11111100B    ; forzamos los dos bits menos significativos a cero para apagar el parlante.
	OUT     61H, AL          ; apagamos el parlante.
	
	pop dx
	pop cx
	pop bx
	pop ax
	
ret

sonidoMover:

		push dx
		push cx
		push bx
		mov dx, 1
		mov cx, 0x300
		mov bx, 0x300
		call sonido
		pop bx
		pop cx
		pop dx


ret

sonidoFruta:

		push dx				;;generamos el sonido de comer fruta. la explicacion de los parametros esta detallada en la rutina sonido.
		push cx
		push bx
		mov dx, 1h
		mov cx, 0x5000
		mov bx, 0x8000
		call sonido
		pop bx
		pop cx
		pop dx			

ret 

sonidoEstrellarse:
		push dx				;;generamos el sonido de comer fruta. la explicacion de los parametros esta detallada en la rutina sonido.
		push cx
		push bx
	mov dx, 3
	mov cx, 0xFFFF
	mov bx, 0xBA6
	call sonido
	pop bx
		pop cx
		pop dx
		ret
	
	