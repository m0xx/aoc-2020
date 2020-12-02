const R = require('rambda');
const {permutations} = require('../../lib/utils');
const {readAndSplit} = require('../../lib/files');
const sum = (items) => items.reduce((total, current) => total + current, 0);

const resolveProblem = (filename, nbPermutation, total) => R.compose(
    (items) => items.reduce((prev, current ) => prev * current, 1),
    R.find((items) => sum(items) === total),
    permutations(nbPermutation),
    R.map(expense => parseInt(expense, 10)),
    readAndSplit
)(filename)


console.log(resolveProblem('day-01.puzzle.txt', 3, 2020))
