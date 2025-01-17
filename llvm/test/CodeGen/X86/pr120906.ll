; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define i32 @PR120906(ptr %p) {
; CHECK-LABEL: PR120906:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $564341309, (%rdi) # imm = 0x21A32A3D
; CHECK-NEXT:    pxor %xmm0, %xmm0
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    paddb %xmm1, %xmm1
; CHECK-NEXT:    paddb %xmm1, %xmm1
; CHECK-NEXT:    pxor %xmm2, %xmm2
; CHECK-NEXT:    pcmpgtb %xmm1, %xmm2
; CHECK-NEXT:    movdqa {{.*#+}} xmm1 = [11,11,11,11,u,u,u,u,u,u,u,u,u,u,u,u]
; CHECK-NEXT:    movdqa %xmm1, %xmm3
; CHECK-NEXT:    paddb %xmm1, %xmm3
; CHECK-NEXT:    pand %xmm2, %xmm3
; CHECK-NEXT:    pandn %xmm1, %xmm2
; CHECK-NEXT:    por %xmm1, %xmm2
; CHECK-NEXT:    por %xmm3, %xmm2
; CHECK-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; CHECK-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[2,3,2,3]
; CHECK-NEXT:    por %xmm2, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,1,1]
; CHECK-NEXT:    por %xmm0, %xmm1
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    retq
  store i32 564341309, ptr %p, align 4
  %load = load i32, ptr %p, align 4
  %broadcast.splatinsert.1 = insertelement <4 x i32> zeroinitializer, i32 %load, i64 0
  %broadcast.splat.1 = shufflevector <4 x i32> %broadcast.splatinsert.1, <4 x i32> zeroinitializer, <4 x i32> zeroinitializer
  %icmp = icmp ugt <4 x i32> %broadcast.splat.1, splat (i32 -9)
  %zext8 = zext <4 x i1> %icmp to <4 x i8>
  %shl = shl <4 x i8> splat (i8 11), %zext8
  %or = or <4 x i8> %shl, splat (i8 11)
  %zext32 = zext <4 x i8> %or to <4 x i32>
  %rdx = tail call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> %zext32)
  ret i32 %rdx
}
