const path = require('path')
const webpack = require('webpack')
const TerserPlugin = require('terser-webpack-plugin')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')

module.exports = () => ({
    entry: './src/index.js',
    // devtool: 'cheap-module-eval-source-map',
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: ['style-loader', 'css-loader'],
            },
            {
                test: /\.jsx?$/,
                exclude: /node_modules/,
                resolve: {
                    extensions: [
                        '.js',
                        '.jsx',
                    ],
                },
                use: {
                    loader: 'babel-loader',
                    options: {
                        cacheDirectory: true,
                        cacheCompression: false
                    }
                }
            }
        ]
    },
    optimization: {
        minimize: true,
        minimizer: [
            new TerserPlugin({
                exclude: /node_modules/,
                parallel: true,
            })
        ]
    },
    plugins: [
        new LodashModuleReplacementPlugin,
        // new webpack.SourceMapDevToolPlugin({
        //     test: /\.jsx?$/,
        //     exclude: /node_modules/,
        //     columns: false,
        // }),
    ],
    watchOptions: {
        aggregateTimeout: 500,
        poll: 1000,
        ignored: /node_modules/
    },
    devServer: {
        stats: {
            colors: true,
            hash: false,
            version: false,
            timings: false,
            assets: false,
            chunks: false,
            modules: false,
            reasons: false,
            children: false,
            source: false,
            errors: false,
            errorDetails: false,
            warnings: false,
            publicPath: false
        },
        contentBase: path.resolve(__dirname, 'static'),
        host: '0.0.0.0',
        port: 5001,
        disableHostCheck: true,
        writeToDisk: true,
        watchContentBase: true,
        watchOptions: {
            aggregateTimeout: 500,
            poll: 1000,
            ignored: /node_modules/
        }
    },
    output: {
        path: path.resolve(__dirname, 'static/js'),
        filename: 'bundle.js'
    }
})
