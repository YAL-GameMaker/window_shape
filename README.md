# window_shape

**Quick links:** [documentation](https://yal.cc/docs/gm/window_shape/)
· [itch.io](https://yellowafterlife.itch.io/gamemaker-window-shape)  
**Platforms:** Windows, Windows (YYC)​  
**Versions:** GM:S 1.4, GMS2.2, GMS2.3/GM2022+

This extension lets you use custom window shapes in your GameMaker projects!

Ellipses, rectangles, polygons, complex shapes - anything goes.

Good for software, virtual pets, or more novel game ideas  
(e.g. [BLAWK](https://im-a-good-boye.itch.io/blawk) used my [Desktop Screenshots](https://yellowafterlife.itch.io/gamemaker-display-screenshot) extension to make a "hole" in a game window, but now you can have a real, click-through hole).

## What's interesting here

As more and more boilerplate gets automated through GmlCppExtFuncs,
extensions are left to be fairly normal-looking C++ code.

The only thing left to do is forwarding C++ enums
(which aren't even enums in WinAPI's case) to GML -
currently I have to make an enum with plain numbers
(which GmxGen will convert into GML constants)
and write a bunch of `static_assert`s to ensure that each value matches
its C++ counterpart.

## Building

See [BUILD.md](BUILD.md)

## Meta

**Author:** [YellowAfterlife](https://github.com/YellowAfterlife)  
**License:** Custom license (see [LICENSE](LICENSE))
