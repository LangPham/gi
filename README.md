# Gi
[![Elixir CI](https://github.com/LangPham/gi/actions/workflows/elixir.yml/badge.svg)](https://github.com/LangPham/gi/actions/workflows/elixir.yml)
![Hex.pm](https://img.shields.io/hexpm/l/gi)
![Hex.pm](https://img.shields.io/hexpm/v/gi)

Gi is a library for manipulating Graphics Interfacing. Use utility mogrify, identify, ... of GraphicsMagick to resize, draw on base images....

## Requirements
You must have [GraphicsMagick](http://www.graphicsmagick.org/) installed of course.

## Features
Utilities for image:
* Resize image to width x height with ratio (WxH)
```elixir
Gi.open("example.jpg") # example.jpg (300x200)
|> Gi.gm_mogrify(resize: "200x100")
|> Gi.save() # => example.jpg (150x100)
```
* Resize image to width x height (WxH!)
```elixir
Gi.open("example.jpg") # example.jpg (300x200)
|> Gi.gm_mogrify(resize: "200x100!")
|> Gi.save() # => example.jpg (200x100)
```
* Format image to jpg, png, webp, ...
```elixir
Gi.open("example.jpg")
|> Gi.gm_mogrify(format: "webp")
|> Gi.save() # => create new file "example.webp"
```  
* Draw text on image text x,y 'string'
```elixir
Gi.open("example.jpg")
|> Gi.gm_mogrify(draw: "text 150,150 'Theta.vn'")
|> Gi.save() 
```  

* Draw image on image "image Over x,y,w,h file"
```elixir
Gi.open("example.jpg")
|> Gi.gm_mogrify(draw: "image Over 100,100,200, 200 dir/logo.a")
|> Gi.save()
```

* Multi utilities
```elixir
Gi.open("example.jpg")
|> Gi.gm_mogrify([resize: "300x200", draw: "text 150,150 'Theta.vn'"])
|> Gi.save()
```

* Combine multiple images into one
```elixir
Gi.open("frame.png")
|> Gi.gm_composite(["background.jpg","result.png"])
```  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `gi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gi, "~> 0.1.0"}
  ]
end
```

Documentation [https://hexdocs.pm/gi](https://hexdocs.pm/gi).

