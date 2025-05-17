module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'build', 'chore', 'ci', 'docs', 'feat', 'fix', 'perf',
        'refactor', 'revert', 'style', 'test'
      ]
    ],
    'subject-case': [
      2,
      'never',
      ['upper-case']
    ]
  },
  defaultIgnores: true,
  helpUrl: 'https://github.com/r0227n/flutter_template_project/blob/main/docs/commitlint-rules.md'
};
