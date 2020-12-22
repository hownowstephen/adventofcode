function! part1#Parse()
    echom "Hello, December 21st"


    let ingredientCounts = {}
    let ingredientLists = []
    let allergensIn = {}

    let n=0
    while n <= line("$")
        let n += 1
        let line = getline(n)

        let ingredients = []
        let allergens = []

        let doneIngredients = 0

        for element in split(line)
            let element = trim(element, ",)(")
            if element == "contains"
                let doneIngredients = 1
                continue
            endif

            if doneIngredients
                call add(allergens, element)
            else
                if has_key(ingredientCounts, element)
                    let ingredientCounts[element] += 1
                else
                    let ingredientCounts[element] = 1
                endif
                call add(ingredients, element)
            endif
        endfor

        call add(ingredientLists, ingredients)

        for allergen in allergens
            if has_key(allergensIn, allergen)
                call add(allergensIn[allergen], n-1)
            else
               let allergensIn[allergen] = [n-1]
            end
        endfor
       
    endwhile

    let haveAllergen = []
    for idxs in values(allergensIn)
        let lst = ingredientLists[idxs[0]]

        echom lst
        echom idxs
        let i = 1
        while i < len(idxs)
            let lst = Intersect(lst, ingredientLists[idxs[i]])
            let i += 1
        endwhile

        for element in lst
            call add(haveAllergen, element)
        endfor
    endfor

    echom haveAllergen

    let c = 0
    for ing in items(ingredientCounts)
        if index(haveAllergen, ing[0]) == -1
            let c += ing[1]
        endif
    endfor

    echom c

endfunction

function Intersect(l1, l2)
    let out = []
    for element in a:l1
        if index(a:l2, element) > -1
            call add(out, element)
        endif
    endfor
    return out
endfunction