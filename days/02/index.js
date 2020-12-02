const R = require('rambda');
const {readAndSplit} = require('../../lib/files');

const countLetter = (str, letter) => str.split("").reduce((total, l) => l === letter ? total + 1 : total, 0);

const isValidP1 = ({min, max, letter, password}) => {
    const letterCount = countLetter(password, letter);
    return letterCount >= min && letterCount <= max;
}

const isValidP2 = ({min, max, letter, password}) => {
    let nbMatch = 0;
    if(password[min - 1] === letter) {
        nbMatch++
    }
    if(password[max - 1] === letter) {
        nbMatch++
    }

    return nbMatch === 1;
}

const parse = (str) => {
    const result = str.match(/^(\d*)-(\d*)\s([a-zA-Z]):\s([a-zA-Z]*)$/)
    return {
        min: parseInt(result[1], 10),
        max: parseInt(result[2], 10),
        letter: result[3],
        password: result[4]
    }
}

const resolveProblem = (filename, validator) => R.compose(
    (r) => r.length,
    R.filter(validator),
    R.map(parse),
    R.filter((str) => !!str),
    readAndSplit
)(filename)


console.log('P1: ' + resolveProblem('day-02.puzzle.txt', isValidP1))
console.log('P2: ' + resolveProblem('day-02.puzzle.txt', isValidP2))
