(module test-runner
 (
  filter-by compiled src-and-test-files begin-testing
 )

(import chicken scheme)
(use test posix srfi-1 srfi-13)

(define filter-by (make-parameter ""))
(define compiled (make-parameter #f))
(define src-and-test-files (make-parameter '()))

(define (run-tests test-files suffix)
  (map (lambda (files)
         (load (string-append (car files) suffix))
         (load (string-append (cadr files) ".scm")))
       test-files))

(define (test-filter test-files filter-by)
  (filter (lambda (files) (string-contains (car files) filter-by)) test-files))

(define (begin-testing)
  (test-begin "all")
  (run-tests
   (test-filter
    (src-and-test-files)
    (filter-by))
   (if (compiled) "" ".scm"))
  (test-end "all")
  )
)
