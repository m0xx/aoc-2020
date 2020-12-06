const R = require('rambda');
const {combinaisons, sum, product} = require('../../lib/utils');
const {readAndSplit} = require('../../lib/files');

const resolveProblem = (filename, combinaisonLength, total) => R.compose(
    product,
    R.find((items) => sum(items) === total),
    combinaisons(combinaisonLength),
    R.map(expense => parseInt(expense, 10)),
    readAndSplit
)(filename)


console.log('P1: ' + resolveProblem('day-01.puzzle.txt', 2, 2020))
console.log('P2: ' + resolveProblem('day-01.puzzle.txt', 3, 2020))
