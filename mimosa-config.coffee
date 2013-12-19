exports.config =
  modules: ["jshint"]
  watch:
    sourceDir: "src"
    compiledDir: "lib"
    javascriptDir: null
  jshint:
    rules:
      node: true