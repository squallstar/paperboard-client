'use strict';

var mount = function (connect, dir) {
  return connect.static(require('path').resolve(dir));
};

var timestamp = new Date().getTime()

module.exports = function(grunt) {

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-jade-plugin');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-spritesmith');

  grunt.initConfig({

    clean: {
      all: ['application/assets/js', 'application/assets/css', 'public/assest/img/generated'],
      post_build: ['.sass-cache', 'npm-debug.log', '__templates.js']
    },

    coffee: {
      compileJoined: {
        options: {
          join: true
        },
        files: {
          'public/assets/js/paperboard.js': [
            'application/javascript/backbone/prototypes/*.coffee',
            'application/javascript/backbone/boot.coffee',
            'application/javascript/backbone/entities/*.coffee',
            'application/javascript/backbone/modules/**/*.coffee'
          ]
        }
      },
    },

    concat: {
      js: {
        src: [
          'application/javascript/vendor/jquery.js',
          'application/javascript/vendor/underscore.js',
          'application/javascript/vendor/backbone.js',
          'application/javascript/vendor/marionette.js',
          'application/javascript/vendor/plugins/*',
          '__templates.js',
          'public/assets/js/paperboard.js'
        ],
        dest: 'public/assets/js/paperboard.js'
      },
      css: {
        src: [
          'application/css/vendor/reset.css',
          'application/css/vendor/grid.css',
          'public/assets/css/paperboard.css'
        ],
        dest: 'public/assets/css/paperboard.css'
      }
    },

    jade2js: {
      compile: {
        files: {
          '__templates.js': ['application/views/backbone/templates/**/*.jade']
        }
      }
    },

    sass: {
      development: {
        files: {
          'public/assets/css/paperboard.css' : [
            'application/css/scss/main.scss'
          ]
        },
        options: {
          lineNumbers: true,
          style: 'expanded'
        }
      },
      release: {
        files: {
          'public/assets/css/paperboard.css' : [
            'application/css/scss/main.scss'
          ]
        },
        options: {
          style: 'compressed'
        }
      }
    },

    sprite: {
      normal: {
        src: ['application/images/sprites/normal/*.png'],
        destImg: 'public/assets/img/generated/sprite.png',
        destCSS: 'application/css/scss/generated/sprite.scss',
        imgPath: '../img/generated/sprite.png',
        algorithm: 'binary-tree',
        engine: 'gm',
        'engineOpts': {
          'imagemagick': true
        },
        cssFormat: 'scss',
        cssOpts: {
          cssClass: function (item) {
            return '.sprite-' + item.name;
          }
        },
        cssVarMap: function (sprite) {
          sprite.name = 'sprite-' + sprite.name;
        },
        padding: 1
      },
      retina: {
        src: ['application/images/sprites/retina/*.png'],
        destImg: 'public/assets/img/generated/sprite-retina.png',
        destCSS: 'application/css/scss/generated/sprite-retina.scss',
        imgPath: '../img/generated/sprite-retina.png',
        algorithm: 'binary-tree',
        engine: 'gm',
        'engineOpts': {
          'imagemagick': true
        },
        cssFormat: 'scss',
        cssOpts: {
          cssClass: function (item) {
            return '.sprite-retina-' + item.name;
          }
        },
        cssVarMap: function (sprite) {
          sprite.name = 'sprite-retina-' + sprite.name;
        },
        padding: 2
      }
    },

    uglify: {
      release: {
        preserveComments : false,
        files: {
          'public/assets/js/paperboard.js': ['public/assets/js/paperboard.js']
        }
      }
    },

    watch : {
      scss: {
        files: [
          'application/css/**',
        ],
        tasks: ['clean:all', 'sass:development', 'concat:css', 'clean:post_build'],
        options: {
          livereload: true,
          debounceDelay: 1000
        },
      },
      js: {
        files: [
          'application/javascript/**',
          'application/views/backbone/templates/**'
        ],
        tasks: ['clean:all', 'coffee', 'jade2js', 'concat:js', 'clean:post_build'],
        options: {
          livereload: true,
          debounceDelay: 1000
        },
      }
    }

  });

  grunt.registerTask('build', [
    'clean:all',
    'sprite:normal',
    'sprite:retina',
    'sass:development',
    'concat:css',
    'coffee',
    'jade2js',
    'concat:js',
    'clean:post_build'
  ]);

  grunt.registerTask('build:production', [
    'clean:all',
    'sprite:normal',
    'sprite:retina',
    'sass:release',
    'concat:css',
    'coffee',
    'jade2js',
    'concat:js',
    'uglify',
    'clean:post_build'
  ]);

  grunt.registerTask('default', ['build', 'watch']);
}