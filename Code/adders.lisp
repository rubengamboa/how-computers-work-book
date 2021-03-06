(include-book "binary-numerals")

(defun and-gate (x y) (if (and (= x 1) (= y 1)) 1 0))
(defun or-gate (x y) (if (or (= x 1) (= y 1)) 1 0)) 
(defun xor-gate (x y) (if (= x y) 0 1))
(defun half-adder (x y) (list (xor-gate x y) (and-gate x y)))
(defun full-adder (c-in x y)
  (let* ((h1 (half-adder x y))
         (s1 (first h1))
         (c1 (second h1))
         (h2 (half-adder s1 c-in))
         (s  (first h2))
         (c2 (second h2))
         (c  (or-gate c1 c2)))
    (list s c)))
(defun chk (n)
  (let* ((bs (twos 3 n))
         (c-in (first bs))
         (x    (second bs))
         (y    (third bs)))
    (equal (twos 2 (+ c-in x y))
           (full-adder c-in x y))))
(defconst *chk-full-adder* ; true iff full-adder model is correct
  (and (chk 0) (chk 1) (chk 2) (chk 3)
       (chk 4) (chk 5) (chk 6) (chk 7)))

(defun adder2 (c0 x y)
  (let* ((x0 (first x))
         (x1 (second x))
         (y0 (first y))
         (y1 (second y))
         (f0 (full-adder c0 x0 y0))
         (s0 (first f0))
         (c1 (second f0))
         (f1 (full-adder c1 x1 y1))
         (s1 (first f1))
         (c2 (second f1)))
    (list (list s0 s1) c2)))
;(defthm adder2-ok ; old form
;  (implies (and (bitp c0) (bitp x0) (bitp y0) (bitp x1) (bitp y1))
;           (let* ((a  (adder2 c0 (list x0 x1) (list y0 y1)))
;                  (ss (first a))
;                  (s0 (first ss))
;                  (s1 (second ss))
;                  (c2 (second a)))
;             (= (num (list s0 s1 c2))
;                (+ (num (list x0 x1)) (num (list y0 y1)) c0)))))
(defthm adder2-ok
  (implies (and (bitp c0) (bitp x0) (bitp x1) (bitp y0) (bitp y1))
           (let* ((a (adder2 c0 (list x0 x1) (list y0 y1)))
                  (s (first a)) (c (second a)))
             (= (num (append s (list c)))
                (+ c0 (num (list x0 x1)) (num (list y0 y1)))))))
(defun adder (c0 x y)
  (if (consp x)
      (let* ((x0 (first x)) (xs (rest x)) (y0 (first y)) (ys (rest y))
             (a0 (full-adder c0 x0 y0)) (s0 (first a0)) (c1 (second a0))
             (a  (adder c1 xs ys)) (ss (first a)) (c (second a)))
        (list (cons s0 ss) c)) ; add1
      (list nil c0)))          ; add0
(defthm adder-ok
  (implies (and (bitp c0) (bit-listp x) (bit-listp y) (= (len x) (len y)))
           (let* ((a (adder c0 x y))
                  (s (first a)) (c (second a)))
             (= (num (append s (list c)))
                (+ c0 (num x) (num y))))))
