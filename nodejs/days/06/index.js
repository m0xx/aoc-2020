const R = require('rambda');
const {product, sum, combinaisons, countBy, max} = require('../../lib/utils');
const {readAndSplit, splitChars, splitLines, readRawData, trim} = require('../../lib/files');

const resolveProblem = (filename) => R.compose(
    sum,
    R.map(group => {
        const letterCount = countBy(l => l)(R.flatten(group))
        return Object.values(letterCount).filter(count => count === group.length).length
    }),
    R.map(group => group.split('\n')
        .filter((str) => !!str)
        .map(row =>
            row.split('')
        )
    ),
    (rawData) => rawData.split('\n\n'),
    readRawData,
)(filename)


const DAY = '06'
const USE_SAMPLE = true;

console.log('P1: ' + JSON.stringify(resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`)))
// console.log('P2: ' + resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`))
