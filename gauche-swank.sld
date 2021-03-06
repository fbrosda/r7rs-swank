(define-library (gauche-swank)
  (export start-swank
          swank:lookup-presented-object
          swank:lookup-presented-object-or-lose)
  (import (gauche base)
          (gauche pputil)
          (except (scheme base) symbol->string)
          (rename (scheme base) (symbol->string r7rs:symbol->string))
          (scheme eval) 
          (scheme read) 
          (scheme write) 
          (scheme file) 
          (scheme case-lambda) 
          (scheme process-context) 
          (scheme repl) 
          (scheme char) 
          (scheme cxr)
          (srfi-69)
          (srfi-27)
          (only (gauche net) make-server-socket socket-accept socket-shutdown call-with-client-socket SHUT_RDWR)
          (only (srfi-13) string-contains string-prefix? string-replace)
          (only (srfi-1) find fold list-index cons* filter))

  (include "specific/gauche.scm")
  (include "common/base.scm")
  (include "common/handlers.scm"))
