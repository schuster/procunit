#lang racket

(require "../match-line.rkt"
         racket/runtime-path)

(define-runtime-path foobar-prog "foobar.rkt")

(define-values (proc proc-stdout proc-stdin proc-stderr)
  (subprocess #f #f #f (find-executable-path "racket") foobar-prog))

(file-stream-buffer-mode proc-stdin 'none)

(displayln "foo\n" proc-stdin)

(match-port-line proc-stdout
  #;[(timeout 10) (error "failed")]
  ["bar" (displayln "success")]
  [line (displayln line) (error "failed")])
