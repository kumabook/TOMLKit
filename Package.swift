import PackageDescription

let package = Package(
    name: "TOMLKit",
    dependencies: [
      .Package(url: "https://github.com/kumabook/TryParsec.git", "0.1.2"),
    ]
)
