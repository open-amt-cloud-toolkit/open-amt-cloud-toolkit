module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'body-max-line-length': [2, 'always', 200],
        'subject-case': [
            1,
            'never',
            ['sentence-case', 'start-case', 'pascal-case', 'upper-case'],
        ],
    }
}