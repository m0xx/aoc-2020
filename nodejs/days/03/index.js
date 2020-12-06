const R = require('rambda');
const {product} = require('../../lib/utils');
const {readAndSplit} = require('../../lib/files');

const countTrees = (moves) => (rows) => moves.map(([x, y]) => {
    const cursor = {x, y};
    let count = 0;

    while(cursor.y < rows.length) {
        const char = rows[cursor.y][cursor.x]
        if(char == undefined) {
            throw "oops not enough space on map"
        }
        if(char === "#") {
            count++;
        }

        cursor.x += x
        cursor.y += y
    }

    return count
})

const resolveProblem = (filename, moves) => R.compose(
    product,
    countTrees(moves),
    R.map(str => R.range(0,100).reduce((prev, current) => prev + str, str )),
    R.filter((str) => !!str),
    readAndSplit
)(filename)


console.log('P1: ' + resolveProblem('day-03.puzzle.txt', [[3, 1]]))
console.log('P2: ' + resolveProblem('day-03.puzzle.txt', [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2],
]))
