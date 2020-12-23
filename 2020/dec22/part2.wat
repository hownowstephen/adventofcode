(module

    (memory $0 64)
    (data (i32.const 1024) "Hello, Dec 22nd Part 2!\00") ;; gotta have it, even though it's not being printed

    ;; increment by 1
    (func $incr (param $v i32) (result i32)
        (i32.add (get_local $v) (i32.const 1))
    )

    ;; increment by 4
    (func $incr4 (param $v i32) (result i32)
        (i32.add (get_local $v) (i32.const 4))
    )

    ;; incr by $count*4
    (func $incrIn4s (param $v i32) (param $count i32) (result i32)
        (i32.add
            (get_local $v)
            (i32.mul
                (get_local $count)
                (i32.const 4)
            )
        )
    )

    ;; decrement by one
    (func $decr (param $v i32) (result i32)
        (i32.sub (get_local $v) (i32.const 1))
    )

    ;; non-zero check
    (func $nonzero (param $v i32) (result i32)
        (i32.ne (get_local $v) (i32.const 0)))

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
    ;; [n*4096 + 4096] is the start of the deck itself
    (func $initDeck (param $id i32)
        (local $slots i32)
        (set_local $slots (i32.const 10000))
        ;; init the start pointer
        (i32.store
            (call $head (get_local $id))
            (i32.add
                (i32.const 10000) ;; first 1024 bytes are reserved for the deck pointers
                (i32.mul (get_local $slots) (get_local $id))
            )
        )
        ;; init the end pointer
        (i32.store
            (call $tail (get_local $id))
            (i32.add
                (i32.const 10000)
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

    ;; add a card to the end of deck $id
    (func $addToDeck (param $id i32) (param $v i32)
        ;; Store the input value at the $tail address
        (i32.store
            (i32.load (call $tail (get_local $id)))
            (get_local $v))
        ;; Move the $tail address forward
        (call $advance (call $tail (get_local $id)))
    )

    ;; look at the top element off the deck
    (func $deckPeek (param $id i32) (result i32)
        (i32.load (i32.load (call $head (get_local $id))))
    )

    ;; get the length of the deck
    (func $deckLen (param $id i32) (result i32)
        (i32.div_s (i32.sub
            (i32.load (call $tail (get_local $id)))
            (i32.load (call $head (get_local $id)))
        ) (i32.const 4))
    )

    ;; remove the first element of the deck
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

    ;; do some cool math to give the AoC calculator what it want
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

    ;; copy a deck into a subdeck containing elements from the original
    ;; where $deckLen = $peekDeck
    (func $copyDeck (param $id i32) (result i32)
        (local $h i32)
        (local $t i32)
        (local $newid i32)
        (local $count i32)

        ;; load the head/tail address of the existing deck
        (set_local $h (i32.load (call $head (get_local $id))))
        (set_local $t (i32.load (call $head (get_local $id))))

        ;; first element in the parent deck decides size of next deck
        (set_local $count (i32.load (get_local $h)))

        ;; id of this deck
        (set_local $newid (i32.add (get_local $id) (i32.const 2)))

        ;; two player game means that when copying we can just advance by two
        (call $initDeck (get_local $newid))
        
        (loop
            ;; decrement the counter and advance the read head
            (set_local $count (i32.sub (get_local $count) (i32.const 1)))
            (set_local $h (i32.add (get_local $h) (i32.const 4)))

            ;; add next element to the new deck
            (call $addToDeck (get_local $newid) (i32.load (get_local $h)))

            ;; continue while we have time left on the meter
            (br_if 0 (i32.ne (get_local $count) (i32.const 0)))
        )

        ;; return the id of this deck for convenience
        (get_local $newid)
    )

    (func $deckMatch (param $id i32) (param $from i32) (result i32)
        (local $deckAt i32)
        (local $count i32)
        (local $i i32)
        (local $matches i32)

        (set_local $deckAt (i32.load (call $head (get_local $id))))
        (set_local $count (i32.load (get_local $from)))
        (set_local $from (call $incr4 (get_local $from)))

        (if (i32.eq (get_local $count) (call $deckLen (get_local $id)))
            (then ;; only check if the size matches. Can't trust the garbage
                (loop
                    (if 
                        (i32.eq 
                            (i32.load (get_local $from))
                            (i32.load (get_local $deckAt)))
                        (then 
                            (set_local $matches (call $incr (get_local $matches)))
                        )
                    )
                    ;; advance the loop counter and check if we should break
                    (set_local $i (call $incr (get_local $i)))
                    ;; advance the read headers
                    (if (i32.lt_s (get_local $i) (get_local $count))
                        (then 
                            (set_local $from (call $incr4 (get_local $from)))
                            (set_local $deckAt (call $incr4 (get_local $deckAt)))
                            (br 1)
                        )
                    )
                )
            )
        )
        (i32.and
            (call $nonzero (get_local $count))
            (i32.eq (get_local $matches) (get_local $count))
        )
    )

    ;; Config ranges start at 2000000
    ;; and are reserved by game (which is just the first board id / 2)
    (func $configStart (param $id i32) (result i32)
        (i32.add 
            (i32.const 2000000)
            (i32.mul
                (i32.const 20000)
                (i32.div_s
                    (get_local $id)
                    (i32.const 2)
                )
            )
        )
    )

    ;; store the deck starting at $storeAt, return the next free address
    (func $storeConfig (param $deck i32) (param $storeAt i32) (result i32)
        (local $count i32)
        (local $deckIdx i32)
        (set_local $count (call $deckLen (get_local $deck)))
        (set_local $deckIdx (i32.load (call $head (get_local $deck))))
        ;; store the length
        (i32.store (get_local $storeAt) (get_local $count))
        (loop
            (set_local $storeAt (call $incr4 (get_local $storeAt)))

            (i32.store (get_local $storeAt) (i32.load (get_local $deckIdx)))
            (set_local $deckIdx (call $incr4 (get_local $deckIdx)))

            ;; break once $count is zero
            (set_local $count (call $decr (get_local $count)))
            (br_if 0 (call $nonzero (get_local $count)))
        )

        (call $incr4 (get_local $storeAt))
    )

    ;; deck configurations are stored far out in memory, in the format
    ;; [count][...][count][...]
    (func $seenConfig (param $deck1 i32) (param $deck2 i32) (result i32)
        (local $configRead i32)
        (local $deckRead i32)
        (local $count i32)
        (local $matched i32)
        (local $i i32)

        (set_local $configRead (call $configStart (get_local $deck1)))
    
        (loop
            (if (call $nonzero (i32.load (get_local $configRead)))
                (then
                    ;; check deck 1
                    (set_local $matched (i32.add
                        (get_local $matched)
                        (call $deckMatch (get_local $deck1) (get_local $configRead))
                    ))

                    (set_local $count (i32.load (get_local $configRead)))
                    (set_local $configRead (call $incr4 (get_local $configRead)))
                    (set_local $configRead (call $incrIn4s (get_local $configRead) (get_local $count)))

                    ;; check deck 2
                    (set_local $matched (i32.add
                        (get_local $matched)
                        (call $deckMatch (get_local $deck2) (get_local $configRead))
                    ))

                    (set_local $count (i32.load (get_local $configRead)))
                    (set_local $configRead (call $incr4 (get_local $configRead)))
                    (set_local $configRead (call $incrIn4s (get_local $configRead) (get_local $count)))

                    (br 1)
                )
            )
        )   

        ;; convert $matched to a bool
        (set_local $matched (i32.eq (get_local $matched) (i32.const 2)))

        ;; store both decks if !matched
        (if (i32.ne (get_local $matched) (i32.const 1))
            (then
                 (set_local $configRead (call $storeConfig (get_local $deck1) (get_local $configRead)))
                (drop (call $storeConfig (get_local $deck2) (get_local $configRead)))
            )
        )

        (get_local $matched)
    )

    ;; playRound accepts two deck indices and returns the index that won
    (func $playRound (param $deck1 i32) (param $deck2 i32) (param $maxRounds i32) (result i32)
        (local $card1 i32)
        (local $card2 i32)
        (local $winner i32)
        (local $nextDeck1 i32)
        (local $nextDeck2 i32)

        ;; track how many rounds the deck plays
        (call $incrRounds (get_local $deck1))

        ;; look at the next two cards
        (set_local $card1 (call $deckPeek (get_local $deck1)))
        (set_local $card2 (call $deckPeek (get_local $deck2)))

        ;; if one of the two card numbers is larger then the deck length
        (if (i32.or 
                (i32.gt_s (get_local $card1) (call $decr (call $deckLen (get_local $deck1))))
                (i32.gt_s (get_local $card2) (call $decr (call $deckLen (get_local $deck2)))))
        (then ;; compare the two cards and return a winner
            (if (i32.gt_s (get_local $card1) (get_local $card2))
                (then (set_local $winner (get_local $deck1)))
                (else (set_local $winner (get_local $deck2)))
            )
        )
        (else ;; otherwise we're in a recursive game, pal
            ;; (if (i32.eq (get_local $deck1) (i32.const 0))
            ;;     (then
                    (set_local $nextDeck1 (call $copyDeck (get_local $deck1)))
                    (set_local $nextDeck2 (call $copyDeck (get_local $deck2)))

                    (set_local $winner (i32.sub
                        (call $playGame
                            (get_local $nextDeck1)
                            (get_local $nextDeck2)
                            (get_local $maxRounds)
                        )
                        (i32.const 2) ;; maps the subwinner to the parent 
                    ))
                ;; )
            ;; )
        ))

        (get_local $winner)
    )

    (func $numRounds (param $deck i32) (result i32)
        (i32.load (i32.add (i32.const 5000) (i32.mul (i32.const 4) (get_local $deck))))
    )

    (func $incrRounds (param $deck i32)
        (local $slot i32)
        (set_local $slot (i32.add (i32.const 5000) (i32.mul (i32.const 4) (get_local $deck))))
        (i32.store
            (get_local $slot)
            (i32.add
                (i32.load (get_local $slot))
                (i32.const 1)
            )
        )
    )

    (func $playGame (param $deck1 i32) (param $deck2 i32) (param $maxRounds i32) (result i32)
        (local $winner i32)
        (local $loser i32)
        (local $seen i32)
        (local $loops i32)
        (loop

            (set_local $loops (call $incr (get_local $loops)))

            (set_local $seen (call $seenConfig (get_local $deck1) (get_local $deck2)))
            (if (get_local $seen)
                (then 
                    ;; old config, $deck1 wins
                    (set_local $winner (get_local $deck1))
                )
                (else
                    ;; play a round and get the winner
                    (set_local $winner (call $playRound (get_local $deck1) (get_local $deck2) (get_local $maxRounds)))

                    ;; set the loser as the inverse of the winner
                    (if (i32.eq (get_local $winner) (get_local $deck1))
                        (then (set_local $loser (get_local $deck2)))
                        (else (set_local $loser (get_local $deck1)))
                    )

                    ;; pull cards off the winner and loser and append to the winner
                    (call $addToDeck (get_local $winner) (call $deckPull (get_local $winner)))
                    (call $addToDeck (get_local $winner) (call $deckPull (get_local $loser)))
                )
            )
            
            
            ;; continue the loop if both deck heads are less than their tails
            ;; otherwise the last winner won the whole game
            (if (i32.and
                (i32.and
                    (i32.lt_s
                        (i32.load (call $head (get_local $deck1)))
                        (i32.load (call $tail (get_local $deck1)))
                    )
                    (i32.lt_s
                        (i32.load (call $head (get_local $deck2)))
                        (i32.load (call $tail (get_local $deck2)))
                    )
                )
                (i32.and
                    (i32.ne (get_local $seen) (i32.const 1))
                    (i32.ne (get_local $loops) (get_local $maxRounds))
                )
            )
                (then (br 1))
            )
        )
        (get_local $winner)
    )
    
    (func $part2 (result i32)
        (local $iter i32)
        (local $result i32)

        (call $initDeck (i32.const 0))
        (call $initDeck (i32.const 1))

        ;; sample inputs
        ;; initialize the first deck
        (call $addToDeck (i32.const 0) (i32.const 9))
        (call $addToDeck (i32.const 0) (i32.const 2))
        (call $addToDeck (i32.const 0) (i32.const 6))
        (call $addToDeck (i32.const 0) (i32.const 3))
        (call $addToDeck (i32.const 0) (i32.const 1))

        ;; initialize the second deck
        (call $addToDeck (i32.const 1) (i32.const 5))
        (call $addToDeck (i32.const 1) (i32.const 8))
        (call $addToDeck (i32.const 1) (i32.const 4))
        (call $addToDeck (i32.const 1) (i32.const 7))
        (call $addToDeck (i32.const 1) (i32.const 10))

        ;; (drop 
            (call $calcResult
                (call $playGame (i32.const 0) (i32.const 1) (i32.const 1000))
            )
        ;; )

        ;; (call $numRounds (i32.const 0))

        
    )
  

  (export "run" (func $part2))

  ;; Debug info
  (func $head0 (result i32) (i32.load (call $head (i32.const 0))))
  (export "head0" (func $head0))
  (func $tail0 (result i32) (i32.load (call $tail (i32.const 0))))
  (export "tail0" (func $tail0))

  (func $head0val (result i32) (i32.load (i32.load (call $head (i32.const 0)))))
  (export "head0val" (func $head0val))
  (func $tail0val (result i32) (i32.load (i32.sub 
    (i32.load (call $tail (i32.const 0)))
    (i32.const 4)
  )))
  (export "tail0val" (func $tail0val))

  (func $head1 (result i32) (i32.load (call $head (i32.const 1))))
  (export "head1" (func $head1))
  (func $tail1 (result i32) (i32.load (call $tail (i32.const 1))))
  (export "tail1" (func $tail1))


  (func $head1val (result i32) (i32.load (i32.load (call $head (i32.const 1)))))
  (export "head1val" (func $head1val))
  (func $tail1val (result i32) (i32.load (i32.sub 
    (i32.load (call $tail (i32.const 1)))
    (i32.const 4)
  )))
  (export "tail1val" (func $tail1val))

  (func $head2 (result i32) (i32.load (call $head (i32.const 2))))
  (export "head2" (func $head2))
  (func $tail2 (result i32) (i32.load (call $tail (i32.const 2))))
  (export "tail2" (func $tail2))

  (func $head2val (result i32) (i32.load (call $incrIn4s 
    (i32.load (call $head (i32.const 2)))
    (i32.const 0)
  )))
  (export "head2val" (func $head2val))
  (func $tail2val (result i32) (i32.load (i32.sub 
    (i32.load (call $tail (i32.const 2)))
    (i32.const 4)
  )))
  (export "tail2val" (func $tail2val))

  (func $head3 (result i32) (i32.load (call $head (i32.const 3))))
  (export "head3" (func $head3))
  (func $tail3 (result i32) (i32.load (call $tail (i32.const 3))))
  (export "tail3" (func $tail3))


  (func $head3val (result i32) (i32.load (call $incrIn4s 
    (i32.load (call $head (i32.const 3)))
    (i32.const 0)
  )))
  (export "head3val" (func $head3val))
  (func $tail3val (result i32) (i32.load (i32.sub 
    (i32.load (call $tail (i32.const 3)))
    (i32.const 4)
  )))
  (export "tail3val" (func $tail3val))

  ;; subgame slot 3
  (func $head4val (result i32) (i32.load (call $incrIn4s 
    (i32.load (call $head (i32.const 4)))
    (i32.const 0)
  )))
  (export "head4val" (func $head4val))
  (func $tail4val (result i32) (i32.load (i32.sub 
    (i32.load (call $tail (i32.const 4)))
    (i32.const 4)
  )))
  (export "tail4val" (func $tail4val))

  (func $head5val (result i32) (i32.load (call $incrIn4s 
    (i32.load (call $head (i32.const 5)))
    (i32.const 0)
  )))
  (export "head5val" (func $head5val))
  (func $tail5val (result i32) (i32.load (i32.sub 
    (i32.load (call $tail (i32.const 5)))
    (i32.const 4)
  )))
  (export "tail5val" (func $tail5val))

)