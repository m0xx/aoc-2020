const _permutations = (nbPermutations, items, current) => {
    if (nbPermutations > 1) {
        return items.reduce((results, item, index) => {
            if (index + 1 >= items.length) {
                return results;
            }

            return [
                ...results,
                ..._permutations(nbPermutations - 1, items.slice(index + 1, items.length), [...current, item])]
        }, [])
    }
    return [
        ...items.map(item => [...current, item])
    ]
}

const permutations = nbPermutations => items => _permutations(nbPermutations, items, [])

module.exports = {
    permutations
}
