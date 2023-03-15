# SwiftUICountries 🌍

SwiftUICountries is a cross-platform demo app built using SwiftUI and Composable Architecture (TCA). 

It runs on iOS, macOS, and tvOS, showcasing the power of SwiftUI to create a seamless user experience across multiple Apple platforms. 

This project serves as an example of clean and modular app development using the TCA library.

<p align="center">
<img src="screenshots/ios.png" width="300">
<img src="screenshots/macos.png" width="600">
<img src="screenshots/tvos.png" width="600">
</p>

## Features ✨

- Browse a list of countries with basic information
- Add a country to favorites
- View detailed country profiles, including:
  - Flag
  - Capital (including map)
  - Population
  - Currencies
  - Timezones
  - Neighboring countries
- Search functionality to quickly find countries
- Dark mode support
- Realm used as a persistence layer
- Localized in both English and Italian
- Unit tests

## Getting Started 🚀

### Prerequisites

- Xcode 14.2 or later
- macOS 12.5 or later
- iOS 16, tvOS 16 or later (for running on devices)

### Installation

1. Clone the repository:

```
git clone https://github.com/Zi0P4tch0/SwiftUICountries.git
```

2. Open the `SwiftUICountries.xcodeproj` file in Xcode.

3. Choose the desired target platform (iOS, macOS, or tvOS).

4. Run the app on the simulator or a connected device.

## Built With 🛠

- [SwiftUI](https://developer.apple.com/documentation/swiftui) - User interface toolkit
- [Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) - A library for building SwiftUI applications with a focus on modularity and testability
- [Realm](https://realm.io) - A persistence layer used for data storage

## Contributing 🤝

Contributions, issues, and feature requests are welcome! Feel free to fork the repository and submit a pull request with your changes.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements 💡

- [RESTCountries API](https://restcountries.com) - API used for fetching country information
- [Point-Free](https://www.pointfree.co) - For their great work on Composable Architecture

## 🌟 Useful Resources

Enhance your knowledge and skills in SwiftUI and Composable Architecture with these valuable resources:

1) [Swift Composable Architecture videos](https://www.pointfree.co/collections/composable-architecture) - A collection of informative videos about TCA from Point-Free.
2) [Krzysztof Zabłocki: TCA Best Practices](https://www.merowing.info/the-composable-architecture-best-practices/) - A blog post highlighting best practices for using TCA in your projects.
3) [TCA: Working with SwiftUI bindings](https://swiftpackageindex.com/pointfreeco/swift-composable-architecture/main/documentation/composablearchitecture/bindings) - A guide on how to effectively work with SwiftUI bindings in the context of TCA.

---

Happy coding, and don't hesitate to reach out with any questions or suggestions! 🌟
