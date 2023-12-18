        TEXT    command-line-arguments._RoundUpPowerOf2(SB), NOSPLIT|NOFRAME|ABIInternal, $0-8
        FUNCDATA        $0, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments._RoundUpPowerOf2.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments._RoundUpPowerOf2.argliveinfo(SB)
        PCDATA  $3, $1
        DECQ    AX
        MOVQ    AX, CX
        SHRQ    $1, CX
        ORQ     CX, AX
        MOVQ    AX, CX
        SHRQ    $2, CX
        ORQ     CX, AX
        MOVQ    AX, CX
        SHRQ    $4, CX
        ORQ     CX, AX
        MOVQ    AX, CX
        SHRQ    $8, CX
        ORQ     CX, AX
        MOVQ    AX, CX
        SHRQ    $16, CX
        ORQ     CX, AX
        MOVQ    AX, CX
        SHRQ    $32, CX
        ORQ     CX, AX
        INCQ    AX
        RET
command-line-arguments_Open_pc0:
        TEXT    command-line-arguments.Open(SB), ABIInternal, $48-0
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_Open_pc149
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $40, SP
        FUNCDATA        $0, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $1, gclocals·CnDyI2HjYXFz19SsOj98tw==(SB)
        NOP
        LEAQ    type:uint8(SB), AX
        MOVL    $17920, BX
        MOVQ    BX, CX
        PCDATA  $1, $0
        CALL    runtime.makeslice(SB)
        MOVQ    AX, command-line-arguments.bb+24(SP)
        MOVQ    AX, BX
        MOVL    $128, CX
        LEAQ    command-line-arguments..dict.MPMCInit[uintptr](SB), AX
        CALL    command-line-arguments.MPMCInit[go.shape.uintptr](SB)
        NOP
        TESTB   AL, AL
        JEQ     command-line-arguments_Open_pc129
        LEAQ    command-line-arguments..dict.MPMCAttach[uintptr](SB), AX
        MOVQ    command-line-arguments.bb+24(SP), BX
        XORL    CX, CX
        CALL    command-line-arguments.MPMCAttach[go.shape.uintptr](SB)
        MOVQ    AX, command-line-arguments..autotmp_10+32(SP)
        LEAQ    command-line-arguments..dict.MPMCRing[uintptr](SB), BX
        XORL    CX, CX
        PCDATA  $1, $1
        CALL    command-line-arguments.(*MPMCRing[go.shape.uintptr]).Enqueue(SB)
        MOVQ    command-line-arguments..autotmp_10+32(SP), AX
        LEAQ    command-line-arguments..dict.MPMCRing[uintptr](SB), BX
        PCDATA  $1, $0
        CALL    command-line-arguments.(*MPMCRing[go.shape.uintptr]).Dequeue(SB)
        ADDQ    $40, SP
        POPQ    BP
        RET
command-line-arguments_Open_pc129:
        LEAQ    type:string(SB), AX
        LEAQ    command-line-arguments..stmp_0(SB), BX
        CALL    runtime.gopanic(SB)
        XCHGL   AX, AX
command-line-arguments_Open_pc149:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        CALL    runtime.morestack_noctxt(SB)
        PCDATA  $0, $-1
        JMP     command-line-arguments_Open_pc0
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc0:
        TEXT    command-line-arguments.MPMCAttach[go.shape.uintptr](SB), DUPOK|ABIInternal, $72-24
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc246
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $64, SP
        FUNCDATA        $0, gclocals·wBS4fiKwwXBG0Q3AcyXF/Q==(SB)
        FUNCDATA        $1, gclocals·ShrCR2lbrdPvyLG+AuFYmA==(SB)
        FUNCDATA        $5, command-line-arguments.MPMCAttach[go.shape.uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.MPMCAttach[go.shape.uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    CX, command-line-arguments.timeout+96(SP)
        MOVQ    BX, command-line-arguments.h+88(SP)
        PCDATA  $3, $2
        PCDATA  $1, $0
        NOP
        CALL    time.Now(SB)
        MOVQ    CX, command-line-arguments..autotmp_18+56(SP)
        MOVQ    BX, command-line-arguments..autotmp_19+40(SP)
        MOVQ    AX, command-line-arguments..autotmp_20+32(SP)
        MOVQ    command-line-arguments.h+88(SP), DX
        MOVQ    DX, SI
        MOVQ    DX, command-line-arguments..autotmp_21+48(SP)
        MOVQ    command-line-arguments.timeout+96(SP), DI
        JMP     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc119
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc72:
        PCDATA  $1, $-1
        NOP
        LEAQ    runtime.gosched_m·f(SB), AX
        PCDATA  $1, $1
        CALL    runtime.mcall(SB)
        MOVQ    command-line-arguments.timeout+96(SP), CX
        MOVQ    command-line-arguments..autotmp_21+48(SP), DX
        MOVQ    command-line-arguments..autotmp_20+32(SP), AX
        MOVQ    command-line-arguments..autotmp_18+56(SP), CX
        MOVQ    command-line-arguments..autotmp_19+40(SP), BX
        MOVQ    command-line-arguments.h+88(SP), SI
        MOVQ    command-line-arguments.timeout+96(SP), DI
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc119:
        MOVQ    (DX), R8
        MOVQ    16(DX), R9
        MOVQ    8(DX), R10
        MOVQ    $2735938947133216139, R11
        CMPQ    R8, R11
        JNE     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc152
        BTL     $1, R9
        JCS     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc177
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc152:
        TESTQ   DI, DI
        JGT     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc72
        NOP
        CALL    time.Since(SB)
        MOVQ    command-line-arguments.timeout+96(SP), DX
        CMPQ    AX, DX
        JLT     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc72
        JMP     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc238
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc177:
        MOVQ    R10, command-line-arguments.size+24(SP)
        LEAQ    type:command-line-arguments.MPMCRing[go.shape.uintptr](SB), AX
        PCDATA  $1, $0
        NOP
        CALL    runtime.newobject(SB)
        MOVQ    command-line-arguments.size+24(SP), CX
        MOVQ    CX, 8(AX)
        DECQ    CX
        MOVQ    CX, (AX)
        MOVQ    command-line-arguments.h+88(SP), CX
        MOVQ    CX, 16(AX)
        ADDQ    $256, CX
        MOVQ    CX, 24(AX)
        ADDQ    $64, SP
        POPQ    BP
        RET
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc238:
        XORL    AX, AX
        ADDQ    $64, SP
        POPQ    BP
        RET
command-line-arguments_MPMCAttach[go_shape_uintptr]_pc246:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        MOVQ    CX, 24(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        MOVQ    24(SP), CX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCAttach[go_shape_uintptr]_pc0
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc0:
        TEXT    command-line-arguments.(*MPMCRing[go.shape.uintptr]).Dequeue(SB), DUPOK|ABIInternal, $24-16
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc166
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $16, SP
        FUNCDATA        $0, gclocals·Jog/qYB4a+fiwM7je5AA/g==(SB)
        FUNCDATA        $1, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $5, command-line-arguments.(*MPMCRing[go.shape.uintptr]).Dequeue.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.(*MPMCRing[go.shape.uintptr]).Dequeue.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    16(AX), CX
        MOVQ    24(CX), DX
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc31
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc28:
        MOVQ    BX, AX
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc31:
        MOVQ    (AX), SI
        ANDQ    DX, SI
        MOVQ    SI, DI
        SHLQ    $7, SI
        LEAQ    (SI)(DI*8), SI
        ADDQ    24(AX), SI
        MOVQ    128(SI), DI
        SUBQ    DX, DI
        NOP
        CMPQ    DI, $1
        JNE     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc98
        LEAQ    1(DX), DI
        MOVQ    AX, BX
        MOVQ    DX, AX
        LOCK
        CMPXCHGQ        DI, 24(CX)
        SETEQ   DIB
        TESTB   DIB, DIB
        JEQ     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc28
        NOP
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc116
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc98:
        LEAQ    -1(DI), DX
        TESTQ   DX, DX
        JLS     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc143
        MOVQ    24(CX), DX
        MOVQ    AX, BX
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc28
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc116:
        MOVQ    (SI), AX
        MOVQ    (BX), CX
        LEAQ    (DX)(CX*1), CX
        LEAQ    1(CX), CX
        XCHGQ   CX, 128(SI)
        ADDQ    $16, SP
        POPQ    BP
        RET
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc143:
        LEAQ    type:string(SB), AX
        LEAQ    command-line-arguments..stmp_1(SB), BX
        PCDATA  $1, $1
        NOP
        CALL    runtime.gopanic(SB)
        XCHGL   AX, AX
command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc166:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        PCDATA  $0, $-1
        NOP
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Dequeue_pc0
command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc0:
        TEXT    command-line-arguments.(*MPMCRing[go.shape.uintptr]).Enqueue(SB), DUPOK|ABIInternal, $32-24
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc178
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $24, SP
        FUNCDATA        $0, gclocals·KJAkEuB5QpwyaNucH9oSmQ==(SB)
        FUNCDATA        $1, gclocals·VtCL4RdUwCqwXEPeyJllRA==(SB)
        FUNCDATA        $5, command-line-arguments.(*MPMCRing[go.shape.uintptr]).Enqueue.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.(*MPMCRing[go.shape.uintptr]).Enqueue.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    AX, command-line-arguments.m+40(SP)
        MOVQ    CX, command-line-arguments.elem+56(SP)
        PCDATA  $3, $2
        MOVQ    16(AX), DX
        MOVQ    DX, command-line-arguments..autotmp_14+16(SP)
        MOVQ    128(DX), BX
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc91
command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc46:
        MOVQ    BX, command-line-arguments.p+8(SP)
        NOP
        LEAQ    runtime.gosched_m·f(SB), AX
        PCDATA  $1, $1
        CALL    runtime.mcall(SB)
        MOVQ    command-line-arguments..autotmp_14+16(SP), CX
        MOVQ    command-line-arguments.m+40(SP), DX
        MOVQ    command-line-arguments.p+8(SP), BX
        MOVQ    DX, AX
        MOVQ    command-line-arguments.elem+56(SP), CX
        MOVQ    command-line-arguments..autotmp_14+16(SP), DX
command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc91:
        MOVQ    (AX), SI
        ANDQ    BX, SI
        MOVQ    SI, DI
        SHLQ    $7, SI
        LEAQ    (SI)(DI*8), SI
        ADDQ    24(AX), SI
        MOVQ    128(SI), DI
        CMPQ    DI, BX
        JNE     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc151
        LEAQ    1(BX), DI
        MOVQ    BX, AX
        LOCK
        CMPXCHGQ        DI, 128(DX)
        SETEQ   R9B
        TESTB   R9B, R9B
        JEQ     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc46
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc162
command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc151:
        MOVQ    128(DX), BX
        NOP
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc46
command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc162:
        MOVQ    CX, (SI)
        XCHGQ   DI, 128(SI)
        ADDQ    $24, SP
        POPQ    BP
        RET
command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc178:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        MOVQ    CX, 24(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        MOVQ    24(SP), CX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCRing[go_shape_uintptr]_Enqueue_pc0
command-line-arguments_MPMCAttach[uintptr]_pc0:
        TEXT    command-line-arguments.MPMCAttach[uintptr](SB), DUPOK|WRAPPER|ABIInternal, $32-16
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCAttach[uintptr]_pc47
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $24, SP
        MOVQ    32(R14), R12
        TESTQ   R12, R12
        JNE     command-line-arguments_MPMCAttach[uintptr]_pc74
command-line-arguments_MPMCAttach[uintptr]_pc23:
        NOP
        FUNCDATA        $0, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.MPMCAttach[uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.MPMCAttach[uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    BX, CX
        MOVQ    AX, BX
        LEAQ    command-line-arguments..dict.MPMCAttach[uintptr](SB), AX
        PCDATA  $1, $0
        CALL    command-line-arguments.MPMCAttach[go.shape.uintptr](SB)
        ADDQ    $24, SP
        POPQ    BP
        RET
command-line-arguments_MPMCAttach[uintptr]_pc47:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCAttach[uintptr]_pc0
command-line-arguments_MPMCAttach[uintptr]_pc74:
        LEAQ    40(SP), R13
        CMPQ    (R12), R13
        JNE     command-line-arguments_MPMCAttach[uintptr]_pc23
        MOVQ    SP, (R12)
        JMP     command-line-arguments_MPMCAttach[uintptr]_pc23
command-line-arguments_MPMCRing[uintptr]_Dequeue_pc0:
        TEXT    command-line-arguments.(*MPMCRing[uintptr]).Dequeue(SB), DUPOK|WRAPPER|ABIInternal, $24-8
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCRing[uintptr]_Dequeue_pc43
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $16, SP
        MOVQ    32(R14), R12
        TESTQ   R12, R12
        JNE     command-line-arguments_MPMCRing[uintptr]_Dequeue_pc60
command-line-arguments_MPMCRing[uintptr]_Dequeue_pc23:
        NOP
        FUNCDATA        $0, gclocals·wgcWObbY2HYnK2SU/U22lA==(SB)
        FUNCDATA        $1, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $5, command-line-arguments.(*MPMCRing[uintptr]).Dequeue.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.(*MPMCRing[uintptr]).Dequeue.argliveinfo(SB)
        PCDATA  $3, $1
        LEAQ    command-line-arguments..dict.MPMCRing[uintptr](SB), BX
        PCDATA  $1, $1
        NOP
        CALL    command-line-arguments.(*MPMCRing[go.shape.uintptr]).Dequeue(SB)
        ADDQ    $16, SP
        POPQ    BP
        RET
command-line-arguments_MPMCRing[uintptr]_Dequeue_pc43:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCRing[uintptr]_Dequeue_pc0
command-line-arguments_MPMCRing[uintptr]_Dequeue_pc60:
        LEAQ    32(SP), R13
        CMPQ    (R12), R13
        JNE     command-line-arguments_MPMCRing[uintptr]_Dequeue_pc23
        MOVQ    SP, (R12)
        JMP     command-line-arguments_MPMCRing[uintptr]_Dequeue_pc23
command-line-arguments_MPMCRing[uintptr]_Enqueue_pc0:
        TEXT    command-line-arguments.(*MPMCRing[uintptr]).Enqueue(SB), DUPOK|WRAPPER|ABIInternal, $32-16
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCRing[uintptr]_Enqueue_pc44
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $24, SP
        MOVQ    32(R14), R12
        TESTQ   R12, R12
        JNE     command-line-arguments_MPMCRing[uintptr]_Enqueue_pc71
command-line-arguments_MPMCRing[uintptr]_Enqueue_pc23:
        NOP
        FUNCDATA        $0, gclocals·wgcWObbY2HYnK2SU/U22lA==(SB)
        FUNCDATA        $1, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $5, command-line-arguments.(*MPMCRing[uintptr]).Enqueue.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.(*MPMCRing[uintptr]).Enqueue.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    BX, CX
        LEAQ    command-line-arguments..dict.MPMCRing[uintptr](SB), BX
        PCDATA  $1, $1
        CALL    command-line-arguments.(*MPMCRing[go.shape.uintptr]).Enqueue(SB)
        ADDQ    $24, SP
        POPQ    BP
        RET
command-line-arguments_MPMCRing[uintptr]_Enqueue_pc44:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCRing[uintptr]_Enqueue_pc0
command-line-arguments_MPMCRing[uintptr]_Enqueue_pc71:
        LEAQ    40(SP), R13
        CMPQ    (R12), R13
        JNE     command-line-arguments_MPMCRing[uintptr]_Enqueue_pc23
        MOVQ    SP, (R12)
        JMP     command-line-arguments_MPMCRing[uintptr]_Enqueue_pc23
        TEXT    command-line-arguments.MPMCInit[go.shape.uintptr](SB), DUPOK|NOSPLIT|NOFRAME|ABIInternal, $0-24
        FUNCDATA        $0, gclocals·Plqv2ff52JtlYaDd2Rwxbg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.MPMCInit[go.shape.uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.MPMCInit[go.shape.uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    BX, DX
        DECQ    CX
        MOVQ    CX, SI
        SHRQ    $1, CX
        ORQ     CX, SI
        MOVQ    SI, CX
        SHRQ    $2, SI
        ORQ     CX, SI
        MOVQ    SI, CX
        SHRQ    $4, SI
        ORQ     CX, SI
        MOVQ    SI, CX
        SHRQ    $8, SI
        ORQ     CX, SI
        MOVQ    SI, CX
        SHRQ    $16, SI
        ORQ     CX, SI
        MOVQ    SI, CX
        SHRQ    $32, SI
        XCHGL   AX, AX
        MOVQ    (BX), AX
        ORQ     CX, SI
        MOVQ    $2735938947133216139, CX
        CMPQ    AX, CX
        JEQ     command-line-arguments_MPMCInit[go_shape_uintptr]_pc118
        LOCK
        CMPXCHGQ        CX, (BX)
        SETEQ   CL
        NOP
        TESTB   CL, CL
        JEQ     command-line-arguments_MPMCInit[go_shape_uintptr]_pc115
        LEAQ    1(SI), CX
        MOVQ    CX, SI
        XCHGQ   CX, 8(BX)
        XORL    AX, AX
        JMP     command-line-arguments_MPMCInit[go_shape_uintptr]_pc160
command-line-arguments_MPMCInit[go_shape_uintptr]_pc115:
        XORL    AX, AX
        RET
command-line-arguments_MPMCInit[go_shape_uintptr]_pc118:
        XORL    AX, AX
        RET
command-line-arguments_MPMCInit[go_shape_uintptr]_pc121:
        MOVQ    AX, CX
        SHLQ    $7, CX
        LEAQ    (CX)(AX*8), CX
        LEAQ    (CX)(DX*1), CX
        LEAQ    256(CX), CX
        MOVQ    $0, (CX)
        MOVQ    AX, 128(CX)
        INCQ    AX
command-line-arguments_MPMCInit[go_shape_uintptr]_pc160:
        CMPQ    AX, SI
        JCS     command-line-arguments_MPMCInit[go_shape_uintptr]_pc121
        XORL    CX, CX
        XCHGQ   CX, 24(BX)
        XORL    CX, CX
        XCHGQ   CX, 128(BX)
        MOVL    $2, CX
        XCHGQ   CX, 16(BX)
        MOVL    $1, AX
        RET
command-line-arguments_MPMCInit[uintptr]_pc0:
        TEXT    command-line-arguments.MPMCInit[uintptr](SB), DUPOK|WRAPPER|ABIInternal, $32-16
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCInit[uintptr]_pc47
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $24, SP
        MOVQ    32(R14), R12
        TESTQ   R12, R12
        JNE     command-line-arguments_MPMCInit[uintptr]_pc74
command-line-arguments_MPMCInit[uintptr]_pc23:
        NOP
        FUNCDATA        $0, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.MPMCInit[uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.MPMCInit[uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    BX, CX
        MOVQ    AX, BX
        LEAQ    command-line-arguments..dict.MPMCInit[uintptr](SB), AX
        PCDATA  $1, $0
        CALL    command-line-arguments.MPMCInit[go.shape.uintptr](SB)
        ADDQ    $24, SP
        POPQ    BP
        RET
command-line-arguments_MPMCInit[uintptr]_pc47:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCInit[uintptr]_pc0
command-line-arguments_MPMCInit[uintptr]_pc74:
        LEAQ    40(SP), R13
        CMPQ    (R12), R13
        JNE     command-line-arguments_MPMCInit[uintptr]_pc23
        MOVQ    SP, (R12)
        JMP     command-line-arguments_MPMCInit[uintptr]_pc23
        TEXT    command-line-arguments.SizeMPMCRing[go.shape.uintptr](SB), DUPOK|NOSPLIT|NOFRAME|ABIInternal, $0-16
        FUNCDATA        $0, gclocals·Plqv2ff52JtlYaDd2Rwxbg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.SizeMPMCRing[go.shape.uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.SizeMPMCRing[go.shape.uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    BX, CX
        SHLQ    $7, BX
        LEAQ    (BX)(CX*8), AX
        LEAQ    512(AX), AX
        RET
        TEXT    command-line-arguments.SizeMPMCRing[uintptr](SB), DUPOK|NOSPLIT|WRAPPER|NOFRAME|ABIInternal, $0-8
        MOVQ    32(R14), R12
        TESTQ   R12, R12
        JNE     command-line-arguments_SizeMPMCRing[uintptr]_pc29
command-line-arguments_SizeMPMCRing[uintptr]_pc9:
        NOP
        FUNCDATA        $0, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.SizeMPMCRing[uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.SizeMPMCRing[uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        XCHGL   AX, AX
        MOVQ    AX, CX
        SHLQ    $7, AX
        LEAQ    (AX)(CX*8), AX
        LEAQ    512(AX), AX
        NOP
        RET
command-line-arguments_SizeMPMCRing[uintptr]_pc29:
        LEAQ    8(SP), R13
        CMPQ    (R12), R13
        JNE     command-line-arguments_SizeMPMCRing[uintptr]_pc9
        MOVQ    SP, (R12)
        JMP     command-line-arguments_SizeMPMCRing[uintptr]_pc9
