(define-library (gauche-swank)
  (export start-swank
          swank:lookup-presented-object
          swank:lookup-presented-object-or-lose)
  (import (except (scheme base) symbol->string)
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
          (only (gauche base)
                keyword? keyword->string module-name all-modules module-table module-imports module-precedence-list ref <procedure> class-of
                macroexpand-1 macroexpand-all hash-table-for-each)
          (only (gauche net) make-server-socket socket-accept socket-input-port socket-output-port)
          (gauche pputil)
          (only (srfi-13) string-contains string-prefix? string-replace)
          (only (srfi-1) find fold list-index cons* filter))

  (include "specific/gauche.scm")
  (include "common/base.scm")
  (include "common/handlers.scm"))
