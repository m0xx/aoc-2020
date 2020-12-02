const R = require('rambda');
const {readAndSplit} = require('../../lib/files');

const listPossibilities = expenses => R.range(0, expenses.length - 1)
    .reduce((results, i) => [
        ...results,
        ...R.range(i + 1, expenses.length).map(j => [expenses[i], expenses[j]])
], []);
const findPair = total => R.find(([a, b]) => a + b === total);


const result = R.compose(
    ([a, b]) => a * b,
    findPair(2020),
    listPossibilities,
    R.map(expense => parseInt(expense, 10)),
    readAndSplit
)('day-01.puzzle.txt');

console.log(result);
