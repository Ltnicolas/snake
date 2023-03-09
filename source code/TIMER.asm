obtenerTicks:
	;RECIBE: NADA
	;RETORNA:   CX:  parte alta del contador

	push ax
	push bx
	push dx
	
	mov ah, 00h
	int 1ah ;;llama a la interrupcion 1A, con servicio 00h: LEER RELOJ DE SISTEMA: DX,CX : contador en 32 bits. AL = 0 si pasaron 24 horas, sino es 1
	mov cx, dx
	
	pop dx
	pop bx
	pop ax
ret 
	
PreguntoSiPuedoMover:
	push ax
	push cx

		call obtenerTicks
		mov ax, cx ;;cargo los tics en AX
		.polleoTics:
			call obtenerTicks
			
			sub cx, 5
			cmp cx, ax
		js .polleoTics ;;SIGN FLAG es 1 <---> negativo

		add cx, 5

		pop cx
		pop ax
ret



random: ;;esta subRutina te genera un numero pseudo-Aleatorio a partir del reloj de sistema.
		;;Además garantiza que dicha posicion sea válida (o sea, en un espacio blanco)
		
		;; REQUIERE: nada
		;; RETORNA: CX: posicion de memoria donde se puede colocar frutita
		

	push bx
	push dx
pidoNum:

	mov ah, 2ch
	int 21h ;;esta interrupcion te da la hora de sistema. Usaremos los segundos para hacer un generador de numero (pseudo)-Aleatorio
		    ;;ch: horas, cl, minutos, dh, segundos, dl, centesimas
	
	mov al, dl ;;lo paso a Al para poder Multiplicar
	
	;;Como queremos un numero entre 0 y 500, vamos a multiplicar por 5 y abajo diremos que si esta entre 484 y 500
	;;(o sea, fuera de rango del tablero), entonces que pida otro numero.
	
	mov ah, 0
	mov Bx, 5d
	mul Bx
	cmp ax, 1e4h
	
	JAE pidoNum
	add ax, origen
	;;si llegó hasta acá es porque el numero está dentro del tablero de juego.
	;;Pero, necesitamos saber si cayó dentro de un borde. En este caso no nos sirve ese valor y necesitamos otro.
	;;eso mismo hacemos acá
	
	
	mov bx, ax
	cmp [bx], byte 0
	jnz pidoNum
	
	mov cx, bx
	pop dx
	pop bx
	
	ret 
	
	