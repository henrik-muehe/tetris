// Generated by CoffeeScript 1.3.2
(function() {
  var G, Game, M, N, P, PI, PJ, PL, PO, PS, PT, PZ, R, height, i, k, pieces, size, txt, width,
    __defineProperty = function(clazz, key, value) {
  if (typeof clazz.__defineProperty == 'function') return clazz.__defineProperty(key, value);
  return clazz.prototype[key] = value;
},
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends =   function(child, parent) {
    if (typeof parent.__extend == 'function') return parent.__extend(child);
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } 
    function ctor() { this.constructor = child; } 
    ctor.prototype = parent.prototype; 
    child.prototype = new ctor; 
    child.__super__ = parent.prototype; 
    if (typeof parent.extended == 'function') parent.extended(child); 
    return child; 
};

  $(window).focus();

  width = 10;

  height = 15;

  size = 30;

  $("#g").css("width", size * width);

  $("#g").css("height", size * height);

  $("#n").css("width", size * 4);

  $("#n").css("height", size * 4);

  R = Raphael;

  M = Math;

  G = R("g");

  N = R("n");

  txt = null;

  P = (function() {

    function P() {
      this.remove = __bind(this.remove, this);

      this.bounds = __bind(this.bounds, this);

      this.clone = __bind(this.clone, this);

      this.down = __bind(this.down, this);

      this.r = __bind(this.r, this);

      this.l = __bind(this.l, this);

      this.draw = __bind(this.draw, this);

      this.rotR = __bind(this.rotR, this);
      this.shape = this.bshape;
      this.blocks = [];
      this.xbase = 0;
      this.ybase = 0;
    }

    __defineProperty(P,  "rotR", function() {
      var col, n, r, row, _i, _j, _ref, _ref1;
      n = [];
      for (row = _i = 0, _ref = this.shape[0].length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; row = 0 <= _ref ? ++_i : --_i) {
        r = [];
        for (col = _j = 0, _ref1 = this.shape.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
          r.push(this.shape[this.shape.length - col - 1][row]);
        }
        n.push(r);
      }
      this.shape = n;
      return this;
    });

    __defineProperty(P,  "draw", function(c) {
      var b, col, row, x, y, _i, _len, _ref, _ref1, _results;
      this.xbase = M.max(0, this.xbase);
      this.xbase = M.min(width - this.shape[0].length, this.xbase);
      _ref = this.blocks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        b = _ref[_i];
        b.remove();
      }
      _ref1 = this.shape;
      _results = [];
      for (y in _ref1) {
        row = _ref1[y];
        _results.push((function() {
          var _results1;
          _results1 = [];
          for (x in row) {
            col = row[x];
            if (col === 1) {
              x = 1.0 * x;
              y = 1.0 * y;
              b = c.rect((this.xbase + x) * size, (+this.ybase + y) * size, size, size);
              b.attr("fill", this.color);
              b.attr("stroke", "#000");
              _results1.push(this.blocks.push(b));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    });

    __defineProperty(P,  "l", function() {
      this.xbase -= 1;
      return this;
    });

    __defineProperty(P,  "r", function() {
      this.xbase += 1;
      return this;
    });

    __defineProperty(P,  "down", function() {
      this.ybase += 1;
      return this;
    });

    __defineProperty(P,  "clone", function() {
      var p;
      p = new this.constructor();
      p.xbase = this.xbase;
      p.ybase = this.ybase;
      p.shape = this.shape;
      return p;
    });

    __defineProperty(P,  "bounds", function() {
      var ba, col, row, x, y, _ref;
      ba = [];
      _ref = this.shape;
      for (y in _ref) {
        row = _ref[y];
        for (x in row) {
          col = row[x];
          if (col === 1) {
            ba.push([x * 1.0 + this.xbase, y * 1.0 + this.ybase]);
          }
        }
      }
      return ba;
    });

    __defineProperty(P,  "remove", function() {
      var b, _i, _len, _ref, _results;
      _ref = this.blocks;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        b = _ref[_i];
        _results.push(b.remove());
      }
      return _results;
    });

    return P;

  })();

  PI = (function(_super) {

    function PI() {
      return PI.__super__.constructor.apply(this, arguments);
    }

    PI = __extends(PI, _super);

    __defineProperty(PI,  "bshape", [[1, 1, 1, 1]]);

    __defineProperty(PI,  "color", 'cyan');

    return PI;

  })(P);

  PJ = (function(_super) {

    function PJ() {
      return PJ.__super__.constructor.apply(this, arguments);
    }

    PJ = __extends(PJ, _super);

    __defineProperty(PJ,  "bshape", [[1, 1, 1], [0, 0, 1]]);

    __defineProperty(PJ,  "color", 'blue');

    return PJ;

  })(P);

  PL = (function(_super) {

    function PL() {
      return PL.__super__.constructor.apply(this, arguments);
    }

    PL = __extends(PL, _super);

    __defineProperty(PL,  "bshape", [[1, 1, 1], [1, 0, 0]]);

    __defineProperty(PL,  "color", 'orange');

    return PL;

  })(P);

  PO = (function(_super) {

    function PO() {
      return PO.__super__.constructor.apply(this, arguments);
    }

    PO = __extends(PO, _super);

    __defineProperty(PO,  "bshape", [[1, 1], [1, 1]]);

    __defineProperty(PO,  "color", 'yellow');

    return PO;

  })(P);

  PS = (function(_super) {

    function PS() {
      return PS.__super__.constructor.apply(this, arguments);
    }

    PS = __extends(PS, _super);

    __defineProperty(PS,  "bshape", [[0, 1, 1], [1, 1, 0]]);

    __defineProperty(PS,  "color", 'green');

    return PS;

  })(P);

  PZ = (function(_super) {

    function PZ() {
      return PZ.__super__.constructor.apply(this, arguments);
    }

    PZ = __extends(PZ, _super);

    __defineProperty(PZ,  "bshape", [[1, 1, 0], [0, 1, 1]]);

    __defineProperty(PZ,  "color", 'purple');

    return PZ;

  })(P);

  PT = (function(_super) {

    function PT() {
      return PT.__super__.constructor.apply(this, arguments);
    }

    PT = __extends(PT, _super);

    __defineProperty(PT,  "bshape", [[0, 1, 0], [1, 1, 1]]);

    __defineProperty(PT,  "color", 'red');

    return PT;

  })(P);

  pieces = [PI, PT, PO, PJ, PL, PS, PZ];

  Game = (function() {

    function Game() {
      this.toggle = __bind(this.toggle, this);

      this.draw = __bind(this.draw, this);

      this.gameover = __bind(this.gameover, this);

      this.persist = __bind(this.persist, this);

      this.rotL = __bind(this.rotL, this);

      this.rotR = __bind(this.rotR, this);

      this.r = __bind(this.r, this);

      this.l = __bind(this.l, this);

      this.drop = __bind(this.drop, this);

      this.tick = __bind(this.tick, this);

      this.check = __bind(this.check, this);

      this.init = __bind(this.init, this);
      this.init();
      this.tick();
      this.toggle();
    }

    __defineProperty(Game,  "init", function() {
      var b, col, r, _i, _j, _k, _len, _ref, _ref1, _ref2;
      if (this.blocks) {
        _ref = this.blocks;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          b = _ref[_i];
          b.remove();
        }
      }
      this.score = 0;
      this.blocks = [];
      if (this.p) {
        this.p.remove();
      }
      this.p = null;
      if (this.next) {
        this.next.remove();
      }
      this.next = null;
      this.m = [];
      for (r = _j = 0, _ref1 = height - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; r = 0 <= _ref1 ? ++_j : --_j) {
        this.m[r] = [];
        for (col = _k = 0, _ref2 = width - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; col = 0 <= _ref2 ? ++_k : --_k) {
          this.m[r][col] = null;
        }
      }
      this.tick();
      return this.draw();
    });

    __defineProperty(Game,  "check", function(p) {
      var b, _i, _len, _ref;
      _ref = p.bounds();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        b = _ref[_i];
        if (b[1] >= height) {
          return false;
        }
        if (this.m[b[1]][b[0]] !== null) {
          return false;
        }
      }
      return true;
    });

    __defineProperty(Game,  "tick", function() {
      if (this.p !== null) {
        if (this.check(this.p.clone().down())) {
          this.p.down();
        } else {
          this.persist(this.p);
          this.p.remove();
          this.draw();
          this.p = null;
        }
      }
      if (this.p === null) {
        this.p = this.next;
        if (this.p !== null && !this.check(this.p)) {
          return this.gameover();
        }
        this.next = new pieces[M.floor(M.random() * pieces.length)]();
      }
      if (this.p) {
        this.p.draw(G);
      }
      return this.next.draw(N);
    });

    __defineProperty(Game,  "drop", function() {
      var _results;
      this.tick();
      _results = [];
      while (this.p.ybase !== 0) {
        _results.push(this.tick());
      }
      return _results;
    });

    __defineProperty(Game,  "l", function() {
      if (this.check(this.p.clone().l())) {
        this.p.l();
        return this.p.draw(G);
      }
    });

    __defineProperty(Game,  "r", function() {
      if (this.check(this.p.clone().r())) {
        this.p.r();
        return this.p.draw(G);
      }
    });

    __defineProperty(Game,  "rotR", function() {
      if (this.check(this.p.clone().rotR())) {
        this.p.rotR();
        return this.p.draw(G);
      }
    });

    __defineProperty(Game,  "rotL", function() {
      var _i, _results;
      _results = [];
      for (_i = 1; _i <= 3; _i++) {
        _results.push(this.rotR());
      }
      return _results;
    });

    __defineProperty(Game,  "persist", function(p) {
      var coord, _i, _len, _ref, _results;
      _ref = p.bounds();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        coord = _ref[_i];
        _results.push(this.m[coord[1]][coord[0]] = p.color);
      }
      return _results;
    });

    __defineProperty(Game,  "gameover", function() {
      this.toggle();
      txt = G.text(0.5 * width * size, 2 * size, "game over\n⏎ to start");
      txt.attr({
        "font-size": "30pt"
      });
      return this.init();
    });

    __defineProperty(Game,  "draw", function() {
      var b, col, full, i, row, rowsKilled, x, y, _i, _j, _len, _ref, _ref1, _ref2, _results;
      _ref = this.blocks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        b = _ref[_i];
        b.remove();
      }
      rowsKilled = 0;
      _ref1 = this.m;
      for (y in _ref1) {
        row = _ref1[y];
        full = true;
        for (x in row) {
          col = row[x];
          if (col === null) {
            full = false;
          }
        }
        if (full) {
          rowsKilled += 1;
          this.m.splice(y, 1);
          this.m.unshift([]);
          for (i = _j = 1; 1 <= width ? _j <= width : _j >= width; i = 1 <= width ? ++_j : --_j) {
            this.m[0].push(null);
          }
        }
      }
      if (rowsKilled > 0) {
        this.score += M.pow(2, rowsKilled - 1) * 1000;
      }
      $("#s").html(this.score);
      _ref2 = this.m;
      _results = [];
      for (y in _ref2) {
        row = _ref2[y];
        _results.push((function() {
          var _results1;
          _results1 = [];
          for (x in row) {
            col = row[x];
            if (col !== null) {
              b = G.rect((x * 1.0) * size, (y * 1.0) * size, size, size);
              b.attr("fill", col);
              b.attr("stroke", "#000");
              _results1.push(this.blocks.push(b));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    });

    __defineProperty(Game,  "toggle", function() {
      if (this.i && this.i !== null) {
        clearInterval(this.i);
        this.i = null;
      } else {
        this.i = setInterval(this.tick, 1000);
      }
      if (txt !== null) {
        txt.remove();
        return txt = null;
      }
    });

    return Game;

  })();

  i = new Game();

  k = {};

  k[13] = i.toggle;

  k[37] = i.l;

  k[39] = i.r;

  k[38] = i.rotR;

  k[40] = i.rotL;

  k[32] = i.drop;

  $(document).keydown(function(e) {
    if (k[e.which]) {
      return k[e.which]();
    }
  });

}).call(this);
