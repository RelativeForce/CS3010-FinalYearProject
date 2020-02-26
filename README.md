# Revoked

Revoked is a 2D side scrolling shooter inspired by the NES game Contra. Set in 1991 Wyoming USA players take up the mantel of Lieutenant G Ravestomper. Tasked with flushing out an insurgent cell from their base under the rocky mountains, all rests on the lieutenant when the cell deploys their newest weapon. Fight with a variety of guns and powerups through the rough terrain and relentless enemy soldiers.  When all hope is lost heroes will rise.

This repository contains a functional 2D game written using a heavily altered version of the Emo8 game engine. The web app that is used to deploy and manage the data persistence for the game is developed in .Net Core 2.1. code first Entity Framework is used for SQL database management. The game only supports keyboard input and performance is heavily impacted by the client hardware.

### Project Brief

CodeWorld, Elm and PureScript are typed functional programming languages for interactive web applications. This project should develop a web-based 2D game sufficiently different from those already available. 
The goal is not only to develop the game but to study the pros and cons of using a typed functional language compiled to JavaScript compared to writing JavaScript manually. A comparison could be made on aspects such as documentation and support, maintainability, ease of integration with other tools and libraries.

### Why PureScript?

Because it is a functional language that can write programs with good expression and good readabilities.
It is also compiled into JavaScript and easy to distribute.

|            | Expressive power  | Ease of distribution                |
| ---------- | ----------------- | ----------------------------------- |
| Haskell    | Pass                 | Fail (Hard to convert into JavaScript) |
| Elm        | Fail (No type class) | Pass                                   |
| PureScript | Pass                 | Pass                                   |

## Emo8 Engine Documentation

This game uses a heavily altered version of the Emo8 PureScript game engine. Orignally the engine was built around emojis. This has been altered to only use images and display text. While the majority of the engine has been refactored and altered to conform to the requirements of Revoked, credit is required by the MIT Licence.

[Emo8 documentation on Pursuit](https://pursuit.purescript.org/packages/purescript-emo8/)

## Specification

- Display: Variable size (recommended 720px 16:9)
- Map: No limit Emoji map - [Map Edit](docs/usage.md#map-edit)
- Language: [PureScript](http://www.purescript.org/)
- Deployed https://revoked.azurewebsites.net
- Target Frame Rate: 60 FPS (Depending on hardware acceleration)
- Operating Environment: Web browser
- Development Environment: Visual Studio 2019 (.Net Core) and Visual Studio Code (PureScript)
- Source Control: GitHub with ZenHub plugin (https://www.zenhub.com/)

[Updated engine usage guide](docs/usage.md)

## Gameplay Controls

```
Space - Jump
A - Move Left
D - Move Right
Enter - Shoot
M - Mute
```

## Install

```sh
npm install yarn -g
cd "./Revoked.Web/Client"
yarn
yarn postinstall
```
## Build (Requires Install)

Open Revoked.sln in Visual Studio 2019
Build Solution (Game is built as part of .Net Core build)

## Test (Requires Install)

```sh
cd "./Revoked.Web/Client"
yarn test
```

## Local Database
A developement database is required to run the web app locally. Requires SQLExpress 2017

1. Open Revoked.Core in the package manager console in Visual Studio 2019
2. `update-database`

## License

[MIT](LICENSE)
