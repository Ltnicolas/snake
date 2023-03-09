;;este es el archivo princial, tipo la clase main de java
;;al es columna!! ah es fila

BITS 16
ORG 0x100

origen EQU 4000h 	;;es el punto de coordenadas (0,0)
origenPos EQU 4200h ;;es donde arranca nuestro registro de las posiciones de la viborita
final EQU 41E4h 	;;este es el ultimo punto (22d, 22d)
largo EQU 21d 		;;en realidad el largo es 22, pero como existe la celda (0,0) lo dejamos en 21

call preguntarTeclas

inicio:
call iniciarModoGrafico

	
	call iniMem
	call Pintar
	call Pinfruta
	memuevo:
		call mostrarPuntaje
		call deteTec
		call PreguntoSiPuedoMover
		call MovSnake
		call sonidoMover
		call nivel_2
		call nivel_3
	JMP memuevo
	
	 
	%include "TIMER.asm"
	%include "SONIDO.asm"
	%include "UTILIT.asm"
	%include "GRAF.asm"
	
	
	mensajePerder db "GAME OVER$",0
	teclaArriba db 48h
	teclaAbajo db 50h
	teclaDerecha db 4dh
	teclaIzquierda db 4bh
	mensajeArriba db 'presione una tecla para redefinir -mover hacia arriba- $',0xFF,
	mensajeAbajo db 'presione una tecla para redefinir "mover hacia abajo" $',0x1c,
	mensajeIzquierda db 'presione una tecla para redefinir "mover hacia a izquierda" $',0xFF,
	mensajeDerecha db 'presione una tecla para redefinir "mover hacia la derecha" $',0x1c,

	
	ultimaTecla db 4dh ;;almacena la ultima tecla que se oprimio. lo usaremos en deteTec
	
	puntajeMillares db 30h
	puntajeCentenas db 30h
	puntajeDecenas db 30h
	puntajeUnidades db 30h