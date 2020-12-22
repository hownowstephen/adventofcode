(module

    (memory $0 2)
    (data (i32.const 4096) "Hello, Part 1!\00") ;; gotta have it, even though it's not being printed

    ;; get head ptr address
    (func $head (param $id i32) (result i32)
        (i32.mul (get_local $id) (i32.const 8))
    )

    ;; get tail ptr address
    (func $tail (param $id i32) (result i32)
        (i32.add (i32.mul (get_local $id) (i32.const 8)) (i32.const 4))
    )

    ;; Decks are laid out in memory like
    ;; [n][n+1] are start and end pointers
    ;; [n*1024 + 1024] is the start of the deck itself
    (func $initDeck (param $id i32)
        (local $slots i32)
        (set_local $slots (i32.const 4096))
        ;; init the start pointer
        (i32.store
            (call $head (get_local $id))
            (i32.add
                (i32.const 1024) ;; first 1024 bytes are reserved for the deck pointers
                (i32.mul (get_local $slots) (get_local $id))
            )
        )
        ;; init the end pointer
        (i32.store
            (call $tail (get_local $id))
            (i32.add
                (i32.const 1024)
                (i32.mul (get_local $slots) (get_local $id))
            )
        )
    )

    ;; advance the given address
    (func $advance (param $addr i32)
        (i32.store (get_local $addr)
            (i32.add
                (i32.load (get_local $addr))
                (i32.const 4)
            )
        )
    )

    (func $addToDeck (param $id i32) (param $v i32)
        ;; Store the input value at the $tail address
        (i32.store
            (i32.load (call $tail (get_local $id)))
            (get_local $v))
        ;; Move the $tail address forward
        (call $advance (call $tail (get_local $id)))
    )

    (func $deckHead (param $id i32) (result i32)
        (i32.load (i32.load (call $head (get_local $id))))
    )

    (func $deckPull (param $id i32) (result i32)
        ;; advance the $head address
        (call $advance (call $head (get_local $id)))
        ;; then grab the value at the prev address
        (i32.load
            (i32.sub 
                (i32.load (call $head (get_local $id)))
                (i32.const 4)
            )
        )
    )



    (func $calcResult (param $id i32) (result i32)
        (local $mul i32)
        (local $idx i32)
        (local $total i32)

        ;; start from the tail and work back to the head
        (set_local $idx (i32.load (call $tail (get_local $id))))

        (loop
            ;; increment mul (it starts at zero so we incr at beginning)
            (set_local $mul (i32.add (get_local $mul) (i32.const 1)))
            ;; decrement our local index to get the next value off the tail
            (set_local $idx (i32.sub 
                (get_local $idx)
                (i32.const 4) ;; tail is always 4 bytes ahead of the last element
            ))

            (set_local $total (i32.add
                    (get_local $total)
                    (i32.mul
                        (get_local $mul)
                        (i32.load (get_local $idx))
                    )
                )
            )

            (br_if 0 (i32.gt_s (get_local $idx) (i32.load (call $head (get_local $id)))))
        )
        (get_local $total)
    )
    
    (func $part1 (result i32)
        (local $iter i32)
        (local $result i32)

        (call $initDeck (i32.const 0))
        (call $initDeck (i32.const 1))

        ;; sample inputs
        ;; ;; initialize the first deck
        ;; (call $addToDeck (i32.const 0) (i32.const 9))
        ;; (call $addToDeck (i32.const 0) (i32.const 2))
        ;; (call $addToDeck (i32.const 0) (i32.const 6))
        ;; (call $addToDeck (i32.const 0) (i32.const 3))
        ;; (call $addToDeck (i32.const 0) (i32.const 1))

        ;; ;; initialize the second deck
        ;; (call $addToDeck (i32.const 1) (i32.const 5))
        ;; (call $addToDeck (i32.const 1) (i32.const 8))
        ;; (call $addToDeck (i32.const 1) (i32.const 4))
        ;; (call $addToDeck (i32.const 1) (i32.const 7))
        ;; (call $addToDeck (i32.const 1) (i32.const 10))

        ;; Player 1:
        (call $addToDeck (i32.const 0) (i32.const 14))
        (call $addToDeck (i32.const 0) (i32.const 29))
        (call $addToDeck (i32.const 0) (i32.const 25))
        (call $addToDeck (i32.const 0) (i32.const 17))
        (call $addToDeck (i32.const 0) (i32.const 13))
        (call $addToDeck (i32.const 0) (i32.const 50))
        (call $addToDeck (i32.const 0) (i32.const 33))
        (call $addToDeck (i32.const 0) (i32.const 32))
        (call $addToDeck (i32.const 0) (i32.const 7))
        (call $addToDeck (i32.const 0) (i32.const 37))
        (call $addToDeck (i32.const 0) (i32.const 26))
        (call $addToDeck (i32.const 0) (i32.const 34))
        (call $addToDeck (i32.const 0) (i32.const 46))
        (call $addToDeck (i32.const 0) (i32.const 24))
        (call $addToDeck (i32.const 0) (i32.const 3))
        (call $addToDeck (i32.const 0) (i32.const 28))
        (call $addToDeck (i32.const 0) (i32.const 18))
        (call $addToDeck (i32.const 0) (i32.const 20))
        (call $addToDeck (i32.const 0) (i32.const 11))
        (call $addToDeck (i32.const 0) (i32.const 1))
        (call $addToDeck (i32.const 0) (i32.const 21))
        (call $addToDeck (i32.const 0) (i32.const 8))
        (call $addToDeck (i32.const 0) (i32.const 44))
        (call $addToDeck (i32.const 0) (i32.const 10))
        (call $addToDeck (i32.const 0) (i32.const 22))

        ;; Player 2:
        (call $addToDeck (i32.const 1) (i32.const 5))
        (call $addToDeck (i32.const 1) (i32.const 38))
        (call $addToDeck (i32.const 1) (i32.const 27))
        (call $addToDeck (i32.const 1) (i32.const 15))
        (call $addToDeck (i32.const 1) (i32.const 45))
        (call $addToDeck (i32.const 1) (i32.const 40))
        (call $addToDeck (i32.const 1) (i32.const 43))
        (call $addToDeck (i32.const 1) (i32.const 30))
        (call $addToDeck (i32.const 1) (i32.const 35))
        (call $addToDeck (i32.const 1) (i32.const 9))
        (call $addToDeck (i32.const 1) (i32.const 48))
        (call $addToDeck (i32.const 1) (i32.const 12))
        (call $addToDeck (i32.const 1) (i32.const 16))
        (call $addToDeck (i32.const 1) (i32.const 47))
        (call $addToDeck (i32.const 1) (i32.const 42))
        (call $addToDeck (i32.const 1) (i32.const 4))
        (call $addToDeck (i32.const 1) (i32.const 2))
        (call $addToDeck (i32.const 1) (i32.const 31))
        (call $addToDeck (i32.const 1) (i32.const 41))
        (call $addToDeck (i32.const 1) (i32.const 39))
        (call $addToDeck (i32.const 1) (i32.const 23))
        (call $addToDeck (i32.const 1) (i32.const 19))
        (call $addToDeck (i32.const 1) (i32.const 36))
        (call $addToDeck (i32.const 1) (i32.const 49))
        (call $addToDeck (i32.const 1) (i32.const 6))
    
        ;; check which head is higher
        (loop
            (set_local $iter (i32.add (get_local $iter) (i32.const 1)))
             (if
                (i32.gt_s
                    (call $deckHead (i32.const 0))
                    (call $deckHead (i32.const 1))
                )
                (then 
                    (call $addToDeck (i32.const 0) (call $deckPull (i32.const 0)))
                    (call $addToDeck (i32.const 0) (call $deckPull (i32.const 1)))
                )
                (else
                    (call $addToDeck (i32.const 1) (call $deckPull (i32.const 1)))
                    (call $addToDeck (i32.const 1) (call $deckPull (i32.const 0)))
                )
            )

            ;; continue the loop if both deck heads are less than their tails
            (br_if 0 (i32.and
                (i32.lt_s
                    (i32.load (call $head (i32.const 0)))
                    (i32.load (call $tail (i32.const 0)))
                )
                (i32.lt_s
                    (i32.load (call $head (i32.const 1)))
                    (i32.load (call $tail (i32.const 1)))
                )
            ))
        )

        (if (i32.eq (i32.load (call $head (i32.const 0))) (i32.load (call $tail (i32.const 0))))
            (then
                (set_local $result (call $calcResult (i32.const 1)))
            )
            (else
                (set_local $result (call $calcResult (i32.const 0)))
            )
        )
        (get_local $result)
    )
  
  (export "run" (func $part1))

  ;; Debug info
  (func $head0 (result i32) (i32.load (call $head (i32.const 0))))
  (export "head0" (func $head0))
  (func $tail0 (result i32) (i32.load (call $tail (i32.const 0))))
  (export "tail0" (func $tail0))

  (func $head1 (result i32) (i32.load (call $head (i32.const 1))))
  (export "head1" (func $head1))
  (func $tail1 (result i32) (i32.load (call $tail (i32.const 1))))
  (export "tail1" (func $tail1))
)