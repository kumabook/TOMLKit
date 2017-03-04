import PackageDescription

let package = Package(
    name: "TOMLKit",
    dependencies: [
      .Package(url: "https://github.com/kumabook/TryParsec.git", "0.1.2"),
      .Package(url: "https://github.com/Quick/Quick.git", "1.1.0"),
      .Package(url: "https://github.com/Quick/Nimble.git", "6.0.1"),
    ]
)
