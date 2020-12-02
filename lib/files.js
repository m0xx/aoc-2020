const R = require('rambda');
const path = require('path');
const fs = require('fs');

const readRawData = (filename) => fs.readFileSync(path.join(__dirname, '..', 'data', filename)).toString();
const splitLines = (rawData) => rawData.split('\n');

module.exports = {
     readRawData,
     splitLines,
     readAndSplit: R.compose(splitLines, readRawData)
}
