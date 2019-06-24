const path = require('path');

module.exports = {
  resolve: {
    alias: {
      jquery: require.resolve('jquery'),
      '@': path.resolve(__dirname, '..', '..', 'app/javascript')
    }
  }
}
