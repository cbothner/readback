const environment = require('./environment')
const { resolve } = require('path')
const { ConfigObject } = require('@rails/webpacker/package/config_types')

environment.entry = new ConfigObject()
environment.entry.set(
  'server',
  resolve('app', 'javascript', 'packs', 'server.entry.js')
)

environment.plugins.delete('CommonsChunkVendor')
environment.plugins.delete('CommonsChunkManifest')
environment.plugins.delete('Manifest')

environment.config.merge({ output: { filename: '[name].js' } })

module.exports = environment.toWebpackConfig()
