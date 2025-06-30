  .text
  .globl set_a
  .type set_a, @function
set_a:
.bb_0:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  sw a0, 4(sp)
  la t0, a
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, a
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
  .globl set_b
  .type set_b, @function
set_b:
.bb_2:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  sw a0, 4(sp)
  la t0, b
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, b
  lw t0, 0(t0)
  mv a0, t0
  j .bb_3
  j .bb_3
.bb_3:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
  .globl set_d
  .type set_d, @function
set_d:
.bb_4:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  sw a0, 4(sp)
  la t0, d
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, d
  lw t0, 0(t0)
  mv a0, t0
  j .bb_5
  j .bb_5
.bb_5:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
  .globl main
  .type main, @function
main:
.bb_6:
  mv t1, sp
  addi sp, sp, -32
  sw ra, 0(sp)
  la t0, a
  sw t0, 4(sp)
  li t0, 2
  lw t1, 4(sp)
  sw t0, 0(t1)
  la t0, b
  sw t0, 4(sp)
  li t0, 3
  lw t1, 4(sp)
  sw t0, 0(t1)
  li t0, 0
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal set_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 4(sp)
  li t0, 0
  lw t1, 4(sp)
  bne t1, t0, .bb_8
  j .bb_9
.bb_7:
  lw ra, 0(sp)
  addi sp, sp, 32
  ret
.bb_8:
  li t0, 1
  j .bb_10
.bb_9:
  li t0, 0
  j .bb_10
.bb_10:
  bne t0, zero, .bb_11
  j .bb_13
.bb_11:
  li t0, 1
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal set_b
  addi sp, sp, 0
  mv t0, a0
  sw t0, 4(sp)
  li t0, 0
  lw t1, 4(sp)
  bne t1, t0, .bb_15
  j .bb_16
.bb_12:
  ori t0, zero, 1
  j .bb_14
.bb_13:
  mv t0, zero
  j .bb_14
.bb_14:
  bne t0, zero, .bb_18
  j .bb_19
.bb_15:
  li t0, 1
  j .bb_17
.bb_16:
  li t0, 0
  j .bb_17
.bb_17:
  bne t0, zero, .bb_12
  j .bb_13
.bb_18:
  j .bb_19
.bb_19:
  la t0, a
  lw t0, 0(t0)
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 32
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  la t0, b
  lw t0, 0(t0)
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 32
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  la t0, a
  sw t0, 4(sp)
  li t0, 2
  lw t1, 4(sp)
  sw t0, 0(t1)
  la t0, b
  sw t0, 4(sp)
  li t0, 3
  lw t1, 4(sp)
  sw t0, 0(t1)
  li t0, 0
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal set_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 4(sp)
  li t0, 0
  lw t1, 4(sp)
  bne t1, t0, .bb_20
  j .bb_21
.bb_20:
  li t0, 1
  j .bb_22
.bb_21:
  li t0, 0
  j .bb_22
.bb_22:
  bne t0, zero, .bb_23
  j .bb_25
.bb_23:
  li t0, 1
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal set_b
  addi sp, sp, 0
  mv t0, a0
  sw t0, 4(sp)
  li t0, 0
  lw t1, 4(sp)
  bne t1, t0, .bb_27
  j .bb_28
.bb_24:
  ori t0, zero, 1
  j .bb_26
.bb_25:
  mv t0, zero
  j .bb_26
.bb_26:
  bne t0, zero, .bb_30
  j .bb_31
.bb_27:
  li t0, 1
  j .bb_29
.bb_28:
  li t0, 0
  j .bb_29
.bb_29:
  bne t0, zero, .bb_24
  j .bb_25
.bb_30:
  j .bb_31
.bb_31:
  la t0, a
  lw t0, 0(t0)
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 32
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  la t0, b
  lw t0, 0(t0)
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 10
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  li t1, 4
  add t1, t1, sp
  li t0, 1
  sw t0, 0(t1)
  la t0, d
  sw t0, 8(sp)
  li t0, 2
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  bge t1, t0, .bb_32
  j .bb_33
.bb_32:
  li t0, 1
  j .bb_34
.bb_33:
  li t0, 0
  j .bb_34
.bb_34:
  bne t0, zero, .bb_35
  j .bb_37
.bb_35:
  li t0, 3
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal set_d
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_39
  j .bb_40
.bb_36:
  ori t0, zero, 1
  j .bb_38
.bb_37:
  mv t0, zero
  j .bb_38
.bb_38:
  bne t0, zero, .bb_42
  j .bb_43
.bb_39:
  li t0, 1
  j .bb_41
.bb_40:
  li t0, 0
  j .bb_41
.bb_41:
  bne t0, zero, .bb_36
  j .bb_37
.bb_42:
  j .bb_43
.bb_43:
  la t0, d
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 32
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  blt t0, t1, .bb_45
  j .bb_44
.bb_44:
  li t0, 1
  j .bb_46
.bb_45:
  li t0, 0
  j .bb_46
.bb_46:
  beq t0, zero, .bb_47
  j .bb_48
.bb_47:
  li t0, 4
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal set_d
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_51
  j .bb_52
.bb_48:
  ori t0, zero, 1
  j .bb_50
.bb_49:
  mv t0, zero
  j .bb_50
.bb_50:
  bne t0, zero, .bb_54
  j .bb_55
.bb_51:
  li t0, 1
  j .bb_53
.bb_52:
  li t0, 0
  j .bb_53
.bb_53:
  beq t0, zero, .bb_49
  j .bb_48
.bb_54:
  j .bb_55
.bb_55:
  la t0, d
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 10
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  li t0, 16
  sw t0, 8(sp)
  li t0, 3
  sw t0, 12(sp)
  li t0, 2
  sw t0, 16(sp)
  li t0, 1
  lw t1, 16(sp)
  add t0, t1, t0
  lw t1, 12(sp)
  sub t0, t1, t0
  lw t1, 8(sp)
  bge t1, t0, .bb_56
  j .bb_57
.bb_56:
  li t0, 1
  j .bb_58
.bb_57:
  li t0, 0
  j .bb_58
.bb_58:
  bne t0, zero, .bb_59
  j .bb_60
.bb_59:
  li t0, 65
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_60
.bb_60:
  li t0, 25
  sw t0, 8(sp)
  li t0, 7
  lw t1, 8(sp)
  sub t0, t1, t0
  sw t0, 8(sp)
  li t0, 36
  sw t0, 12(sp)
  li t0, 6
  sw t0, 16(sp)
  li t0, 3
  lw t1, 16(sp)
  mul t0, t1, t0
  lw t1, 12(sp)
  sub t0, t1, t0
  lw t1, 8(sp)
  bne t1, t0, .bb_61
  j .bb_62
.bb_61:
  li t0, 1
  j .bb_63
.bb_62:
  li t0, 0
  j .bb_63
.bb_63:
  bne t0, zero, .bb_64
  j .bb_65
.bb_64:
  li t0, 66
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_65
.bb_65:
  li t0, 1
  sw t0, 8(sp)
  li t0, 8
  lw t1, 8(sp)
  bge t1, t0, .bb_67
  j .bb_66
.bb_66:
  li t0, 1
  j .bb_68
.bb_67:
  li t0, 0
  j .bb_68
.bb_68:
  sw t0, 8(sp)
  li t0, 7
  sw t0, 12(sp)
  li t0, 2
  lw t1, 12(sp)
  rem t0, t1, t0
  lw t1, 8(sp)
  bne t1, t0, .bb_69
  j .bb_70
.bb_69:
  li t0, 1
  j .bb_71
.bb_70:
  li t0, 0
  j .bb_71
.bb_71:
  bne t0, zero, .bb_72
  j .bb_73
.bb_72:
  li t0, 67
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_73
.bb_73:
  li t0, 3
  sw t0, 8(sp)
  li t0, 4
  lw t1, 8(sp)
  blt t0, t1, .bb_74
  j .bb_75
.bb_74:
  li t0, 1
  j .bb_76
.bb_75:
  li t0, 0
  j .bb_76
.bb_76:
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  beq t1, t0, .bb_77
  j .bb_78
.bb_77:
  li t0, 1
  j .bb_79
.bb_78:
  li t0, 0
  j .bb_79
.bb_79:
  bne t0, zero, .bb_80
  j .bb_81
.bb_80:
  li t0, 68
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_81
.bb_81:
  li t0, 5
  sw t0, 8(sp)
  li t0, 6
  lw t1, 8(sp)
  sub t0, t1, t0
  sw t0, 8(sp)
  li t0, -1
  lw t1, 8(sp)
  beq t1, t0, .bb_82
  j .bb_83
.bb_82:
  li t0, 1
  j .bb_84
.bb_83:
  li t0, 0
  j .bb_84
.bb_84:
  bne t0, zero, .bb_85
  j .bb_86
.bb_85:
  li t0, 69
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_86
.bb_86:
  li t0, 10
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  li t0, 0
  li t1, 8
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 1
  li t1, 12
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 2
  li t1, 16
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 3
  li t1, 20
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  li t1, 24
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bge t1, t0, .bb_87
  j .bb_88
.bb_87:
  li t0, 1
  j .bb_89
.bb_88:
  li t0, 0
  j .bb_89
.bb_89:
  beq t0, zero, .bb_90
  j .bb_91
.bb_90:
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  blt t0, t1, .bb_95
  j .bb_94
.bb_91:
  ori t0, zero, 1
  j .bb_93
.bb_92:
  mv t0, zero
  j .bb_93
.bb_93:
  bne t0, zero, .bb_97
  j .bb_98
.bb_94:
  li t0, 1
  j .bb_96
.bb_95:
  li t0, 0
  j .bb_96
.bb_96:
  beq t0, zero, .bb_92
  j .bb_91
.bb_97:
  li t0, 72
  sw t0, 28(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 28(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_98
.bb_98:
  li t0, 16
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bge t1, t0, .bb_99
  j .bb_100
.bb_99:
  li t0, 1
  j .bb_101
.bb_100:
  li t0, 0
  j .bb_101
.bb_101:
  bne t0, zero, .bb_102
  j .bb_104
.bb_102:
  li t0, 24
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bne t1, t0, .bb_106
  j .bb_107
.bb_103:
  ori t0, zero, 1
  j .bb_105
.bb_104:
  mv t0, zero
  j .bb_105
.bb_105:
  bne t0, zero, .bb_109
  j .bb_110
.bb_106:
  li t0, 1
  j .bb_108
.bb_107:
  li t0, 0
  j .bb_108
.bb_108:
  bne t0, zero, .bb_103
  j .bb_104
.bb_109:
  li t0, 73
  sw t0, 28(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 28(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_110
.bb_110:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  slt t1, t0, zero
  slt t2, zero, t0
  and t0, t1, t2
  lw t1, 28(sp)
  beq t1, t0, .bb_111
  j .bb_112
.bb_111:
  li t0, 1
  j .bb_113
.bb_112:
  li t0, 0
  j .bb_113
.bb_113:
  bne t0, zero, .bb_114
  j .bb_116
.bb_114:
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bge t1, t0, .bb_119
  j .bb_118
.bb_115:
  ori t0, zero, 1
  j .bb_117
.bb_116:
  mv t0, zero
  j .bb_117
.bb_117:
  beq t0, zero, .bb_121
  j .bb_122
.bb_118:
  li t0, 1
  j .bb_120
.bb_119:
  li t0, 0
  j .bb_120
.bb_120:
  bne t0, zero, .bb_115
  j .bb_116
.bb_121:
  li t0, 24
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 24
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bge t1, t0, .bb_125
  j .bb_126
.bb_122:
  ori t0, zero, 1
  j .bb_124
.bb_123:
  mv t0, zero
  j .bb_124
.bb_124:
  bne t0, zero, .bb_128
  j .bb_129
.bb_125:
  li t0, 1
  j .bb_127
.bb_126:
  li t0, 0
  j .bb_127
.bb_127:
  beq t0, zero, .bb_123
  j .bb_122
.bb_128:
  li t0, 74
  sw t0, 28(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 28(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_129
.bb_129:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  slt t1, t0, zero
  slt t2, zero, t0
  and t0, t1, t2
  lw t1, 28(sp)
  beq t1, t0, .bb_130
  j .bb_131
.bb_130:
  li t0, 1
  j .bb_132
.bb_131:
  li t0, 0
  j .bb_132
.bb_132:
  beq t0, zero, .bb_133
  j .bb_134
.bb_133:
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bge t1, t0, .bb_138
  j .bb_137
.bb_134:
  ori t0, zero, 1
  j .bb_136
.bb_135:
  mv t0, zero
  j .bb_136
.bb_136:
  bne t0, zero, .bb_147
  j .bb_148
.bb_137:
  li t0, 1
  j .bb_139
.bb_138:
  li t0, 0
  j .bb_139
.bb_139:
  bne t0, zero, .bb_140
  j .bb_142
.bb_140:
  li t0, 24
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 24
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  bge t1, t0, .bb_144
  j .bb_145
.bb_141:
  ori t0, zero, 1
  j .bb_143
.bb_142:
  mv t0, zero
  j .bb_143
.bb_143:
  beq t0, zero, .bb_135
  j .bb_134
.bb_144:
  li t0, 1
  j .bb_146
.bb_145:
  li t0, 0
  j .bb_146
.bb_146:
  bne t0, zero, .bb_141
  j .bb_142
.bb_147:
  li t0, 75
  sw t0, 28(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 28(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  j .bb_148
.bb_148:
  li t0, 10
  sw t0, 28(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 28(t1)
  jal print_char
  addi sp, sp, 0
  mv t0, zero
  li t0, 0
  mv a0, t0
  j .bb_7
  j .bb_7


  .data
  .type a, @object
  .size a, 4
a:
  .word 0
  .type b, @object
  .size b, 4
b:
  .word 0
  .type d, @object
  .size d, 4
d:
  .word 0

