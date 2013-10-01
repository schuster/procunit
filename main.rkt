#lang racket

(provide match-port-line)

;; ---------------------------------------------------------------------------------------------------

(require (for-syntax syntax/parse))

(define-syntax (match-port-line stx)
  (syntax-parse stx
    ([_ port (~seq (~optional [(timeout timeout-exp) body ...+]
                              #:defaults ([timeout-exp #'#f] [(body 1) (list #'(void))]))
                   match-clauses ...)]
     #'(let ()
         (define line (sync/timeout timeout-exp (read-line-evt port)))
         (if line (match line match-clauses ...) (begin body ...))))))

(module+ test
  (require rackunit)

  (check-true
   (match-port-line (open-input-string "foo")
     ["foo" #t]
     ["bar" #f]))

  (check-true
   (match-port-line (open-input-string "")
     ["foo" #f]
     [(? eof-object?) #t]))

  (define-values (in out) (make-pipe))
  (check-true
   (match-port-line in
     [(timeout 2) #t])))
