gameover:
	
					;;interrupcion para mostrar mensaje cuando perder juego
	mov ax, 0x1301
	mov bx, 0x0004
	mov cx, 0x0009
	mov dx, 0x0a0a
	mov bp, mensajePerder
	int 10h
	
	
	call sonidoEstrellarse
	
	mov ah, 0x0c
	mov al, 0
	int 21h 		;;esto limpia el buffer de teclado. Si no se limpia, no permite esperar una tecla y sale inmediatamente despues
					;;de que se termino de tocar la musica de perder partida
	
	
	mov ah,10h
	int 16h 		;;presione una tecla para continuar
	
	
					;;limpiar la memoria?? si se corre el programa dos veces trae problemas: el programa lee lo que habia en la corrida del programa de antes,
					;;y la segunda vez que se corre aparece cualquier cosa. 
					;;con esto, al terminar el programa se borra todo lo que habia en memoria, para que la proxima instancia de la viborita tenga datos 'frescos'
	mov bx, 4000h
	
call limpiarMemoria
	
	mov ax, 0003h
	int 10h 		;;pasar a modo texto
	
	mov ah, 0x4c
	int 21h 		;;salir al (DOS)
	
limpiarMemoria:
	mov [bx], byte 0
	inc bx
	cmp bx, 4400h
    jnz limpiarMemoria
ret 


iniMem:
;;inicializarMemoria:

;;0 - blanco
;;1 - borde/obstaculo
;;2 - cuerpo de viborita
;;3 - fruta
;;4 - cabeza de la viborita
;;5 - cola?


;;**************************por AH fila y AL columna!


	
	
	;;vamos a hacer unos artilugios aqui. para dibujar el tablero, primero lo tendremos inicializado todo en 1 (borde). y luego colocaremos un
	;;cuadrado interior de ceros (espacio vacio). "Es mas facil pintar dos cuadrados superpuestos que dibujar un marco en un cuadrado"

mov cx, origen ;;aca rellenamos todo el tablero con 1 (obstaculo) desde la 1000h a la 11e4h
bucle:
	mov BX, CX ;;este MOV es porque no nos deja usar CX como posicion de memoria
	mov [BX], byte 1
	inc cx
	cmp cx, 41e4h ;;uno más que la 11e4, que es la ultima posicion del tablero
	JNZ bucle
	mov cx, 4017h


mov ah, 1 ;;recordemos: aH es la FILA
mov al, 0 ;;recordemos: aL es la columna, le damos 0 aca para que nos rellene la primer fila
;;con el siguiente 'for' recorreremos el tablero de arriba a abajo, y de izquierda a derecha
bucleColumna:
inc al
	bucleFila:
		
		Mov Bx, Cx
		mov [BX], byte 0
		inc ah
		inc Cx
		cmp ah, 21d
		JNZ bucleFila
		
	inc Cx
	inc Cx
	mov ah, 1
	
	cmp al, 20d
	JNZ bucleColumna
	
	mov [40FDh], byte 4h ;;colocamos la cabeza de la viborita en la coordenadas (10d,10d)
	mov [4200h], word 40FDh;; guardamos a partir de la 4200h la cabeza y el resto del cuerpo en 2 bytes
	mov [40FCh], byte 2h ;;colocamos cuerpo en las coordenadas (10d,9d)
	mov [4202h], word 40FCh
	mov [40FBh], byte 2h ;;colocamos cuerpo en las coordenadas (10d,8d)
	mov [4204h], word 40FBh
	mov [4206h], byte 0h;; marco el final de la vibora con un cero para desp hacer la recorrida

	ret 
	
	
	contarPuntaje:

	push bx
	mov bx, puntajeDecenas
	cmp [bx], byte 39h
	je .pasoACentenas
	add[bx], byte 1h ;;sumamos uno porque aumenta el puntaje
	jmp .final
	
.pasoACentenas:
	mov [bx], byte 30h
	mov bx, puntajeCentenas
	cmp [bx], byte 39h
	je .pasoAMillares
	add [bx], byte 1h
	jmp .final
	
.pasoAMillares:
	mov [bx], byte 30h
	mov bx, puntajeMillares
	add [bx], byte 1h
	
.final:
	pop bx
	;;call mostrarPuntaje
ret 

mostrarPuntaje: 
	push ax
	push bx
	push cx
	push dx 
	push bp
	
mov ax, 1301h ;;AH= Parámetro de interrupcion: escribir String.  AL = 1: modo de escritura.
mov bx, 0031h ;; BH= página, BL= color
mov cx, 0004h ;; longitud del String.(4 dígitos)
mov dx, 081Ah ;;DH=Fila, DL = columna
mov bp, puntajeMillares ;;posicion del String
int 10h ;;interrupcion para mostrar por pantalla el puntaje

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax 
	
	ret 
	
	
	nivel_2:

Push bx

cmp [puntajeMillares], byte 30H
JNZ termino

cmp [puntajeCentenas], byte 31H
JNZ termino

cmp [puntajeDecenas], byte 30H
JNZ termino

cmp [puntajeUnidades], byte 30h
JNZ termino


mov [puntajeDecenas], byte 31h ;;bonus de 10 puntos
call limpiarMemoria
call iniMem
mov bx, 40E1h
pared:

mov [bx], byte 1
inc bx
cmp bx, 40EDh

JNZ pared

call Pintar

call Pinfruta



termino:

Pop bx


ret 


nivel_3:

Push bx

cmp [puntajeMillares], byte 30H
JNZ termino1

cmp [puntajeCentenas], byte 32H
JNZ termino1

cmp [puntajeDecenas], byte 30H
JNZ termino1

cmp [puntajeUnidades], byte 30h
JNZ termino1


;;mov [puntajeCentenas], byte 32h ;;bonus de 100 puntos
mov [puntajeDecenas], byte 35h ;;bonus de 50 puntos

call limpiarMemoria
call iniMem
mov bx, 40E1h
pared1:

mov [bx], byte 1
inc bx
cmp bx, 40EDh

JNZ pared1

mov bx, 4073h
pared2:

mov [bx], byte 1
inc bx
cmp bx, 407Fh

JNZ pared2

mov bx, 414Fh
pared3:

mov [bx], byte 1
inc bx
cmp bx, 415Bh

JNZ pared3

call Pintar
call Pinfruta



termino1:

Pop bx


ret 



veoEvent:

						;;por cx me viene la posicion de la cola antes de ralizar el movimiento en la matriz
						;;por bx me viene la posicion de memoria donde encontro el primer cero en la cadena de posciones

				
	cmp si, 0			
	JNZ comiperdi	
		mov bx, cx			;;entro aca si no comi ni perdi
		mov [bx], byte 0	;;borro la cola
		call deMemACo
		mov dh, 0
		mov dl, ah		
		mov ch, 0
		mov cl, al
		mov al, [bx]
		call dibuCuad
		JMP termine
	comiperdi:
		cmp si, 3	
		JNZ nocomi
		call contarPuntaje	;;si comi una fruta aumento el puntaje y sigo jugando
		call sonidoFruta
		mov [bx], cl	;; cargo la cola que no se borro en memoria
		inc bx
		mov [bx], ch	  
		call deMemACo
		mov dh, 0
		mov dl, ah		
		mov ch, 0
		mov cl, al
		mov bx, cx
		mov al, [bx]
		call dibuCuad
		call Pinfruta
		JMP termine
		
		nocomi:   		;;entro aca si choque contra la porpia vibora o contra la pared
		mov cx, bx		
		call deMemACo
		mov dh, 0
		mov dl, ah		;;borro la cola
		mov ch, 0
		mov cl, al
		mov al, [bx]
		call dibuCuad
		call gameover   
		
		termine:	
		
ret 


deteTec:
;;detectarTecla:

Push ax

mov di, 0
in al, 60h 			;;recibimos la ultima tecla oprimida (o soltada)
and al, 01111111b	;; esto es para forzar el ultimo bit a cero. hace que no nos importe si la tecla fue apretada o soltada.

cmp al, [ultimaTecla]
jz siguiente5

cmp al, [teclaArriba]
JNZ siguiente1
mov di, 10d
call movarri
JMP siguiente4

siguiente1:
cmp al, [teclaAbajo]
JNZ siguiente2
mov di, 10d
call movabajo
JMP siguiente4

siguiente2:
cmp al, [teclaIzquierda]
JNZ siguiente3
mov di, 10d
call movizq
JMP siguiente4

siguiente3:
cmp al, [teclaDerecha]
JNZ siguiente4
mov di, 10d
call movDer


siguiente4:
mov [ultimaTecla], al
siguiente5:


Pop ax
ret 


MovSnake:

Push ax
Push bx
Push cx
Push dx

call actuCab



call actuCuer


push cx					;;ahora actualizada la matriz y las posiciones de la vibora lo paso a pantalla
push dx           		;;guardo la ultima posicion del cuerpo de la vibora que se borrara si no comi fruta

call pinCuer			;;tambien pinta la cabeza pero no la cola
				
pop dx 
pop cx      			;;restauro la posicion inicial de la cola	

call veoEvent			;;chequea si no comi fruta para borrar la cola, si comi no la borro, si choque gameover

Pop dx
Pop cx
Pop bx
Pop ax
ret 


deMemACo:
;;PasarDeMemoriaACoordenadas:
;Subrutina que dada una posicion de memoria me da su valor asociado de fila-columna en Ax
;Ah=fila y Al=columna
;le paso la posicion de memoria por Cx

Push Cx
push Bx


sub Cx, origen; resto 4000h paraq dejar solamente el valor por encima de 1000h

Mov Ax, Cx; guardo en Ax que es donde voy a operar
mov Bl, 22d
Div Bl


Mov Bh, Al; guardo en Bh el valor de la fila
Mov Ah, 0; relleno de ceros
Mul Bl; multiplico la fila por 22
Sub Cx, Ax; al valor de la memoria le resto 4000h y el valor ahora en Ax
Mov Ax, Cx; este es el valor de la columna que lo cargo en Ax
Mov Ah, Bh; en Ah le cargo el valor de la fila guardado anteriormente


Pop Bx
Pop Cx

ret 


actuCuer:
;;actualizocuerpo:


inc bx					;;voy a la sig poisicion en memoria en el registro de posiciones.
muevo:	
	mov dx, [bx]    	;;guardo la posicion anterior
	mov [bx], cx    	;; le cargo la nueva posicion al cuerpo que es la posicion vieja de la parte del cuerpo de adelante de ella
	mov al, [bx]    	;;guardo la parte baja de la nueva posicion del cuerpo en al
	inc bx
	mov ah, [bx]    	;;guardo la parte alta de la nueva posicion del cuerpo en AH
	push bx
	mov bx, ax
	mov [bx], byte 2d   ;;le cargo el 2 a la matriz
	pop bx
	mov cx, dx			;;guardo la siguiente posicion del cuerpo de la vibora
	inc bx
	cmp [bx+1],  byte 0	;;me fijo que no haya llegado al final de la vibora
	
	JNZ muevo
	

ret


ConvCAM:
;;convertir de coordenadas a Memoria
;;recibe en ah,al y te devuelve la posicion de memoria equivalente en CX
;;recordemos:  AH fila, AL columna
 
;;cuestiones de prueba, esta dos se pueden borrar nomas
	mov ah, 0xF
	mov al, 0xF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;el algoritmo es: col*22d + filas + 4000h = posicion MEMORIA!


	PUSH AX
	PUSH BX

	mov bh, ah
	mov ah,0 ;; me quedo solo con AL para quedar pronto con AX para multiplicar
	
	mov bl, 22d ;;esto solo sirve para la multiplicacion...
	mul BL ;;..porque no nos deja hacer multipicacion por 22
	
	mov bl, bh;;con esta instruccion...
	mov bh, 0 ;;...y esta otra reseteamos BX para sumar mas adelante
	add ax, bX
	add ax, origen

	mov cx, ax;; porque queremos que el valor se devuelva en CX

pop bx
pop ax

ret 



movarri:

Push ax
Push bx 
Push cx
Push dx



mov ax, [4200h]
sub ax, [4202h]
mov bx, 4200h


cmp ax, word -1          ;;me muevo de izq a derecha
JZ puedomover
cmp ax, word 1
JNZ noMuevo 			;;si ax es 1, entra a puedomover

puedomover:
	mov cx, [bx]  		;;guardo en cx la posicion de la cabeza en el tablero
	Push cx       		;;guardo la posicion inicial de la cabeza
	sub cx, 22d    		;;le resto 22 porque se mueve hacia arriba
	mov [bx], cx  		;;le actualizo la posicion de la cabeza
	mov al, [bx] 		;;cargo la parte baja de la posicion de la cabeza en al
	inc bx	      
	mov ah, [bx]  		;;cargo la parte alta de la posicion de la cabeza en ah
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d	;;a esa posicion le seteo la cabeza en el tablero
	pop bx
	pop cx


mov dh, 0 ;;porque nos interesa solo la parte alta de dx, y SI no nos deja trabajar con parte baja
mov si, dx			;;guardo el valor que habia en la matriz en la nueva posicion de la cabeza para saber si comio fruta, choco, etc...


call actuCuer


;;ahora actualizada la matriz y las posiciones de la vibora lo paso a pantalla
push cx
push dx           		;;guardo la ultima posicion del cuerpo de la vibora que se borrara si no comi fruta

call pinCuer		;;tambien pinta la cabeza pero no la cola
				
pop dx       			;;restauro la posicion inicial de la cola	
pop cx

call veoEvent			;;chequea si no comi fruta para borrar la cola, si comi no la borro, si choque gameover


noMuevo:


Pop dx
Pop cx
Pop bx
Pop ax

ret 


movabajo:

Push ax
Push bx 
Push cx
Push dx




mov ax, [4200h]
sub ax, [4202h]
mov bx, 4200h


cmp ax, word -1          ;;me muevo de izq a derecha
JZ .puedomover
cmp ax, word 1
JNZ .noDeboMover 			;;si ax es 1, entra a puedomover

.puedomover:
	mov cx, [bx]  		;;guardo en cx la posicion de la cabeza en el tablero
	Push cx       		;;guardo la posicion inicial de la cabeza
	add cx, 22d    		;;le sumo 22 porque se mueve hacia abajo
	mov [bx], cx  		;;le actualizo la posicion de la cabeza
	mov al, [bx] 		;;cargo la parte baja de la posicion de la cabeza en al
	inc bx	      
	mov ah, [bx]  		;;cargo la parte alta de la posicion de la cabeza en ah
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d	;;a esa posicion le seteo la cabeza en el tablero
	pop bx
	pop cx

mov dh, 0 ;;porque nos interesa solo la parte alta de dx, y SI no nos deja trabajar con parte baja
mov si, dx			;;guardo el valor que habia en la matriz en la nueva posicion de la cabeza para saber si comio fruta, choco, etc...


call actuCuer


;;ahora actualizada la matriz y las posiciones de la vibora lo paso a pantalla
push cx
push dx           		;;guardo la ultima posicion del cuerpo de la vibora que se borrara si no comi fruta

call pinCuer		;;tambien pinta la cabeza pero no la cola
				
pop dx       			;;restauro la posicion inicial de la cola	
pop cx

call veoEvent			;;chequea si no comi fruta para borrar la cola, si comi no la borro, si choque gameover


.noDeboMover:


Pop dx
Pop cx
Pop bx
Pop ax 

ret 


movDer:

Push ax
Push bx
Push cx
Push dx



mov ax, [4200h]
sub ax, [4202h]
mov bx, 4200h


cmp ax, word -22        ;;me muevo de abajo hacia arriba
JZ .puedomover
cmp ax, word 22			;; me muevo de arriba haci abajo
JNZ .noda22			;;si ax es 1, entra a puedomover

.puedomover:
	mov cx, [bx]  		;;guardo en cx la posicion de la cabeza en el tablero
	Push cx       		;;guardo la posicion inicial de la cabeza
	add cx, 1    		;;le sumo 1 porque se mueve hacia la derecha
	mov [bx], cx  		;;le actualizo la posicion de la cabeza
	mov al, [bx] 		;;cargo la parte baja de la posicion de la cabeza en al
	inc bx	      
	mov ah, [bx]  		;;cargo la parte alta de la posicion de la cabeza en ah
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d	;;a esa posicion le seteo la cabeza en el tablero
	pop bx
	pop cx

mov dh, 0 ;;porque nos interesa solo la parte alta de dx, y SI no nos deja trabajar con parte baja
mov si, dx		;;guardo el valor que habia en la matriz en la nueva posicion de la cabeza para saber si comio fruta, choco, etc..


call actuCuer


;;ahora actualizada la matriz y las posiciones de la vibora lo paso a pantalla
push cx
push dx           		;;guardo la ultima posicion del cuerpo de la vibora que se borrara si no comi fruta

call pinCuer		;;tambien pinta la cabeza pero no la cola
				
pop dx       			;;restauro la posicion inicial de la cola	
pop cx

call veoEvent			;;chequea si no comi fruta para borrar la cola, si comi no la borro, si choque gameover


.noda22:


Pop dx
Pop cx
Pop bx
Pop ax 

ret 


movizq:

Push ax
Push bx
Push cx
Push dx



mov ax, [4200h]
sub ax, [4202h]
mov bx, 4200h


cmp ax, word -22        ;;me muevo de abajo hacia arriba
JZ .puedomover
cmp ax, word 22			;; me muevo de arriba haci abajo
JNZ .noda22				;;si ax es 1, entra a puedomover

.puedomover:
	mov cx, [bx]  		;;guardo en cx la posicion de la cabeza en el tablero
	Push cx       		;;guardo la posicion inicial de la cabeza
	sub cx, 1    		;;le resto 1 porque se mueve hacia la izquierda
	mov [bx], cx  		;;le actualizo la posicion de la cabeza
	mov al, [bx] 		;;cargo la parte baja de la posicion de la cabeza en al
	inc bx	      
	mov ah, [bx]  		;;cargo la parte alta de la posicion de la cabeza en ah
	push bx
	mov bx, ax

	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d	;;a esa posicion le seteo la cabeza en el tablero
	pop bx
	pop cx

	mov dh, 0 ;;porque nos interesa solo la parte alta de dx, y SI no nos deja trabajar con parte baja
	mov si, dx	;;guardo el valor que habia en la matriz en la nueva posicion de la cabeza para saber si comio fruta, choco, etc...


call actuCuer


;;ahora actualizada la matriz y las posiciones de la vibora lo paso a pantalla
push cx
push dx           		;;guardo la ultima posicion del cuerpo de la vibora que se borrara si no comi fruta

call pinCuer		;;tambien pinta la cabeza pero no la cola
				
pop dx       			;;restauro la posicion inicial de la cola	
pop cx

call veoEvent			;;chequea si no comi fruta para borrar la cola, si comi no la borro, si choque gameover


.noda22:


Pop dx
Pop cx
Pop bx
Pop ax 

ret 


actuCab:
;;actualizarcabeza:



mov ax, [4200h]
sub ax, [4202h]
mov bx, 4200h


cmp ax, word 1
JNZ nodauno	
	mov cx, [bx]  		;;guardo en cx la posicion de la cabeza en el tablero
	Push cx       		;;guardo la posicion inicial de la cabeza
	add cx, 1d    		;;le sumo uno porque se mueve hacia la derecha
	mov [bx], cx  		;;le actualizo la posicion de la cabeza
	mov al, [bx] 		;;cargo la parte baja de la posicion de la cabeza en al
	inc bx	      
	mov ah, [bx]  		;;cargo la parte alta de la posicion de la cabeza en ah
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d	;;a esa posicion le seteo la cabeza en el tablero
	pop bx
	JMP Sigo

	
nodauno:
cmp ax,  word -1d
JNZ nodamenosuno
	mov cx, [bx]  ;;igual que el anteiror solo que para -1
	Push cx
	sub cx, 1d
	mov [bx], cx
	mov al, [bx]
	inc bx
	mov ah, [bx]
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d
	pop bx
	JMP Sigo
	
nodamenosuno:



cmp ax, word 22
JNZ noda22
	mov cx, [bx]	;;igual que el anteiror solo que para 22
	Push cx
	add cx, 22d
	mov [bx], cx
	mov al, [bx]
	inc bx
	mov ah, [bx]
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva porsicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d
	pop bx
	JMP Sigo
	

noda22:
	mov cx, [bx]	;;igual que el anterior solo que para -22
	Push cx
	sub cx, 22d
	mov [bx], cx
	mov al, [bx]
	inc bx
	mov ah, [bx]
	push bx
	mov bx, ax
	mov dl, [bx]  		;;guardo lo que tengo en la nueva posicion de la cabeza para ver si comio fruta, choco o hay campo libre
	mov [bx], byte 4d
	pop bx

Sigo:

mov dh, 0 				;;porque nos interesa solo la parte alta de dx, y SI no nos deja trabajar con parte baja
mov si, dx				;;guardo el valor que habia en la matriz en la nueva posicion de la cabeza para saber si comio fruta, choco, etc...
Pop cx          		;;restauro la posicion inicial de la cabeza

ret 


preguntarTeclas:

	push ax
	push dx
	
		
	; Pasamos a modo texto
	mov ax,0003h
	int 10h
	
	
	call mandarEnter
	;;mandamos el mensaje para redefinir ARRIBA
	mov ah, 09
	mov dx, mensajeArriba
	int 0x21
	
	
	mov ah,10h ;;espera a que se presione unatecla para continuar
	int 16h
	
	in al, 60h ;;esto te devuelve el scancode de la ultima tecla apretada.
		;;CIUDADO! el scancode para una tecla apretada o soltada son iguales, EXCEPTO en el primer bit.
	and al, 01111111b ;; esto fuerza a cero el primer bit. con esto evitamos el problema mencionado.
	mov [teclaArriba], al
	
	
	call mandarEnter
	;;mandamos el mensaje para redefinir ABAJO
	mov ah, 09
	mov dx, mensajeAbajo
	int 0x21	
	
	mov ah,10h ;;espera a que se presione unatecla para continuar
	int 16h
	in al, 60h ;;esto te devuelve el scancode de la ultima tecla apretada.
		;;CIUDADO! el scancode para una tecla apretada o soltada son iguales, EXCEPTO en el primer bit.
	and al, 01111111b ;; esto fuerza a cero el primer bit. con esto evitamos el problema mencionado.
	mov [teclaAbajo], al
	
	
	call mandarEnter
	;;mandamos el mensaje para redefinir IZQUIERDA
		mov ah, 09
	mov dx, mensajeIzquierda
	int 0x21	
	
	mov ah,10h ;;espera a que se presione unatecla para continuar
	int 16h
	in al, 60h ;;esto te devuelve el scancode de la ultima tecla apretada.
		;;CIUDADO! el scancode para una tecla apretada o soltada son iguales, EXCEPTO en el primer bit.
	and al, 01111111b ;; esto fuerza a cero el primer bit. con esto evitamos el problema mencionado.
	mov [teclaIzquierda], al
		
	
	call mandarEnter
		;;mandamos el mensaje para redefinir DERECHA
	mov ah, 09
	mov dx, mensajeDerecha
	int 0x21	
	
	
	mov ah,10h ;;espera a que se presione unatecla para continuar
	int 16h
	in al, 60h ;;esto te devuelve el scancode de la ultima tecla apretada.
		;;CIUDADO! el scancode para una tecla apretada o soltada son iguales, EXCEPTO en el primer bit.
	and al, 01111111b ;; esto fuerza a cero el primer bit. con esto evitamos el problema mencionado.
	mov [teclaDerecha], al
	
	pop dx
	pop ax
	
	ret 
	
	
mandarEnter: ;;Esto te manda un renglon de enter
	mov ah, 0x0e
	mov al, 0x0d
	int 0x10	
ret
