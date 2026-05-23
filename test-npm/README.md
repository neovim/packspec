# Test pkg.json against NPM's read-package-json library

`pkg.json` tries to be a subset of NPM's `package.json` format. The tests in
this directory test `pkg.json` samples using NPM's `read-package-json` library.

To run the tests:

    cd test-npm/
    npm ci
    npm run test
