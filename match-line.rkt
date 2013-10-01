#lang racket

(provide match-port-line)

;; ---------------------------------------------------------------------------------------------------

(require (for-syntax syntax/parse))

#|
Cases:
1. it's a string
2. EOF
3. closed (throw exception)
4. timeout

Changes to make:
* write match-line macro/function
* write a branch for timeout (specified as other timeout things are, so I guess in seconds)
|#

(define-syntax (match-port-line stx)
  (syntax-parse stx
    ([_ port clauses ...]
     #'(let ()
         (define line (sync (read-line-evt port)))
         (match line clauses ...)))))

(module+ test
  (require rackunit)

  (check-true
   (match-port-line (open-input-string "foo")
     ["foo" #t]
     ["bar" #f]))

  (check-true
   (match-port-line (open-input-string "")
     ["foo" #f]
     [(? eof-object?) #t])))

#;(match-port-line port
                 clause ...)

#;(define line (sync/timeout t (read-line-evt port)))
#;(cond [line
       (match line
         clouses-except-timeout ...
         )]
      [else timeout-clause])
