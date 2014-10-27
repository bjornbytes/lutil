lutil
=====

My Lua utility file.

Class
---

Lutil provides a very lightweight class system.  Here's how you use it:

    -- Declare a class
    local Cat = class()
    
    Cat.sound = 'meow'

    function Cat:speak()
      print(self.sound)
    end

    function Cat:purr()
      print('purr')
    end

    -- Inheritance
    local Lion = extend(Cat)
    Lion.sound = 'rawr'

    -- Constructors
    function Lion:init(name)
      self.name = name
    end

    -- Instantiation
    local simba = Lion('simba') -- or new(Lion, 'simba')
    print(simba.name)
    simba:speak()
    simba:purr()

Math
---

- `math.sign(x)` returns the sign of `x` (-1, 0, or 1).
- `math.round(x)` rounds `x` to the nearest whole number away from zero.
- `math.clamp(x, min, max)` clamps `x` between `min` and `max`.
- `math.lerp(x1, x2, z)` linearly interpolates between `x1` and `x2`.  For example, passing in `.5` for `z` will return a value halfway between `x1` and `x2`.
- `math.anglerp(d1, d2, z)` linearly interpolates between two angles (in radians).
- `math.dx(length, direction)` returns the x-component of a vector with length `length` and direction `direction` (in radians).
- `math.dy(length, direction)` returns the y-component of a vector with length `length` and direction `direction` (in radians).
- `math.distance(x1, y1, x2, y2)` returns the distance between two points.
- `math.direction(x1, y1, x2, y2)` returns the direction between to points (in radians).
- `math.vector(x1, y1, x2, y2)` returns the distance and direction between two points.
- `math.inside(px, py, rx, ry, w, h)` returns true if the point (`px`, `py`) is inside the rectangle with the top-left corner located at (`rx`, `ry`), width equal to `rw` and height equal to `rh`.
- `math.anglediff(d1, d2)` returns the difference between two angles (in radians).

