(function() {
  var Flocks;
  Flocks = {
      prettyDemo: {
            width: 855,
            height: 500,
            boids: 120,
            boid: {
                    radius: 4
                  },
            inspectOne: true,
            legend: true,
            startOnPageLoad: true,
            controls: false
          },
      cohesionDemo: {
            width: 300,
            height: 300,
            startOnPageLoad: false,
            inspectOne: true,
            boids: 15,
            scale: 2.5,
            boid: {
                    neighbourRadius: 35,
                    desiredSeparation: 5,
                    maxSpeed: 1,
                    wrapFactor: 0.5,
                    indicators: {
                              alignment: false,
                              separation: false,
                              neighbourRadius: true,
                              neighbours: true,
                              cohesion: true,
                              cohesionMean: true,
                              cohesionNeighbours: true
                            }
                  }
          },
      alignmentDemo: {
            width: 300,
            height: 300,
            startOnPageLoad: false,
            inspectOne: true,
            boids: 15,
            scale: 2.5,
            boid: {
                    neighbourRadius: 35,
                    desiredSeparation: 5,
                    maxSpeed: 1,
                    wrapFactor: 0.5,
                    indicators: {
                              alignment: true,
                              alignmentNeighbours: true,
                              velocity: true,
                              separation: false,
                              neighbourRadius: true,
                              neighbours: true,
                              cohesion: false
                            }
                  }
          },
      separationDemo: {
            width: 300,
            height: 300,
            startOnPageLoad: false,
            inspectOne: true,
            boids: 15,
            scale: 2.5,
            boid: {
                    neighbourRadius: 35,
                    desiredSeparation: 5,
                    maxSpeed: 1,
                    wrapFactor: 0.5,
                    indicators: {
                              alignment: false,
                              velocity: false,
                              separation: true,
                              separationRadius: true,
                              neighbourRadius: true,
                              neighbours: true
                            }
                  }
          }
    };
  jQuery(function() {
      var canvas, decorations, div, flock, name, options, _fn;
      _fn = function(flock) {
            var s, start, _i, _len, _ref, _results;
            if (flock.options.controls) {
                    start = $('<button></button').addClass('awesome').html('Start');
                    flock.clicked = function(timeRunning) {
                              return start.html(timeRunning ? "Stop" : "Start");
                            };
                    start.appendTo(div).click(flock.processing.mouseClicked);
                    _ref = [10, 50, 100, 200];
                    _results = [];
                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                              s = _ref[_i];
                              _results.push((function(s) {
                                          var btn;
                                          return btn = $('<button></button>').addClass('awesome').appendTo(div).html("" + s + "%").click(function() {
                                                        var boid, _i, _len, _ref, _results;
                                                        _ref = flock.boids;
                                                        _results = [];
                                                        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                                                                        boid = _ref[_i];
                                                                        _results.push(boid.maxSpeed = s / 100 * 2);
                                                                      }
                                                        return _results;
                                                      });
                                        })(s));
                            }
                    return _results;
                  }
          };
      for (name in Flocks) {
            options = Flocks[name];
            div = $("#" + name);
            canvas = $('<canvas></canvas>').attr('width', options.width).attr('height', options.height).appendTo(div)[0];
            options.flock = flock = new Harry.Flock(canvas, options);
            _fn(flock);
          }
      options = Flocks.prettyDemo.flock.options;
      decorations = true;
      return $('#decorateDemo').click(function(e) {
            var name, _i, _len, _ref, _results;
            if (decorations) {
                    e.target.innerHTML = "Decorate";
                  } else {
                          e.target.innerHTML = "Undecorate";
                        }
            decorations = !decorations;
            _ref = ['legend', 'inspectOne', 'inspectOneMagnification'];
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    name = _ref[_i];
                    _results.push(options[name] = decorations);
                  }
            return _results;
          }).trigger('click');
    });
}).call(this);
