  .global _start

_start:
  lw x2, 4(x0)

  sb x2, 32(x0)
  sh x2, 48(x0)
  sw x2, 64(x0)
  