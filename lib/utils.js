const R = require('rambda');

const _combinaison = (length, items, current) => {
    if (length > 1) {
        return items.reduce((results, item, index) => {
            if (index + 1 >= items.length) {
                return results;
            }

            return [
                ...results,
                ..._combinaison(length - 1, items.slice(index + 1, items.length), [...current, item])]
        }, [])
    }
    return [
        ...items.map(item => [...current, item])
    ]
}

const combinaisons = length => items => _combinaison(length, items, [])
const sum = (items) => items.reduce((total, current) => total + current, 0);
const product = items => items.reduce((prev, current ) => prev * current, 1);
const countBy = (groupFn) => R.compose(
    R.map((val, key) => val.length),
    R.groupBy(groupFn)
);
const max = items => items.reduce((prev, current) => {
    if(prev === null) {
        return current;
    }

    if(current > prev) {
        return current;
    }
    return prev;
}, null)

module.exports = {
    combinaisons,
    sum,
    product,
    countBy,
    max
}
