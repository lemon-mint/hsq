        TEXT    command-line-arguments.MPMCInit(SB), NOSPLIT|NOFRAME|ABIInternal, $0-16
        FUNCDATA        $0, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.MPMCInit.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.MPMCInit.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    AX, CX
        LEAQ    -1(BX), DX
        MOVQ    DX, BX
        SHRQ    $1, DX
        ORQ     BX, DX
        MOVQ    DX, BX
        SHRQ    $2, DX
        ORQ     BX, DX
        MOVQ    DX, BX
        SHRQ    $4, DX
        ORQ     BX, DX
        MOVQ    DX, BX
        SHRQ    $8, DX
        ORQ     BX, DX
        MOVQ    DX, BX
        SHRQ    $16, DX
        ORQ     BX, DX
        MOVQ    DX, BX
        SHRQ    $32, DX
        XCHGL   AX, AX
        MOVQ    (AX), SI
        ORQ     BX, DX
        MOVQ    $2735938947133216139, BX
        CMPQ    SI, BX
        JEQ     command-line-arguments_MPMCInit_pc120
        MOVQ    AX, DI
        MOVQ    SI, AX
        LOCK
        CMPXCHGQ        BX, (DI)
        SETEQ   BL
        TESTB   BL, BL
        JEQ     command-line-arguments_MPMCInit_pc117
        INCQ    DX
        MOVQ    DX, BX
        XCHGQ   DX, 8(DI)
        XORL    AX, AX
        JMP     command-line-arguments_MPMCInit_pc167
command-line-arguments_MPMCInit_pc117:
        XORL    AX, AX
        RET
command-line-arguments_MPMCInit_pc120:
        XORL    AX, AX
        RET
command-line-arguments_MPMCInit_pc123:
        MOVQ    AX, DX
        SHLQ    $4, DX
        LEAQ    (CX)(DX*1), SI
        LEAQ    256(SI), SI
        XORL    R8, R8
        XCHGQ   R8, (SI)
        LEAQ    (CX)(DX*1), DX
        LEAQ    264(DX), DX
        MOVQ    AX, SI
        XCHGQ   SI, (DX)
        INCQ    AX
command-line-arguments_MPMCInit_pc167:
        CMPQ    AX, BX
        JCS     command-line-arguments_MPMCInit_pc123
        XORL    CX, CX
        XCHGQ   CX, 24(DI)
        XORL    CX, CX
        XCHGQ   CX, 128(DI)
        MOVL    $2, CX
        XCHGQ   CX, 16(DI)
        MOVL    $1, AX
        RET
command-line-arguments_MPMCAttach_pc0:
        TEXT    command-line-arguments.MPMCAttach(SB), ABIInternal, $72-16
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCAttach_pc246
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $64, SP
        FUNCDATA        $0, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $1, gclocals·ShrCR2lbrdPvyLG+AuFYmA==(SB)
        FUNCDATA        $5, command-line-arguments.MPMCAttach.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.MPMCAttach.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    BX, command-line-arguments.timeout+88(SP)
        MOVQ    AX, command-line-arguments.h+80(SP)
        PCDATA  $3, $-1
        PCDATA  $1, $0
        NOP
        CALL    time.Now(SB)
        MOVQ    CX, command-line-arguments..autotmp_17+56(SP)
        MOVQ    BX, command-line-arguments..autotmp_18+40(SP)
        MOVQ    AX, command-line-arguments..autotmp_19+32(SP)
        MOVQ    command-line-arguments.h+80(SP), DX
        MOVQ    DX, SI
        MOVQ    DX, command-line-arguments..autotmp_20+48(SP)
        MOVQ    command-line-arguments.timeout+88(SP), DI
        JMP     command-line-arguments_MPMCAttach_pc119
command-line-arguments_MPMCAttach_pc72:
        PCDATA  $1, $-1
        NOP
        LEAQ    runtime.gosched_m·f(SB), AX
        PCDATA  $1, $1
        CALL    runtime.mcall(SB)
        MOVQ    command-line-arguments.timeout+88(SP), CX
        MOVQ    command-line-arguments..autotmp_20+48(SP), DX
        MOVQ    command-line-arguments..autotmp_19+32(SP), AX
        MOVQ    command-line-arguments..autotmp_17+56(SP), CX
        MOVQ    command-line-arguments..autotmp_18+40(SP), BX
        MOVQ    command-line-arguments.h+80(SP), SI
        MOVQ    command-line-arguments.timeout+88(SP), DI
command-line-arguments_MPMCAttach_pc119:
        MOVQ    (DX), R8
        MOVQ    16(DX), R9
        MOVQ    8(DX), R10
        MOVQ    $2735938947133216139, R11
        CMPQ    R8, R11
        JNE     command-line-arguments_MPMCAttach_pc152
        BTL     $1, R9
        JCS     command-line-arguments_MPMCAttach_pc177
command-line-arguments_MPMCAttach_pc152:
        TESTQ   DI, DI
        JGT     command-line-arguments_MPMCAttach_pc72
        NOP
        CALL    time.Since(SB)
        MOVQ    command-line-arguments.timeout+88(SP), DX
        CMPQ    AX, DX
        JLT     command-line-arguments_MPMCAttach_pc72
        JMP     command-line-arguments_MPMCAttach_pc238
command-line-arguments_MPMCAttach_pc177:
        MOVQ    R10, command-line-arguments.size+24(SP)
        LEAQ    type:command-line-arguments.MPMCRing(SB), AX
        PCDATA  $1, $0
        NOP
        CALL    runtime.newobject(SB)
        MOVQ    command-line-arguments.size+24(SP), CX
        MOVQ    CX, 8(AX)
        DECQ    CX
        MOVQ    CX, (AX)
        MOVQ    command-line-arguments.h+80(SP), CX
        MOVQ    CX, 16(AX)
        ADDQ    $256, CX
        MOVQ    CX, 24(AX)
        ADDQ    $64, SP
        POPQ    BP
        RET
command-line-arguments_MPMCAttach_pc238:
        XORL    AX, AX
        ADDQ    $64, SP
        POPQ    BP
        RET
command-line-arguments_MPMCAttach_pc246:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        MOVQ    BX, 16(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        MOVQ    16(SP), BX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCAttach_pc0
command-line-arguments_MPMCRing_Enqueue_pc0:
        TEXT    command-line-arguments.(*MPMCRing).Enqueue(SB), ABIInternal, $32-16
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCRing_Enqueue_pc163
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $24, SP
        FUNCDATA        $0, gclocals·m/6RUmNv6NBhMUL8eleFFA==(SB)
        FUNCDATA        $1, gclocals·VtCL4RdUwCqwXEPeyJllRA==(SB)
        FUNCDATA        $5, command-line-arguments.(*MPMCRing).Enqueue.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.(*MPMCRing).Enqueue.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    AX, command-line-arguments.m+40(SP)
        MOVQ    BX, command-line-arguments.ptr+48(SP)
        PCDATA  $3, $-1
        MOVQ    16(AX), CX
        MOVQ    CX, command-line-arguments..autotmp_13+16(SP)
        MOVQ    128(CX), DX
        JMP     command-line-arguments_MPMCRing_Enqueue_pc91
command-line-arguments_MPMCRing_Enqueue_pc46:
        MOVQ    DX, command-line-arguments.p+8(SP)
        NOP
        LEAQ    runtime.gosched_m·f(SB), AX
        PCDATA  $1, $1
        CALL    runtime.mcall(SB)
        MOVQ    command-line-arguments..autotmp_13+16(SP), CX
        MOVQ    command-line-arguments.m+40(SP), DX
        MOVQ    command-line-arguments.p+8(SP), BX
        MOVQ    DX, AX
        MOVQ    command-line-arguments.ptr+48(SP), BX
        MOVQ    command-line-arguments.p+8(SP), DX
command-line-arguments_MPMCRing_Enqueue_pc91:
        MOVQ    (AX), SI
        ANDQ    DX, SI
        SHLQ    $4, SI
        ADDQ    24(AX), SI
        MOVQ    8(SI), DI
        CMPQ    DI, DX
        JNE     command-line-arguments_MPMCRing_Enqueue_pc141
        LEAQ    1(DX), DI
        MOVQ    DX, AX
        LOCK
        CMPXCHGQ        DI, 128(CX)
        SETEQ   R9B
        TESTB   R9B, R9B
        JEQ     command-line-arguments_MPMCRing_Enqueue_pc46
        JMP     command-line-arguments_MPMCRing_Enqueue_pc150
command-line-arguments_MPMCRing_Enqueue_pc141:
        MOVQ    128(CX), DX
        JMP     command-line-arguments_MPMCRing_Enqueue_pc46
command-line-arguments_MPMCRing_Enqueue_pc150:
        MOVQ    BX, (SI)
        XCHGQ   DI, 8(SI)
        ADDQ    $24, SP
        POPQ    BP
        RET
command-line-arguments_MPMCRing_Enqueue_pc163:
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
        JMP     command-line-arguments_MPMCRing_Enqueue_pc0
command-line-arguments_MPMCRing_Dequeue_pc0:
        TEXT    command-line-arguments.(*MPMCRing).Dequeue(SB), ABIInternal, $24-8
        CMPQ    SP, 16(R14)
        PCDATA  $0, $-2
        JLS     command-line-arguments_MPMCRing_Dequeue_pc147
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $16, SP
        FUNCDATA        $0, gclocals·wgcWObbY2HYnK2SU/U22lA==(SB)
        FUNCDATA        $1, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $5, command-line-arguments.(*MPMCRing).Dequeue.arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.(*MPMCRing).Dequeue.argliveinfo(SB)
        PCDATA  $3, $1
        MOVQ    16(AX), CX
        MOVQ    24(CX), DX
        JMP     command-line-arguments_MPMCRing_Dequeue_pc31
command-line-arguments_MPMCRing_Dequeue_pc28:
        MOVQ    BX, AX
command-line-arguments_MPMCRing_Dequeue_pc31:
        MOVQ    (AX), SI
        ANDQ    DX, SI
        SHLQ    $4, SI
        ADDQ    24(AX), SI
        MOVQ    8(SI), DI
        SUBQ    DX, DI
        CMPQ    DI, $1
        JNE     command-line-arguments_MPMCRing_Dequeue_pc85
        LEAQ    1(DX), DI
        MOVQ    AX, BX
        MOVQ    DX, AX
        LOCK
        CMPXCHGQ        DI, 24(CX)
        SETEQ   DIB
        TESTB   DIB, DIB
        JEQ     command-line-arguments_MPMCRing_Dequeue_pc28
        JMP     command-line-arguments_MPMCRing_Dequeue_pc103
command-line-arguments_MPMCRing_Dequeue_pc85:
        LEAQ    -1(DI), DX
        TESTQ   DX, DX
        JLS     command-line-arguments_MPMCRing_Dequeue_pc127
        MOVQ    24(CX), DX
        MOVQ    AX, BX
        JMP     command-line-arguments_MPMCRing_Dequeue_pc28
command-line-arguments_MPMCRing_Dequeue_pc103:
        MOVQ    (SI), AX
        MOVQ    (BX), CX
        LEAQ    (DX)(CX*1), CX
        LEAQ    1(CX), CX
        XCHGQ   CX, 8(SI)
        ADDQ    $16, SP
        POPQ    BP
        RET
command-line-arguments_MPMCRing_Dequeue_pc127:
        LEAQ    type:string(SB), AX
        LEAQ    command-line-arguments..stmp_1(SB), BX
        PCDATA  $1, $1
        CALL    runtime.gopanic(SB)
        XCHGL   AX, AX
command-line-arguments_MPMCRing_Dequeue_pc147:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        MOVQ    AX, 8(SP)
        CALL    runtime.morestack_noctxt(SB)
        MOVQ    8(SP), AX
        PCDATA  $0, $-1
        JMP     command-line-arguments_MPMCRing_Dequeue_pc0
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
        JLS     command-line-arguments_Open_pc117
        PCDATA  $0, $-1
        PUSHQ   BP
        MOVQ    SP, BP
        SUBQ    $40, SP
        FUNCDATA        $0, gclocals·J5F+7Qw7O7ve2QcWC7DpeQ==(SB)
        FUNCDATA        $1, gclocals·CnDyI2HjYXFz19SsOj98tw==(SB)
        NOP
        LEAQ    type:uint8(SB), AX
        MOVL    $2560, BX
        MOVQ    BX, CX
        PCDATA  $1, $0
        NOP
        CALL    runtime.makeslice(SB)
        MOVQ    AX, command-line-arguments.bb+24(SP)
        MOVL    $128, BX
        CALL    command-line-arguments.MPMCInit(SB)
        TESTB   AL, AL
        JEQ     command-line-arguments_Open_pc97
        MOVQ    command-line-arguments.bb+24(SP), AX
        XORL    BX, BX
        NOP
        CALL    command-line-arguments.MPMCAttach(SB)
        MOVQ    AX, command-line-arguments.r+32(SP)
        XORL    BX, BX
        PCDATA  $1, $1
        CALL    command-line-arguments.(*MPMCRing).Enqueue(SB)
        MOVQ    command-line-arguments.r+32(SP), AX
        PCDATA  $1, $0
        CALL    command-line-arguments.(*MPMCRing).Dequeue(SB)
        ADDQ    $40, SP
        POPQ    BP
        RET
command-line-arguments_Open_pc97:
        LEAQ    type:string(SB), AX
        LEAQ    command-line-arguments..stmp_2(SB), BX
        CALL    runtime.gopanic(SB)
        XCHGL   AX, AX
command-line-arguments_Open_pc117:
        NOP
        PCDATA  $1, $-1
        PCDATA  $0, $-2
        CALL    runtime.morestack_noctxt(SB)
        PCDATA  $0, $-1
        JMP     command-line-arguments_Open_pc0
        TEXT    command-line-arguments.SizeMPMCRing[go.shape.uintptr](SB), DUPOK|NOSPLIT|NOFRAME|ABIInternal, $0-16
        FUNCDATA        $0, gclocals·Plqv2ff52JtlYaDd2Rwxbg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.SizeMPMCRing[go.shape.uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.SizeMPMCRing[go.shape.uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        SHLQ    $4, BX
        LEAQ    512(BX), AX
        RET
        TEXT    command-line-arguments.SizeMPMCRing[uintptr](SB), DUPOK|NOSPLIT|WRAPPER|NOFRAME|ABIInternal, $0-8
        MOVQ    32(R14), R12
        TESTQ   R12, R12
        JNE     command-line-arguments_SizeMPMCRing[uintptr]_pc21
command-line-arguments_SizeMPMCRing[uintptr]_pc9:
        NOP
        FUNCDATA        $0, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $1, gclocals·g2BeySu+wFnoycgXfElmcg==(SB)
        FUNCDATA        $5, command-line-arguments.SizeMPMCRing[uintptr].arginfo1(SB)
        FUNCDATA        $6, command-line-arguments.SizeMPMCRing[uintptr].argliveinfo(SB)
        PCDATA  $3, $1
        XCHGL   AX, AX
        SHLQ    $4, AX
        ADDQ    $512, AX
        NOP
        RET
command-line-arguments_SizeMPMCRing[uintptr]_pc21:
        LEAQ    8(SP), R13
        NOP
        CMPQ    (R12), R13
        JNE     command-line-arguments_SizeMPMCRing[uintptr]_pc9
        MOVQ    SP, (R12)
        JMP     command-line-arguments_SizeMPMCRing[uintptr]_pc9
