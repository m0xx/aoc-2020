const R = require('rambda');
const {product, sum, combinaisons, countBy} = require('../../lib/utils');
const {readAndSplit, splitChars, splitLines, readRawData, trim} = require('../../lib/files');

const resolveProblem = (filename, moves) => R.compose(
    R.filter((str) => !!str),
    splitLines,
    readRawData,
)(filename)


const DAY = '__DAY__'
const USE_SAMPLE = true;

console.log('P1: ' + resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`))
// console.log('P2: ' + resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`))
