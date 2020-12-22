function! part2#Parse()
    echom "Hello, December 21st part two"


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

        let i = 1
        while i < len(idxs)
            let lst = Intersect(lst, ingredientLists[idxs[i]])
            let i += 1
        endwhile

        for element in lst
            if index(haveAllergen, element) == -1
                call add(haveAllergen, element)
            endif
        endfor
    endfor

    echom haveAllergen

    let allergensOut = {}

    while len(allergensOut) < len(allergensIn)
        for v in items(allergensIn)
            let idxs = v[1]
            let lst = Intersect(ingredientLists[idxs[0]], haveAllergen)
            let i = 1
            while i < len(idxs)
                let int = Intersect(ingredientLists[idxs[i]], haveAllergen)
                let lst = Intersect(lst, int)
                let i += 1
            endwhile

            if len(lst) == 1
                let allergensOut[v[0]] = lst[0]
                call filter(haveAllergen, 'v:val != lst[0]')
            end
        endfor
    endwhile

    let out = []
    for k in sort(keys(allergensOut))
        call add(out, allergensOut[k])
    endfor

    echom join(out, ",")

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