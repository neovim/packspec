// NODE_PATH=$(npm root -g) node scripts/npm.js

var fs = require('fs')
var assert = require('assert')
var path = require('path')
var readJson = require('read-package-json')

const fname = 'pkg.json'

function runTest(inputFile, expectedFile) {
  const expected = require('./'+expectedFile).expected

  // readJson(filename, [logFunction=noop], [strict=false], cb)
  readJson(inputFile, console.error, false, function (e, data) {
    if (e) {
      console.error(`failed to parse "${inputFile}": ${e}`);
      throw Error(`failed to parse "${inputFile}"`)
    }

    // Remove unwanted fields auto-filled by read-package-json.
    for (const field of ['gitHead']) {
      delete data[field]
    }
    for (const field of Object.getOwnPropertySymbols(data)) {
      // Symbol('indent'), Symbol('newline'), …
      delete data[field]
    }

    // assert.deepStrictEqual(data.engines, expected.engines);
    // assert.deepStrictEqual(data.dependencies, expected.dependencies);
    assert.deepStrictEqual(data, expected);
  });
}

function runTests() {
  const failures = [];
  const tests = {};  // input:output map. { "test1.pkg.json" : "test1.expected.js", … }
  const testDir = 'test/';
  const testFilenames = fs.readdirSync(testDir);

  // Find the tests.
  for (const fname of testFilenames) {
    const testName = fname.match(/[^.]+/).toString()  // Remove ".pkg.json" suffix.
    const suffix = fname.match(/\..+/)?.toString()  // Get ".pkg.json" suffix.
    const fullpath = path.join(testDir, fname);
    if (suffix !== '.expected.js' && suffix !== '.pkg.json') {
      throw Error(`unexpected test file (does not end with ".expected.js" or "pkg.json"): ${fullpath}`)
    }
    if (suffix === '.pkg.json') {
      tests[fname] = `${testName}.expected.js`;
      const expectedFile = path.join(testDir, tests[fname]);
      if (!fs.existsSync(expectedFile)) {
        throw Error(`found "${fname}", but missing "${tests[fname]}"`)
      }
    }
  }

  // sanity check
  assert(Object.keys(tests).length > 0, `no tests found in: ${testDir}`);

  // Run the tests.
  for (const test of Object.keys(tests)) {
    const inputFile = path.join(testDir, test);
    const expectedFile = path.join(testDir, tests[test]);
    runTest(inputFile, expectedFile);
  }

  console.log(`test result: ${Object.keys(tests).length} passed, ${failures.length} failed`);
}

runTests();
