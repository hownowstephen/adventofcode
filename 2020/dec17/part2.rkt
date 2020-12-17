#lang racket

(require racket/vector)

"Hello, Dec 17th part II"

(define sampleinput #(#(#(
    #(0 1 0)
    #(0 0 1)
    #(1 1 1)
))))

(define input #(#(#(
    #(0 1 0 1 1 1 1 0)
    #(0 1 0 0 0 1 1 0)
    #(0 0 1 1 1 0 1 1)
    #(1 0 0 1 0 1 0 1)
    #(1 0 0 1 0 0 0 0)
    #(1 0 1 1 1 1 0 0)
    #(1 1 0 1 1 0 0 1)
    #(1 0 1 0 1 0 0 1)
))))

; validate a coordinate in four dimensions
(define (valid-coord-4d x y z q hype)
    (and 
        (and (> q -1) (< q (vector-length hype)))
        (valid-coord-3d x y z (vector-ref hype 0))
    )
)

; validate a coordinate in three dimensions
(define (valid-coord-3d x y z cube)
    (and 
        (and (> z -1) (< z (vector-length cube)))
        (valid-coord-2d x y (vector-ref cube 0))
    )
)

; check whether the coordinate is valid in the given 2d vector
(define (valid-coord-2d x y plane)
    (and
        (and (> y -1) (< y (vector-length plane)))
        (and (> x -1) (< x (vector-length (vector-ref plane 0))))
    )
)

; get a value in four dimensions
(define (get-value-4d x y z q hype)
    (if (not (valid-coord-4d x y z q hype)) 0
        (vector-ref (vector-ref (vector-ref (vector-ref hype q) z) y) x)
    )
)

; sum neighbours in 4d
(define (sum-neighbors-4d x y z q hype)
    (apply + (for/list ([i (range (- q 1) (+ q 2))])
        (apply + (for/list ([j (range (- z 1) (+ z 2))])
            (apply + (for/list ([k (range (- y 1) (+ y 2))])
                (apply + (for/list ([l (range (- x 1) (+ x 2))])
                    (if (and (equal? x l) (equal? y k) (equal? z j) (equal? q i)) 0
                        (get-value-4d l k j i hype)
                    )
                ))
            ))
        ))
    ))
)

; next-value in 4d
(define (next-value-4d x y z q hype)
    (let ([count (sum-neighbors-4d x y z q hype)] [cur (get-value-4d x y z q hype)])
    (if (= cur 1)
        (if (or (= count 3) (= count 2)) 1 0)
        (if (= count 3) 1 0)
    ))
)

; apply a single cycle to a 4d board
(define (cycle-board-4d b)
    (let (  [w (vector-length (vector-ref (vector-ref (vector-ref b 0) 0) 0))] 
            [h (vector-length (vector-ref (vector-ref b 0) 0))] 
            [d (vector-length (vector-ref b 0))] 
            [q (vector-length b)])
        (for/vector ([i (range 0 (+ q 2))])
            (for/vector ([j (range 0 (+ d 2))])
                (for/vector ([k (range 0 (+ h 2))])
                    (build-vector (+ w 2) (lambda (l) (next-value-4d (- l 1) (- k 1) (- j 1) (- i 1) b)))
                )
            )
        )
    )
)

; n-dimensional counting
(define (count v)
    (if (vector? (vector-ref v 0)) (count (vector-map count v))
    (apply + (vector->list v)))
)

; apply changes
(define (run-4d n b)
    (if (= n 0) b
        (run-4d (- n 1) (cycle-board-4d b))
    )
)

(displayln (count (run-4d 6 input)))