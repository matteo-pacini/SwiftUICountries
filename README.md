# SwiftUICountries

A simple demo app written in SwiftUI, using Swift Composable Architecture and the great [RESTCountries API](https://restcountries.com/).

Works on iOS, iPadOS, tvOS and macOS.

<p align="center">
<img src="screenshots/ios.png" width="300">
<img src="screenshots/macos.png" width="600">
<img src="screenshots/tvos.png" width="600">
</p>


## Features

- Browse countries
- Persistence layer through Realm
    - Once the first fetch goes through, the app will be fully usable when offline
- Error handling
- Unit testing
- Localized in both English and Italian

## Planned features

- [X] Search a country
- [X] Mark a country as favorite (❤️)
- [ ] (macoS) Allow navigation to surrounding countries
- [ ] watchOS 
- [X] tvOS

## Useful resources

- [Swift Composable Architecture repository](https://github.com/pointfreeco/swift-composable-architecture)
- [Swift Composable Architecture videos](https://www.pointfree.co/collections/composable-architecture)
- [Krzysztof Zabłocki: TCA Best Practices](https://www.merowing.info/the-composable-architecture-best-practices/)
- [TCA: Working with SwiftUI bindings](https://swiftpackageindex.com/pointfreeco/swift-composable-architecture/main/documentation/composablearchitecture/bindings)

## License

```
MIT License

Copyright (c) 2023 Codecraft Ltd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```