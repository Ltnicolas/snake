Pintar:
mov cx, origen 	;;Esto para recorrer
.PintarEnPantalla:


	mov bx, cx
	mov dl, [BX] 	;;esto nos retorna el tipo de color para la siguiente linea
	call deMemACo
	
	push cx
	push dx
		mov ch, 0
		mov dh, 0
		mov cl, al
		mov dl, ah
	pop ax			;; en realidad popeamos DX, es una manera inteligente de pasar el valor
	
	call dibuCuad
	
	pop cx
	inc cx
	cmp cx, final
JNZ .PintarEnPantalla
ret 



Pinfruta:

Push Cx
Push Bx

call random
	mov Bx, Cx
	mov [BX], byte 3d
	call deMemACo
	
	mov dh, 0
	mov ch, 0
	mov dl, ah
	mov cl, al
	mov al, [Bx]
	
call dibuCuad
	
Pop Bx
Pop Cx


ret



pinCuer:
;;pintocuerpo:

mov bx, 4200h
pinto:
	mov cl, [bx]
	inc bx
	mov ch, [bx]
	push cx
	push bx
	push cx
	call deMemACo
	mov dh, 0
	mov dl, ah
	mov ch, 0
	mov cl, al
	pop bx
	mov al, [bx]
	call dibuCuad
	pop bx
	pop cx
	inc bx 				;;incrementamos porque queremos preguntar la parte alta del numero guardado. ej: 40FF. nos interesa la parte FF, que sabemos que solo sera			;; cero cuando no haya ninguna parte de la viborita guardada.
	cmp [bx+1], byte 0
	JNZ pinto
	
ret 


dibuCuad:
;;DibujarCuadradito:
;;ecibiendo una ubicacion en AH y AL y el tipo de objeto AL, te pinte un cuadrado de 8*8. 
;se puede cambiar el tamaño de los cuadraditos, no drama.
;;el loco ya recibe las coordenadas prontas en CX y DX

;;NO RETORNA NADA!!!! esta subRutina pinta en pantalla y no hace nada mas
	
	
	
	PUSH CX ;;mirar abajo:
	PUSH DX ;; para lo unico que sirve esto es para devolverte CX y DX una vez haya terminado TODA esta subrutina
	PUSH BX
	
	
	
	
	  ; INT 10h / AH = 0Ch - cambiar color de un pixel. Sus parámetros:
;   AL = color
;   CX = columna ;;no es idea nuestra, la interrupcion trabaja asi...
;   DX = fila

	;;BH y BL son para guardar las filas y columnas iniciales (las que se pasaron por parametro), pues vamos a modificar CX y DX en el bucle que hay mas adelante
	
	
	mov bh, 0 ;;
	mov bl, 0 ;; esto  es para el 'for'
	
	;;a continuacion vamos a hacer tres SHIFT-LEFT para multiplicar por 8.
		;;esto es porque pasamos a trabajar con las coordenadas DE LA PANTALLA.
	shl dx, 3
	
	shl Cx, 3
	

	dec dx
	
	
bucleConDx: ;;esto es FILA
	inc dx
	bucleConCx:;;esto es columna
	
	mov ah, 0ch
	int 10h ;Cambiar color de un pixel en pantalla
	
	inc cx
	inc bh
	cmp bh, 8
	JNZ bucleConCx
	
	mov bh, 0
	Sub Cx, 8
	
	inc bl
	cmp bl, 8
	JNZ bucleConDx
	
	POP Bx
	pop Dx
	pop CX

	
	ret 
	
	
	iniciarModoGrafico: 
		MOV ah, 0		;;ejecuta el modo video 13h: 320x200x256 colores
		MOV al, 13h
		INT 10h 		
	ret 