# Project Arken (WIP Title)

A functional 2D game written using the Emo8 game engine. Project Arken is the placeholder title until a title is determined. This game is inspired by the old NES game Contra.

### Brief

CodeWorld, Elm and PureScript are typed functional programming languages for interactive web applications. This project should develop a web-based 2D game sufficiently different from those already available. 
The goal is not only to develop the game but to study the pros and cons of using a typed functional language compiled to JavaScript compared to writing JavaScript manually. A comparison could be made on aspects such as documentation and support, maintainability, ease of integration with other tools and libraries.

### Why PureScript?

Because it is a functional language that can write programs with good expression and good readabilities.
It is also compiled into JavaScript and easy to distribute.

|            | Expressive power  | Ease of distribution                |
| ---------- | ----------------- | ----------------------------------- |
| Haskell    | ○                 | △ (Hard to convert into JavaScript) |
| Elm        | △ (No type class) | ○                                   |
| PureScript | ○                 | ○                                   |

## Specification

- Display: variable size (recommended 256px~1024px)
- Background Color: HTML Named Color 140 colors
- Emoji: Unicode Emoji - [Supported Emojis](docs/emoji.md)
- Input: 8 buttons（up down left right 4 buttons x 2）
- Map: No limit Emoji map - [Map Edit](docs/usage.md#map-edit)
- Sound: 4 channels Emoji score - [Sound Edit](docs/usage.md#sound-edit)
- Language: [PureScript](http://www.purescript.org/)
- Compiled File Volume: about 500KB~1MB
- Frame Rate: about 60 FPS
- Operating Environment: web browser

## Controller

- Keyboard

```
 /¯¯¯\_/¯¯¯\
|  W  |  ↑  |
| A D | ← → |
|  S  |  ↓  |
 \___/¯\___/
```

## Sample Programs

Clone this repository first.
`yarn` is required. 
`npm install yarn -g`

### Install

```sh
yarn
1 - purescript-record#^1.0.0
1 - purescript-typelevel-prelude#^3.0.0
yarn postinstall
```

### Build

```sh
yarn build
yarn projectArken
```

### Start (Open html in browser)

```sh
copy index.html into /dist
open dist/index.html
```

## Simple Manual

- [Usage](docs/usage.md)

## Emo8 Engine Documentation

- [Module documentation on Pursuit](https://pursuit.purescript.org/packages/purescript-emo8/)

## Known Issues

- emoji rotate (45°, 135°, 225°, 315°) problem on canvas [Why won't emojis render when rotated to 45 (or 315) degrees?](https://stackoverflow.com/questions/39749540/why-wont-emojis-render-when-rotated-to-45-or-315-degrees)

## License

[MIT](LICENSE)
