(define ($scheme-name)
  "gauche-scheme")

(define ($macroexpand-1 form)
  (macroexpand-1 form))

(define ($macroexpand-all form)
  (macroexpand-all form))

(define ($open-tcp-server port-number port-file handler)
  (let* ((actual-port-number (or port-number (+ 10000 (random-integer 50000))))
         (socket (make-server-socket 'inet actual-port-number ':reuse-addr? #t)))
    (handler actual-port-number socket)))

(define ($tcp-server-accept socket handler)
  (let loop ((cs (socket-accept socket)))
    (call-with-client-socket cs handler)
    (socket-shutdown cs SHUT_RDWR)
    (loop (socket-accept socket))))

(define ($all-package-names)
  (map module-name (all-modules)))

(define (display-to-string val)
  (let ((out (open-output-string)))
    (display val out)
    (get-output-string out)))

(define ($error-description error)
  (string-append
    (apply string-append (error-object-message error)
           ": "
           (map write-to-string (error-object-irritants error)))
    "\n>>Original Message:"
    (report-error error #f)))

(define (symbol->string x)
  (cond ((keyword? x)
         (string-append ":" (keyword->string x)))
        ((symbol? x)
         (r7rs:symbol->string x))
        (else (error "not symbol or keyword" x))))

(define ($output-to-repl thunk)
  ;; basic implementation, print all output at the end, this should
  ;; be replaced with a custom output port
  (let ((o (open-output-string)))
    (parameterize ((current-output-port o))
      (let-values ((x (thunk)))
        (swank/write-string (get-output-string o) #f)
        (apply values x)))))

(define ($function-parameters-and-documentation name)
  (let* ((binding (car (interactive-eval (string->symbol name))))
         (parameters (if (and binding
                              (eq? <procedure> (class-of binding)))
                         (ref binding 'info)
                         #f)))
    (cons parameters #f)))

(define ($set-package name)
  (print name)
  (list "(user)" "(user)"))

(define env (interaction-environment))
(define ($environment name)
  env)

(define ($condition-trace condition)
  '())

(define ($frame-locals-and-catch-tags nr)
  '())

(define ($frame-var-value frame index)
  #f)

(define ($condition-msg condition)
  "UNKNOWN")

(define ($condition-links condition)
  '())

(define ($handle-condition exception)
  #f)

(define (string-match-forward a b)
  (let* ((a-len (string-length a))
         (b-len (string-length b))
         (min-len (min a-len b-len)))
    (let loop ((i 0))
      (if (> i min-len)
          (- i 1)
          (if (string=? (substring a 0 i) (substring b 0 i))
              (loop (+ i 1))
              (- i 1))))))
(define (longest-common-prefix strings)
  (if (null? strings)
      ""
      (fold (lambda (s1 s2) (substring s2 0 (string-match-forward s1 s2))) (car strings) (cdr strings))))
(define ($completions prefix env-name)
  (let ((result '()))
    (define (search m)
      (hash-table-for-each (module-table m)  
                           (lambda (symbol value)
                             (if (string-prefix? prefix (symbol->string symbol))
                                 (set! result (cons (symbol->string symbol) result))))))
    (let ((mod ($environment env-name)))
      (for-each (lambda (m) (for-each search (module-precedence-list m)))
                (module-imports mod))
      (for-each search
                (module-precedence-list mod))
      
      (cons result
            (longest-common-prefix result)))))

(define-record-type <istate>
  (make-istate object parts actions next previous content)
  istate?
  (object istate-object)
  (parts istate-parts)
  (actions istate-actions)
  (next istate-next set-istate-next!)
  (previous istate-previous)
  (content istate-content))

(define ($inspect-fallback object)
  #f)

(define $pretty-print pprint)


(define ($binding-documentation name)
  #f)

(define ($apropos name)
  (let ((result '()))
    (define (search m)
      (hash-table-for-each (module-table m)  
                           (lambda (symbol value)
                             (if (string-contains (symbol->string symbol) name)
                                 (set! result (cons (list symbol ':function #f) result))))))
    (let ((mod (param:environment)))
      (for-each (lambda (m) (for-each search (module-precedence-list m)))
                (module-imports mod))
      (for-each search
                (module-precedence-list mod))
      
      result)))

