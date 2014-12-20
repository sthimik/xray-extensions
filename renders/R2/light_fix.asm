
light__light_fix proc
	;xor     eax, eax ; �������� ����� ���������
	;
	and     eax, 0FFFFFF81h
	or      eax, 1
	mov     [esi+3Ch], eax
	;
	mov eax, [flt_default_SMAP_near_plane]
	mov [esi + 270h], eax
	mov eax, [flt_default_SMAP_near_plane_neg]
	mov [esi + 274h], eax
	mov eax, [default_lamp_params]
	mov [esi + 278h], eax	; speed;
	mov [esi + 27Ch], eax	; amount
	mov [esi + 280h], eax	; smap_jitter
	mov [esi + 28Ch], eax	; fBlend
	xor	eax, eax
	mov [esi + 284h], eax	; is_require_flare
	mov [esi + 288h], eax	; is_volumetric
	mov [esi + 290h], eax	; is_actor_torch
	; 
	jmp back_from_light__light_fix
light__light_fix endp

light__export_fix proc
	; ������ ����������
	call    light__light
	; 
	push eax
	;--
	mov     eax, [ebp + 270h] ; 
	mov     [esi + 270h], eax
	mov     eax, [ebp + 274h] ; 
	mov     [esi + 274h], eax
	; --
	pop eax
	; ������������
	jmp     loc_1002FD4C
light__export_fix endp

light__export_fix_2 proc

	; ����������
	mov     ecx, [esp+24h+8h]
	mov     esi, [ecx]
	
	push	eax
	mov     eax, [ebp + 278h] ; 
	mov     [esi + 278h], eax
	mov     eax, [ebp + 27Ch] ; 
	mov     [esi + 27Ch], eax
	mov     eax, [ebp + 280h] ; 
	mov     [esi + 280h], eax
	cmp		edi, 0
	jnz		skip
	mov     eax, [ebp + 284h] ; 
	mov     [esi + 284h], eax
	mov     eax, [ebp + 288h] ; 
	mov     [esi + 288h], eax
	mov     eax, [ebp + 290h] ; 
	mov     [esi + 290h], eax
	
skip:
	
;	PRINT_UINT "FRAME RENDER %d", [ebp+0B4h]
;	PRINT_UINT "EXPORTING LIGHT PART %d", esi
;	mov		eax, dword ptr [esi + 278h]
;	PRINT_FLOAT "LSF_SPEED %f", eax
;	mov		eax, dword ptr [ebp + 278h]
;	PRINT_FLOAT "LSF_SPEED1 %f", eax	

	pop		eax

	jmp     loc_1002FD8F
light__export_fix_2 endp

CLight_Compute_XFORM_and_VIS__compute_xf_spot_fix proc
SMAP_near_plane_int_scaled = dword ptr -4
SMAP_near_plane            = dword ptr -8
SMAP_near_plane_neg        = dword ptr -12
st0_storage                = dword ptr -16
	; 
	push    ebp
	mov     ebp, esp
	sub     esp, 16
	push    eax
	; ���������, �� ������� �� ������ �� ������� ���������
	movss	xmm0, dword ptr [edi + 270h]
	comiss	xmm0, dword ptr [flt_0_01]
	jb		short set_default

	mov		eax, dword ptr [edi + 270h]
	mov		[ebp+SMAP_near_plane], eax
	mov		eax, dword ptr [edi + 274h]
	mov		[ebp+SMAP_near_plane_neg], eax
	jmp		short go_next
	
set_default:
	mov		eax, dword ptr [flt_0_01]
	mov		[ebp+SMAP_near_plane], eax
	mov		eax, dword ptr [flt_0_01_neg]
	mov		[ebp+SMAP_near_plane_neg], eax
	
go_next:
	; ������ ����������, 
	movss   dword ptr [edi+1DCh], xmm2
	movaps  xmm0, xmm1
	subss   xmm0, [ebp+SMAP_near_plane]
	divss   xmm1, xmm0
	xorps   xmm0, xmm0
	movss   dword ptr [edi+1B4h], xmm0
	movss   dword ptr [edi+1B8h], xmm0
	movss   dword ptr [edi+1BCh], xmm0
	movss   dword ptr [edi+1C0h], xmm0
	movss   dword ptr [edi+1C8h], xmm0
	movss   dword ptr [edi+1CCh], xmm0
	movss   dword ptr [edi+1D0h], xmm0
	movss   dword ptr [edi+1D4h], xmm0
	movss   dword ptr [edi+1E0h], xmm0
	movss   dword ptr [edi+1E4h], xmm0
	movss   dword ptr [edi+1ECh], xmm0
	movss   dword ptr [edi+1D8h], xmm1
	mulss   xmm1, [ebp+SMAP_near_plane_neg]
	;
	pop     eax
	mov     esp, ebp
	pop     ebp
	;
	jmp back_from_CLight_Compute_XFORM_and_VIS__compute_xf_spot_fix
CLight_Compute_XFORM_and_VIS__compute_xf_spot_fix endp

light_blink_fix proc
	push	ecx
	movss   xmm0, dword ptr [edi+68h]
	mov		ecx, [edi+3Ch]		;light::flags
	and		cl, 0Fh
	test	cl, 1				
	pop		ecx
	jz		short not_point
	addss   xmm0, dword ptr [tan_shift_point]
	jmp		short l_exit
	
not_point:
	addss   xmm0, dword ptr [tan_shift_spot]
	
l_exit:
	jmp back_from_light_blink_fix
light_blink_fix endp

flt_0_01 dd 0.01
flt_0_01_neg dd -0.01
tan_shift_point dd 0.2007
tan_shift_spot dd 0.0611
flt_default_SMAP_near_plane dd 0.1
flt_default_SMAP_near_plane_neg dd -0.1
default_lamp_params dd 0.0
