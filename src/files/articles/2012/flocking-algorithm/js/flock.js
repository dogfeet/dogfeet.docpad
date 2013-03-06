(function() {
  var font;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  font = false;
  Harry.Flock = (function() {
    var everStarted;
    Flock.defaults = {
      boids: 100,
      boid: {
        maxSpeed: 2,
        maxForce: 0.05,
        radius: 3,
        mousePhobic: false
      },
      clickToStop: true,
      startPosition: new Harry.Vector(0.5, 0.5),
      frameRate: 20,
      inspectOne: false,
      inspectOneMagnification: false,
      legend: false,
      startOnPageLoad: false,
      antiFlicker: true,
      scale: 1,
      startNotification: false,
      controls: true,
      border: true
    };
    everStarted = false;
    function Flock(canvas, options) {
      this.run = __bind(this.run, this);;      this.options = jQuery.extend({}, Flock.defaults, options);
      this.processing = new Processing(canvas, this.run);
    }
    Flock.prototype.run = function(processing) {
      var boids, inspectorGadget, timeRunning;
      processing.frameRate(this.options.frameRate);
      processing.scaledHeight = processing.height / this.options.scale;
      processing.scaledWidth = processing.width / this.options.scale;
      timeRunning = this.options.startOnPageLoad;
      this.boids = boids = this._getBoids(processing);
      inspectorGadget = boids[boids.length - 1];
      processing.draw = __bind(function() {
        var boid, _i, _j, _k, _len, _len2, _len3;
        processing.pushMatrix();
        processing.scale(this.options.scale);
        Harry.Mouse = new Harry.Vector(processing.mouseX / this.options.scale, processing.mouseY / this.options.scale);
        processing.background(255);
        for (_i = 0, _len = boids.length; _i < _len; _i++) {
          boid = boids[_i];
          boid.renderedThisStep = false;
        }
        if (timeRunning) {
          this.everStarted = true;
          for (_j = 0, _len2 = boids.length; _j < _len2; _j++) {
            boid = boids[_j];
            boid.step(boids);
          }
        }
        for (_k = 0, _len3 = boids.length; _k < _len3; _k++) {
          boid = boids[_k];
          boid.render(boids);
        }
        processing.popMatrix();
        inspectorGadget.forceInspection = this.options.inspectOne;
        if (this.options.inspectOneMagnification && this.options.inspectOne) {
          this._drawInspector(inspectorGadget, processing);
        }
        if (this.options.startNotification && !this.everStarted) {
          this._drawStartNotification(processing);
        }
        if (this.options.legend) {
          font || (font = processing.loadFont('/fonts/aller_rg-webfont'));
          this._drawLegend(processing);
        }
        if (this.options.border) {
          processing.stroke(0);
          processing.noFill();
          processing.rect(0, 0, processing.width - 1, processing.height - 1);
        }
        return true;
      }, this);
      if (this.options.clickToStop) {
        return processing.mouseClicked = __bind(function() {
          var boid, _i, _len;
          for (_i = 0, _len = boids.length; _i < _len; _i++) {
            boid = boids[_i];
            boid.inspectable = timeRunning;
          }
          timeRunning = !timeRunning;
          if (this.clicked != null) {
            return this.clicked.call(this, timeRunning);
          }
        }, this);
      }
    };
    Flock.prototype._getBoids = function(processing) {
      var i, options, start, startPosition, velocity, _ref, _results;
      if (this.options.boids.call != null) {
        this.options.boids(processing);
      } else {

      }
      start = new Harry.Vector(processing.scaledWidth, processing.scaledHeight);
      start.x = start.x * this.options.startPosition.x;
      start.y = start.y * this.options.startPosition.y;
      options = jQuery.extend(true, {
        processing: processing
      }, this.options.boid);
      _results = [];
      for (i = 1, _ref = this.options.boids; (1 <= _ref ? i <= _ref : i >= _ref); (1 <= _ref ? i += 1 : i -= 1)) {
        velocity = new Harry.Vector(Math.random() * 2 - 1, Math.random() * 2 - 1);
        startPosition = start;
        _results.push(new Harry.Boid(jQuery.extend(options, {
          velocity: velocity,
          startPosition: startPosition
        })));
      }
      return _results;
    };
    Flock.prototype._drawLegend = function(processing) {
      var ctx, demo, l, legends, _i, _len;
      processing.fill(230);
      processing.stroke(0);
      processing.strokeWeight(1);
      processing.pushMatrix();
      processing.translate(0, processing.height - 101);
      processing.rect(0, 0, 100, 100);
      processing.textFont(font, 14);
      processing.fill(0);
      processing.text("Legend", 24, 15);
      processing.translate(10, 16);
      demo = new Harry.Vector(0, -12);
      ctx = {
        p: processing
      };
      legends = [
        {
          name: "Velocity",
          r: 0,
          g: 0,
          b: 0
        }, {
          name: "Separation",
          r: 250,
          g: 0,
          b: 0
        }, {
          name: "Alignment",
          r: 0,
          g: 250,
          b: 0
        }, {
          name: "Cohesion",
          r: 0,
          g: 0,
          b: 250
        }
      ];
      processing.pushMatrix();
      processing.strokeWeight(2);
      processing.textFont(font, 12);
      for (_i = 0, _len = legends.length; _i < _len; _i++) {
        l = legends[_i];
        processing.translate(0, 20);
        processing.stroke(l.r, l.g, l.b);
        processing.fill(l.r, l.g, l.b);
        Harry.Boid.prototype._renderVector.call(ctx, demo, 1);
        processing.text(l.name, 8, -2);
      }
      processing.popMatrix();
      return processing.popMatrix();
    };
    Flock.prototype._drawAntiFlicker = function(processing) {
      processing.stroke(255);
      processing.strokeWeight(this.options.radius + 1);
      processing.noFill();
      return processing.rect(this.options.radius / 2 - 1, this.options.radius / 2 - 1, processing.width - this.options.radius + 1, processing.height - this.options.radius + 1);
    };
    Flock.prototype._drawInspector = function(boid, processing) {
      processing.stroke(0);
      processing.strokeWeight(1);
      processing.fill(230);
      processing.rect(0, 0, 100, 100);
      processing.pushMatrix();
      processing.translate(50, 50);
      processing.scale(2);
      boid._renderSelfWithIndicators([], false);
      return processing.popMatrix();
    };
    Flock.prototype._drawStartNotification = function(processing) {
      processing.fill(0);
      processing.textFont(font, 12);
      return processing.text("click me to start", processing.width / 2 - 35, processing.height - 10);
    };
    return Flock;
  })();
}).call(this);
