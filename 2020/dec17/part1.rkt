#lang racket

(require racket/vector)

"Hello, Dec 17th"

; starting state
(define input #(
    #(0 1 0)
    #(0 0 1)
    #(1 1 1)
))

; check whether the coordinate is valid in the given 2d vector
(define (valid-coord-2d x y plane)
    (and
        (and (> y -1) (< y (vector-length plane)))
        (and (> x -1) (< x (vector-length (vector-ref plane 0))))
    )
)

; get a value in a given 2d vector
(define (get-value-2d x y plane)
    ; (printf "val: ~a,~a\n" x y)
    (if (not (valid-coord-2d x y plane)) 0
        (vector-ref (vector-ref plane y) x)
    )
)

(define (sum-neighbors-2d x y plane)
    (apply + (for/list ([i (range (- y 1) (+ y 2))])
        (apply + (for/list ([j (range (- x 1) (+ x 2))])
            (if (and (equal? x j) (equal? y i)) 0
                (get-value-2d j i plane)
            )
    ))))
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
(define (cycle-board-2d b)
    (let ([w (vector-length (vector-ref b 0))] [h (vector-length b)])
        (for/vector ([i (range 0 (+ h 2))])
            (build-vector (+ w 2) (lambda (j) (next-value-2d (- j 1) i b)))
        )
    )
)

; print a two dimensional board
(define (display-board b)
    (for ([line b]) (displayln line)))

; print the state of the board
(displayln "Start:")
(display-board input)

; n-dimensional counting
(define (count v)
    (if (vector? (vector-ref v 0)) (count (vector-map count v))
    (apply + (vector->list v)))
)

; apply changes

; new board
(displayln "cycle 1")
(display-board (cycle-board-2d input))