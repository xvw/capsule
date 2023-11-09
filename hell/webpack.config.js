const path = require("path");
const webpack = require("webpack");

module.exports = {
  entry: "./src/main.js",
  mode: "production",
  target: "web",
  output: {
    path: path.resolve(__dirname, "_build"),
    filename: "hell.js",
  },
  plugins: [new webpack.ProvidePlugin({ Buffer: "process/browser" })],
};
