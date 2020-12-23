
;;   (export "run" (func $part2))

  (func $part2RecursionTest (result i32)
        (local $count i32)
        (local $configRead i32)
        (local $matched i32)
        (local $loops i32)
        (local $idx i32)

        (call $initDeck (i32.const 0))
        (call $initDeck (i32.const 1))

        ;; checking handling of infinite loop
        (call $addToDeck (i32.const 0) (i32.const 43))
        (call $addToDeck (i32.const 0) (i32.const 19))

        (call $addToDeck (i32.const 1) (i32.const 2))
        (call $addToDeck (i32.const 1) (i32.const 29))
        (call $addToDeck (i32.const 1) (i32.const 14))

        ;; (drop 
            (call $calcResult
                (call $playGame (i32.const 0) (i32.const 1))
            )
        ;; )

        ;; (set_local $configRead (call $configStart (i32.const 0)))

        ;; (loop
        ;;     (set_local $loops (call $incr (get_local $loops)))
        ;;     (if (call $nonzero (i32.load (get_local $configRead)))
        ;;         (then
        ;;             ;; check deck 1
        ;;             (set_local $matched (i32.add
        ;;                 (get_local $matched)
        ;;                 (call $deckMatch (i32.const 0) (get_local $configRead))
        ;;             ))

        ;;             (set_local $count (i32.load (get_local $configRead)))
        ;;             (set_local $configRead (call $incr4 (get_local $configRead)))
        ;;             (set_local $configRead (call $incrIn4s (get_local $configRead) (get_local $count)))

        ;;             ;; check deck 2
        ;;             (set_local $matched (i32.add
        ;;                 (get_local $matched)
        ;;                 (call $deckMatch (i32.const 1) (get_local $configRead))
        ;;             ))

        ;;             (set_local $count (i32.load (get_local $configRead)))
        ;;             (set_local $configRead (call $incr4 (get_local $configRead)))
        ;;             (set_local $configRead (call $incrIn4s (get_local $configRead) (get_local $count)))

        ;;             (br 1)
        ;;         )
        ;;     )
        ;; )   

        ;; (get_local $loops)
        ;; (i32.load (call $incrIn4s
        ;;     (call $configStart (i32.const 0))
        ;;     (i32.const 9)
        ;; ))
        ;; (set_local $idx (call $storeConfig (i32.const 0) (call $configStart (i32.const 0))))
        ;; (i32.sub
        ;;     (call $storeConfig (i32.const 0) (get_local $idx))
        ;;     (call $configStart (i32.const 0))
        ;; )

  )

          ;; checking functionality with a non-recursive set
        ;; (call $addToDeck (i32.const 0) (i32.const 8))
        ;; (call $addToDeck (i32.const 0) (i32.const 3))

        ;; (call $addToDeck (i32.const 1) (i32.const 10))
        ;; (call $addToDeck (i32.const 1) (i32.const 9))
        ;; (call $addToDeck (i32.const 1) (i32.const 7))
        ;; (call $addToDeck (i32.const 1) (i32.const 5))
        ;; (call $addToDeck (i32.const 1) (i32.const 6))
        ;; (call $addToDeck (i32.const 1) (i32.const 2))
        ;; (call $addToDeck (i32.const 1) (i32.const 4))
        ;; (call $addToDeck (i32.const 1) (i32.const 1))
