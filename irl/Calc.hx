package irl;

// Made by @ChevyRay, not sure how to use it yet

// If you say "Using calc" you can add thigns to integers
// myVar.rad();
class Calc
{
        public static inline function deg(x:Float):Float
        {
                return x * (-180 / Math.PI);
        }

        public static inline function rad(x:Float):Float
        {
                return x * (Math.PI / -180);
        }

        public static inline function sin(x:Float):Float
        {
                return Math.sin(rad(x));
        }

        public static inline function cos(x:Float):Float
        {
                return Math.cos(rad(x));
        }

        public static inline function tan(x:Float):Float
        {
                return Math.tan(rad(x));
        }

        public static inline function asin(x:Float):Float
        {
                return Math.asin(rad(x));
        }

        public static inline function acos(x:Float):Float
        {
                return Math.acos(rad(x));
        }

        public static inline function atan(x:Float):Float
        {
                return Math.atan(rad(x));
        }

        public static inline function atan2(y:Float, x:Float):Float
        {
                return deg(Math.atan2(y, x));
        }

        public static inline function isPowerOf2(value:Int):Bool
        {
                return value != 0 && (value & (value - 1)) == 0;
        }

        public static inline function nextPowerOf2(value:Int, step:Bool = false):Int
        {
                if (!step)
                        value--;
                value |= (value >> 1);
                value |= (value >> 2);
                value |= (value >> 4);
                value |= (value >> 8);
                value |= (value >> 16);
                return ++value;
        }

        public static inline function sign(value:Float):Float
        {
                return value > 0 ? 1 : (value < 0 ? -1 : 0);
        }

        public static inline function approach(value:Float, target:Float, amount:Float):Float
        {
                return value < target ? (target < value + amount ? target : value + amount) : (target > value - amount ? target : value - amount);
        }

        public static inline function lerp(from:Float, to:Float, t:Float):Float
        {
                return from + (to - from) * t;
        }

        public static inline function inverseLerp(from:Float, to:Float, value:Float):Float
        {
                return (value - from) / (to - from);
        }

        public static inline function angleTo(x1:Float, y1:Float, x2:Float, y2:Float):Float
        {
                return deg(Math.atan2(y2 - y1, x2 - x1));
        }

        public static inline function angleOf(x:Float, y:Float):Float
        {
                return deg(Math.atan2(y, x));
        }

        public static inline function angleDifference(angle1:Float, angle2:Float):Float
        {
                var diff:Float = (angle2 - angle1) % 360;

                if (diff > 180)
                        return diff - 360;
                else if (diff <= -180)
                        return diff + 360;
                else
                        return diff;
        }

        public static inline function wrapAngle(angle:Float):Float
        {
                angle %= 360;
                if (angle > 180)
                        return angle - 360;
                else if (angle <= -180)
                        return angle + 360;
                else
                        return angle;
        }

        public static inline function anglesEqual(angle1:Float, angle2:Float):Bool
        {
                return angleDifference(angle1, angle2) == 0;
        }

        public static inline function distance(x1:Float, y1:Float, x2:Float = 0, y2:Float = 0):Float
        {
                return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        }

        public static inline function rectRectDistance(x1:Float, y1:Float, w1:Float, h1:Float, x2:Float, y2:Float, w2:Float, h2:Float):Float
        {
                if (x1 < x2 + w2 && x2 < x1 + w1)
                {
                        if (y1 < y2 + h2 && y2 < y1 + h1)
                                return 0;
                        else if (y1 > y2)
                                return y1 - (y2 + h2);
                        else
                                return y2 - (y1 + h1);
                }
                else if (y1 < y2 + h2 && y2 < y1 + h1)
                {
                        if (x1 > x2)
                                return x1 - (x2 + w2);
                        else
                                return x2 - (x1 + w1);
                }
                else if (x1 > x2)
                {
                        if (y1 > y2)
                                return distance(x1, y1, x2 + w2, y2 + h2);
                        else
                                return distance(x1, y1 + h1, x2 + w2, y2);
                }
                else if (y1 > y2)
                        return distance(x1 + w1, y1, x2, y2 + h2);
                else
                        return distance(x1 + w1, y1 + h1, x2, y2);
        }

        public static inline function pointRectDistance(px:Float, py:Float, rx:Float, ry:Float, rw:Float, rh:Float):Float
        {
                if (px >= rx && px <= rx + rw)
                {
                        if (py >= ry && py <= ry + rh)
                                return 0;
                        else if (py > ry)
                                return py - (ry + rh);
                        else
                                return ry - py;
                }
                else if (py >= ry && py <= ry + rh)
                {
                        if (px > rx)
                                return px - (rx + rw);
                        else
                                return rx - px;
                }
                else if (px > rx)
                {
                        if (py > ry)
                                return distance(px, py, rx + rw, ry + rh);
                        else
                                return distance(px, py, rx + rw, ry);
                }
                else if (py > ry)
                        return distance(px, py, rx, ry + rh);
                else
                        return distance(px, py, rx, ry);
        }

        public static inline function clamp(value:Float, min:Float, max:Float):Float
        {
                if (max > min)
                {
                        value = value < max ? value : max;
                        return value > min ? value : min;
                }
                else
                {
                        value = value < min ? value : min;
                        return value > max ? value : max;
                }
        }

        public static inline function clamp01(value:Float):Float
        {
                if (value < 0)
                        return 0;
                else if (value > 1)
                        return 1;
                else
                        return value;
        }

        public static inline function scale(value:Float, min:Float, max:Float, min2:Float, max2:Float):Float
        {
                return min2 + ((value - min) / (max - min)) * (max2 - min2);
        }

        public static inline function scale01(value:Float, min:Float, max:Float):Float
        {
                return (value - min) / (max - min);
        }

        public static inline function scaleClamp(value:Float, min:Float, max:Float, min2:Float, max2:Float):Float
        {
                value = min2 + ((value - min) / (max - min)) * (max2 - min2);

                if (max2 > min2)
                {
                        value = value < max2 ? value : max2;
                        return value > min2 ? value : min2;
                }
                else
                {
                        value = value < min2 ? value : min2;
                        return value > max2 ? value : max2;
                }
        }

        public static inline function quadraticBezier(from:Float, control:Float, to:Float, t:Float):Float
        {
                return from * (1 - t) * (1 - t) + control * 2 * (1 - t) * t + to * t * t;
        }

        public static inline function cubicBezier(from:Float, c1:Float, c2:Float, to:Float, t:Float):Float
        {
                return t * t * t * (to + 3 * (c1 - c2) - from) + 3 * t * t * (from - 2 * c1 + c2) + 3 * t * (c1 - from) + from;
        }

        public static inline function catmullRom(a:Float, b:Float, c:Float, d:Float, t:Float):Float
        {
                return 0.5 * ((2.0 * b) + ( -a + c) * t + (2.0 * a - 5.0 * b + 4 * c - d) * t * t + ( -a + 3.0 * b - 3.0 * c + d) * t * t * t);
        }

        public static inline function circumference(radius:Float):Float
        {
                return Math.PI * 2 * radius;
        }

        public static inline function arcLength(radius:Float, angle1:Float, angle2:Float):Float
        {
                return circumference(radius) * (angleDifference(angle1, angle2) / 360);
        }

        public static inline function determinant(x1:Float, y1:Float, x2:Float, y2:Float):Float
        {
                return x1 * y2 - y1 * x2;
        }

        public static inline function dotProduct(x1:Float, y1:Float, x2:Float, y2:Float):Float
        {
                return x1 * x2 + y1 * y2;
        }

        public static inline function loop(value:Float, min:Float, max:Float):Float
        {
                var a:Float = Math.min(min, max);
                var b:Float = Math.max(min, max);
                var range:Float = b - a;
                value %= range;

                if (value < a)
                        return value + range;
                else if (value > b)
                        return value - range;
                else
                        return value;
        }

        public static inline function loop01(value:Float):Float
        {
                value %= 1;

                if (value < 0)
                        return value + 1;
                else
                        return value;
        }

        public static inline function wave(value:Float, min:Float, max:Float):Float
        {
                return scale(Math.sin(scale(loop(value, min, max), min, max, -Math.PI, Math.PI)), -1, 1, min, max);
        }

        public static inline function wave01(value:Float):Float
        {
                return scale(Math.sin(scale(loop01(value), 0, 1, -Math.PI, Math.PI)), -1, 1, 0, 1);
        }

        public static inline function moveAngleX(length:Float, angle:Float):Float
        {
                return cos(angle) * length;
        }

        public static inline function moveAngleY(length:Float, angle:Float):Float
        {
                return sin(angle) * length;
        }

        public static inline function smoothStep(t:Float):Float
        {
                return t * t * (3 - 2 * t);
        }

        public static inline function smoothLerp(start:Float, end:Float, t:Float):Float
        {
                return start + smoothStep(t) * (end - start);
        }

        public static inline function round(value:Float):Int
        {
                return Math.round(value);
        }

        public static inline function floor(value:Float):Int
        {
                return Math.floor(value);
        }

        public static inline function ceil(value:Float):Int
        {
                return Math.ceil(value);
        }

        public static inline function pow(base:Float, power:Float):Float
        {
                return Math.pow(base, power);
        }

        public static inline function exp(value:Float):Float
        {
                return Math.exp(value);
        }

        public static inline function sqrt(value:Float):Float
        {
                return Math.sqrt(value);
        }

        public static inline function isMultiple(smallValue:Int, largeValue:Int):Bool
        {
                return largeValue % smallValue == 0;
        }
}