const R = require('rambda');
const {product, sum, combinaisons, countBy, max} = require('../../lib/utils');
const {readAndSplit, splitChars, splitLines, readRawData, trim} = require('../../lib/files');

const resolveProblem = (filename) => R.compose(
    R.filter((str) => !!str),
    splitLines,
    readRawData,
)(filename)


const DAY = '15'
const USE_SAMPLE = true;

console.log('P1: ' + resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`))
// console.log('P2: ' + resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`))
