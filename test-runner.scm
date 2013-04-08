#!/usr/bin/csi -script
;; -*- scheme -*-

; to use create a scheme file that defines src-and-test-files
; then run test-runner tests.scm
;
; src-and-test-files needs to return a list of of source files
; and corresponding test-files
; ex. '(("lib/foo" "tests/foo"))
;
; define tests in a file for each source file
; the source file will be loaded before the test file is run
; the test file needs to import the module definitions from
; the loaded source file

(use test posix srfi-13 srfi-1 easy-args)

(load (car (command-line-arguments)))

(define-arguments
  ((filter-by f) "")
  ((compiled c) #f))

(define (run-tests test-files suffix)
  (map (lambda (files)
         (load (string-append (car files) suffix))
         (load (string-append (cadr files) ".scm")))
       test-files))

(define (test-filter test-files filter-by)
  (filter (lambda (files) (string-contains (car files) filter-by)) test-files))

(test-begin "all")
(run-tests
 (test-filter
  (src-and-test-files) ; test-starter must export this
  (filter-by))
 (if (compiled) "" ".scm"))
(test-end "all")
