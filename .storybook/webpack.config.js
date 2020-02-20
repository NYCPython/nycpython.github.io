module.exports = async ({ config, mode }) => {
    config.watchOptions = {
        aggregateTimeout: 500,
        poll: 1000,
        ignored: /node_modules/
    }
    return config
}
