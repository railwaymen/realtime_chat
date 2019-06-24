const { environment } = require('@rails/webpacker')

const webpack = require('webpack');
const aliases = require('./aliases');

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

environment.config.merge(aliases);

module.exports = environment
