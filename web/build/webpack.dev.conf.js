var fs = require('fs')
var path = require('path')
var utils = require('./utils')
var webpack = require('webpack')
var config = require('../config')
var merge = require('webpack-merge')
var baseWebpackConfig = require('./webpack.base.conf')
var CopyWebpackPlugin = require('copy-webpack-plugin')
var HtmlWebpackPlugin = require('html-webpack-plugin')
var FriendlyErrorsPlugin = require('friendly-errors-webpack-plugin')
var loadMinified = require('./load-minified')

// add hot-reload related code to entry chunks
Object.keys(baseWebpackConfig.entry).forEach(function (name) {
  baseWebpackConfig.entry[name] = ['./build/dev-client'].concat(baseWebpackConfig.entry[name])
})

module.exports = merge(baseWebpackConfig, {
  module: {
    rules: utils.styleLoaders({ sourceMap: config.dev.cssSourceMap })
  },
  // cheap-module-eval-source-map is faster for development
  devtool: '#cheap-module-eval-source-map',
  plugins: [
    new webpack.DefinePlugin({
      'process.env': config.dev.env
    }),
    // https://github.com/glenjamin/webpack-hot-middleware#installation--usage
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    // https://github.com/ampedandwired/html-webpack-plugin
    new CopyWebpackPlugin([
      {
        from: path.resolve(__dirname, '../public'),
        to: config.build.assetsRoot,
        ignore: ['.*']
      }
    ]),
    new CopyWebpackPlugin([
      {
        from: path.resolve(__dirname, '../node_modules/firebase/firebase-app.js'),
        to: config.build.assetsRoot
      }
    ]),
    new CopyWebpackPlugin([
      {
        from: path.resolve(__dirname, '../node_modules/firebase/firebase-messaging.js'),
        to: config.build.assetsRoot
      }
    ]),
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'index.html',
      inject: true,
      serviceWorkerLoader: ''
      //serviceWorkerLoader: `<script>${loadMinified(path.join(__dirname, './service-worker-prod.js'))}</script>`
      //serviceWorkerLoader: `<script>${fs.readFileSync(path.join(__dirname, './service-worker-dev.js'), 'utf-8')}</script>`
    }),
    new FriendlyErrorsPlugin()
  ]
})
