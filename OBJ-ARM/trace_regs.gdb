target remote :1234
set pagination off
set confirm off

# ログ
set logging file gdb_info.log
set logging overwrite on
set logging on

# 未定義命令例外の入口（必ず最初に通る）
b *0x0100d424
commands
  silent
  printf "\n[UNDEF ENTRY] pc=%08x lr=%08x sp=%08x cpsr=%08x\n", $pc, $lr, $sp, $cpsr
  x/6i $pc
  bt
  continue
end

# default handler
b *0x0100cea8
commands
  silent
  printf "\n[DEFAULT EXC] r0(p_excinf)=%08x excno=%u lr=%08x sp=%08x cpsr=%08x\n", $r0, $r1, $lr, $sp, $cpsr
  bt
  continue
end

# 強制終了経路
b *0x0100978c
commands
  silent
  printf "\n[EXT_KER] pc=%08x lr=%08x sp=%08x cpsr=%08x\n", $pc, $lr, $sp, $cpsr
  bt
  continue
end

# dispatch_r entry
b *0x0100b1c0
commands
  silent
  # popで復帰するpcは [sp+32]
  set $retpc = *(unsigned int*)($sp + 32)
  if ($retpc < 0x01000000 || $retpc >= 0x01100000)
    printf "\n[BAD POP PC] sp=%08x retpc=%08x lr=%08x cpsr=%08x r4=%08x\n", $sp, $retpc, $lr, $cpsr, $r4
    x/12wx $sp
    bt
    quit
  end
  continue
end

# dispatch()で対象タスクのコンテキスト保存直後を捕まえる
b *0x0100b1b4
commands
  silent
  if ($r0 == 0x01801370)
    set $slot = $sp + 32
    printf "\n[SAVE CTX] tcb=%08x sp=%08x slot=%08x retpc=%08x\n", $r0, $sp, $slot, *(unsigned int*)$slot
    awatch *(unsigned int*)$slot
  end
  continue
end

b *0x0100b1ac
commands
  silent
  if ($r0 == 0x01801370)
    if ($lr < 0x01000000 || $lr >= 0x01100000)
      printf "\n[BAD LR BEFORE SAVE] pc=%08x lr=%08x sp=%08x r0(tcb)=%08x cpsr=%08x\n", $pc, $lr, $sp, $r0, $cpsr
      x/12wx $sp
      bt
      quit
    end
  end
  continue
end

continue
