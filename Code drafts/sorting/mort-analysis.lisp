(include-book "doublecheck" :dir :teachpacks)
(defun log2 (n)
  (if (posp (- n 2))
      (1+ (log2 (floor n 2)))
      0))
(defun S (n)
  (if (posp (- n 1))
      (+ (S (floor (+ n 1) n))      ; {S2}
         (S (floor n 2))
         (* 23 n)
         51)
      3))                           ; {S1}
(defun S-diff (n)
  (- (* 40 n (log2 n))
     (S n)))
(defproperty S-diff-positive
  (n :value (random-natural))
  (> (S-diff (+ n 6)) 0))
(defun n-to-0 (n) ; (n n-1 n-2 ... 1)
  (if (zp n)
      (list 0)
      (cons n (n-to-0 (1- n)))))
(defun list-diffs (ns)
  (if (consp ns)
      (cons (S-diff (+ (car ns) 6))
            (list-diffs (cdr ns)))
      nil))
(defun list-base-cases ()
  (list-diffs (n-to-0 44)))
(defun all-positive? (xs)
  (or (not (consp xs))
      (and (> (car xs) 0) (all-positive? (cdr xs)))))
(defproperty all-base-cases
  () ; no data needed
  (all-positive? (list-base-cases)))