exports.config =
  files:
    javascripts: joinTo: 'js/app.js'
    stylesheets: joinTo: 'css/app.css'
    templates: joinTo: 'js/app.js'
  conventions: assets: /^(static)/

  # Slower but more reliable
  watcher: usePolling: true

  # Prevents error on Docker
  notifications: false

  paths:
    watched: [
      'static'
      'css'
      'js'
      'vendor'
      # Added Elm folder
      'elm'
    ]
    public: '../priv/static'
  plugins:

    # Configures elmBrunch
    elmBrunch:
      elmFolder: 'elm'
      mainModules: [ 'Main.elm' ]
      outputFolder: '../js'
      outputFile: 'main.js'
      executablePath: '../node_modules/.bin'


    babel: ignore: [ /vendor/ ]
  modules: autoRequire: 'js/app.js': [ 'js/app' ]
  npm: enabled: true
