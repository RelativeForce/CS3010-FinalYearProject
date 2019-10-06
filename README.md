# Revoked

Revoked is a 2D side scrolling shooter inspired by the NES game Contra. Set in 1991 Wyoming USA players take up the mantel of Lieutenant G Ravestomper. Tasked with flushing out an insurgent cell from their base under the rocky mountains, all rests on the lieutenant when the cell deploys their newest weapon. Fight with a variety of guns and powerups through the rough terrain and relentless enemy soldiers.  When all hope is lost heroes will rise.

This repository contains a functional 2D game written using the Emo8 game engine. The web app that is used to deploy the game and manage the game persistence is developed in .Net Core 2.1. Code first Entity Framework is used for SQL database management.

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

- Display: Variable size (recommended 720px 16:9)
- Input: 8 buttons（up down left right 4 buttons x 2）
- Map: No limit Emoji map - [Map Edit](docs/usage.md#map-edit)
- Sound: 4 channels Emoji score - [Sound Edit](docs/usage.md#sound-edit)
- Language: [PureScript](http://www.purescript.org/)
- Deployed https://revoked.azurewebsites.net
- Target Frame Rate: 60 FPS (Depending on hardware acceleration)
- Operating Environment: Web browser
- Development Environment: Visual Studio 2019

## Controller

- Keyboard

```
 /¯¯¯\_/¯¯¯\
|  W  |  ↑  |
| A D | ← → |
|  S  |  ↓  |
 \___/¯\___/
```

### Install

```sh
npm install yarn -g
cd "./Revoked.Web/Client"
yarn
1 - purescript-record#^1.0.0
1 - purescript-typelevel-prelude#^3.0.0
yarn postinstall
```
### Build

Open Revoked.sln in Visual Studio 2019
Build Solution (Game is built as part of .Net Core build)

## Local Database
A developement database is required to run the web app locally. Requires SQLExpress 2017

1. Open Revoked.Core in the package manager console in Visual Studio 2019
2. `update-database`

## Simple Manual

- [Usage](docs/usage.md)

## Emo8 Engine Documentation

- [Module documentation on Pursuit](https://pursuit.purescript.org/packages/purescript-emo8/)

## Known Issues

- emoji rotate (45°, 135°, 225°, 315°) problem on canvas [Why won't emojis render when rotated to 45 (or 315) degrees?](https://stackoverflow.com/questions/39749540/why-wont-emojis-render-when-rotated-to-45-or-315-degrees)

## License

[MIT](LICENSE)
