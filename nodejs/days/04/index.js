const R = require('rambda');
const { readRawData } = require('../../lib/files');

const requiredFields = [
    'byr',
    'iyr',
    'eyr',
    'hgt',
    'hcl',
    'ecl',
    'pid',
]

const isBetween = (min, max) => (passport, field) => parseInt(passport[field]) >= min && parseInt(passport[field]) <= max;
const isValid = (passport) => {
    let valid = true;
    requiredFields.forEach((f) => {
        if(!passport[f]) {
            valid = false
        }
    })
    if(!valid) {
        return false;
    }

    function failed(field, extra = "") {
        console.log('failed ' + extra, field, passport[field])
    }
    if(!isBetween(1920, 2002)(passport, 'byr')) {
        failed('byr')
        return false;
    }
    if(!isBetween(2010, 2020)(passport, 'iyr')) {
        failed('iyr')
        return false;
    }
    if(!isBetween(2020, 2030)(passport, 'eyr')) {
        failed('eyr')
        return false;
    }
    const m = passport['hgt'].match(/^\d*(cm|in)$/)
    if(!m) {
        failed('hgt', 'match')
        return false;
    }
    const height = parseInt(m[0])
    if(passport['hgt'].indexOf('cm') > -1) {
        if(height < 150 || height > 193) {
            failed('hgt', 'cm')
            return false;
        }
    }
    else {
        if(height < 59 || height > 76) {
            failed('hgt', 'in')
            return false;
        }
    }

    if(!passport['hcl'].match(/^#(\d|[a-f]){6}$/)) {
        failed('hcl')
        return false;
    }

    if(['amb', 'blu','brn','gry','grn','hzl','oth' ].indexOf(passport['ecl']) === -1) {
        failed('ecl')
        return false;
    }

    if(!passport['pid'].match(/^\d{9}$/)) {
        failed('pid')
        return false;
    }

    return true;
}
const parsePassport = str => str.split(/[\s|\n]/).map(pair => pair.split(':')).reduce((result, [key, value]) => {result[key] = value; return result;}, {})
const resolveProblem = (filename, moves) => R.compose(
    (r) => r.length,
    R.filter(isValid),
    R.map(parsePassport),
    R.filter((str) => !!str),
    (rawData) => rawData.split('\n\n'),
    readRawData,
)(filename)


const DAY = '04'
const USE_SAMPLE = false;

console.log('P2: ' + JSON.stringify(resolveProblem(`day-${DAY}.${USE_SAMPLE ? 'sample' : 'puzzle'}.txt`)))
