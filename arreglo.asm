; template for program using standard Win32 headers

format PE CONSOLE 4.0
entry start

include 'win32a.inc'

section '.data' data readable writeable

   str_pause db  'p','a','u','s','e',0
   msj1 db 'Ingrese numero 1: ' ,10,0
   msj2 db 'Ingrese numero 2: ' ,10,0
   resul db 'El resultado es: %d ' ,10,0
   msj_mayor db 'El mayor es: %d ' ,10,0
   arreglo dd 4,6,1,8 ;Accesar arreglo


   input db '%d',0
   output db '%d',10,0 ;enter

   a dd 0
   b dd 0
   c dd 0
   i dd 0

   mayor dd 0

section '.code' code readable executable

;int suma(int a,int b)
suma:
     ;prologo
      push ebp
      mov ebp, esp

      mov eax,[ebp+8];esta es la variable a, es +8 porque sumo ebp y varlor return
      add eax,[ebp+12] ; esta sería la variable b

      ;epilogo
      mov esp,ebp
      pop ebp
      ret


;int suma(int *a,int *b)
suma_con_parametros_por_referencia:
     ;prologo
      push ebp
      mov ebp, esp

      mov eax,[ebp+8];esta es la variable a, es +8 porque sumo ebp y varlor return
      mov eax,[eax]
      mov ebx,[ebp+12]
      add eax,[ebx]; esta sería la variable b

      ;epilogo
      mov esp,ebp
      pop ebp
      ret


;Los parametros se pushean desde derecha a izquierda
  start:
	;Pedir numero uno
	push msj1
	call [printf]
	add esp, 4
	push a
	push input
	call [scanf]
	add esp, 8

	;Pedir numero dos
	push msj2
	call [printf]
	add esp, 4
	push b
	push input
	call [scanf]
	add esp, 8

       ;para mandar las variables por referencia deben ir sin corchetes
       push b
       push a
       call suma_con_parametros_por_referencia
       add esp,8

       push eax
       push resul
       call [printf]
       add esp, 8


	mov eax,[a]
	cmp eax,[b]
	jg a_es_mayor
	mov eax,[b]
	mov [mayor], eax
	jmp fin_if

a_es_mayor:
	mov eax,[a]
	mov [mayor], eax

fin_if:
	push [mayor]
	push msj_mayor
	call [printf]
	add esp,8

	;For para imprimir el arreglo
	mov [i],0
    for:
	cmp [i],4
	jge finalizar_for
	    ;Codigo del for
	    mov edx,[i]
	    push [arreglo+edx*4]
	    push output
	    call [printf]
	    add esp,8

	inc [i];i++
	jmp for ; Regresar al ciclo for mientras sea menor que 4

finalizar_for:


       ;Finalizar el proceso
	push str_pause
	call [system]
	add esp, 4
	call [ExitProcess]

section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
	  ms ,'msvcrt.dll'

  import kernel,\
	 ExitProcess,'ExitProcess'

  import ms,\
	 printf,'printf',\
	 cget ,'_getch',\
	 system,'system',\
	 scanf,'scanf'