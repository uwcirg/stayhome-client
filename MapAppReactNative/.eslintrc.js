module.exports = {
  root: true,
  extends: '@react-native-community',
  rules: {
    'prettier/prettier': ['error', {
      'singleQuote': true,
      'trailingComma': 'es5',
      'max-len': {
        'code':120
      }
    }],
  },
};
