const R = require('rambda');
const {max} = require('../../lib/utils');
const {splitLines, readRawData} = require('../../lib/files');

const binarySplit = (moves, {from, to}) => {
    if (from === to) {
        if (moves.length > 0) {
            console.log('no moves left....')
        }

        return from
    }

    const currentMove = moves[0];
    const step = Math.floor((to -  from) / 2);
    const isFirstHalf = currentMove === 'F' || currentMove === 'L'
    const nextRange = isFirstHalf ? {from, to: from + step} : {from:from + step + 1, to}

    return binarySplit(moves.slice(1, moves.length), nextRange)
}

const findSeat = ({nbRows, nbCols}) => (seat) => {
    const rowMoves = seat.slice(0, 7).split('');
    const row = binarySplit(rowMoves, {from: 0, to: nbRows - 1})

    const colMoves = seat.slice(7, 10).split('');
    const col = binarySplit(colMoves, {from: 0, to: nbCols - 1})
    return {row, col}
}
const seatId = ({row, col}) => row * 8 + col

const findMySeat = (seatsId) => {
    for(let i=1; i < seatsId.length; i++) {
        const prev = seatsId[i - 1];
        const current = seatsId[i];

        if(current - prev > 1) {
            return current - 1;
        }
    }

    console.log('not found..')
    return -1;
}

const resolveProblem = (filename, {nbRows, nbCols}) => R.compose(
    max,
    R.map(seatId),
    R.map(findSeat({nbCols, nbRows})),
    R.filter((str) => !!str),
    splitLines,
    readRawData,
)(filename)

const resolveProblem2 = (filename, {nbRows, nbCols}) => R.compose(
    findMySeat,
    seatIds => seatIds.sort(),
    R.map(seatId),
    R.map(findSeat({nbCols, nbRows})),
    R.filter((str) => !!str),
    splitLines,
    readRawData,
)(filename)


const DAY = '05'
const USE_SAMPLE = false;

console.log('P1: ' + resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`, {nbRows: 128, nbCols: 8}))
console.log('P2: ' + resolveProblem2(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`, {nbRows: 128, nbCols: 8}))
