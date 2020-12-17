#lang racket

(require racket/vector)

"Hello, Dec 17th"

; starting state
; example
; .#.
; ..#
; ###
; (define input #(#(
;     #(0 1 0)
;     #(0 0 1)
;     #(1 1 1)
; )))
; .#.####.
; .#...##.
; ..###.##
; #..#.#.#
; #..#....
; #.####..
; ##.##..#
; #.#.#..#
(define input #(#(
    #(0 1 0 1 1 1 1 0)
    #(0 1 0 0 0 1 1 0)
    #(0 0 1 1 1 0 1 1)
    #(1 0 0 1 0 1 0 1)
    #(1 0 0 1 0 0 0 0)
    #(1 0 1 1 1 1 0 0)
    #(1 1 0 1 1 0 0 1)
    #(1 0 1 0 1 0 0 1)
)))

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

; get a value in three dimensions
(define (get-value-3d x y z cube)
    (if (not (valid-coord-3d x y z cube)) 0
        (vector-ref (vector-ref (vector-ref cube z) y) x)
    )
)

; get a value in a given 2d vector
(define (get-value-2d x y plane)
    ; (printf "val: ~a,~a\n" x y)
    (if (not (valid-coord-2d x y plane)) 0
        (vector-ref (vector-ref plane y) x)
    )
)

; sum neighbours in 3d
(define (sum-neighbors-3d x y z cube)
    (apply + (for/list ([i (range (- z 1) (+ z 2))])
        (apply + (for/list ([j (range (- y 1) (+ y 2))])
            (apply + (for/list ([k (range (- x 1) (+ x 2))])
                (if (and (equal? x k) (equal? y j) (equal? z i)) 0
                    (get-value-3d k j i cube)
                )
            ))
        ))
    ))
)

; take the sum of all elements surrounding (x,y)
(define (sum-neighbors-2d x y plane)
    (apply + (for/list ([i (range (- y 1) (+ y 2))])
        (apply + (for/list ([j (range (- x 1) (+ x 2))])
            (if (and (equal? x j) (equal? y i)) 0
                (get-value-2d j i plane)
            )
    ))))
)


; next-value in three dimensions
(define (next-value-3d x y z cube)
    (let ([count (sum-neighbors-3d x y z cube)] [cur (get-value-3d x y z cube)])
    (if (= cur 1)
        (if (or (= count 3) (= count 2)) 1 0)
        (if (= count 3) 1 0)
    ))
)

; next-value for a 2d plane
(define (next-value-2d x y plane)
    (let ([count (sum-neighbors-2d x y plane)] [cur (get-value-2d x y plane)])
    (if (= cur 1)
        (if (or (= count 3) (= count 2)) 1 0)
        (if (= count 3) 1 0)
    ))
)

; apply a single cycle to the board
(define (cycle-board-3d b)
    (let ([w (vector-length (vector-ref (vector-ref b 0) 0))] 
            [h (vector-length (vector-ref b 0))] 
            [d (vector-length b)])
        (for/vector ([i (range 0 (+ d 2))])
            (for/vector ([j (range 0 (+ h 2))])
                (build-vector (+ w 2) (lambda (k) (next-value-3d (- k 1) (- j 1) (- i 1) b)))
            )
        )
    )
)

; apply a single cycle to the board
(define (cycle-board-2d b)
    (let ([w (vector-length (vector-ref b 0))] [h (vector-length b)])
        (for/vector ([i (range 0 (+ h 2))])
            (build-vector (+ w 2) (lambda (j) (next-value-2d (- j 1) i b)))
        )
    )
)

; print a three dimensional board
(define (display-board-3d b)
    (for ([z (range 0 (vector-length b))]) 
        (display-board-2d z (vector-ref b z))))

(define (display-board-2d z b)
    (printf "\nz:~a\n" z)
    (for ([line b]) (displayln line)))

; n-dimensional counting
(define (count v)
    (if (vector? (vector-ref v 0)) (count (vector-map count v))
    (apply + (vector->list v)))
)

; apply changes
(define (run-3d n b)
    (if (= n 0) b
        (run-3d (- n 1) (cycle-board-3d b))
    )
)

; (display-board-3d (run-3d 1 input))
(displayln (count (run-3d 6 input)))