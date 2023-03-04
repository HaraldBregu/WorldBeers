# WorldBeers

WorldBeers, a multinational beer industry, is the client of the app, and there are plans to augment the app with additional features and release it in multiple countries.

<img src="https://raw.githubusercontent.com/HaraldBregu/WorldBeers/master/icon.png?token=GHSAT0AAAAAAB7NRNOHAWIF2TH5RWGGAMKYZACOS5A"  width="300" height="300">

## How to start
To start developing this app you need CocoaPods installed and than run:

```
pod install
```

## How to extend features

The app is structured in a way to be scaled vertically. Each model created should be conformed to Drink protocol:

```swift

protocol Drink: Codable {}

struct Beer: Drink {}

```

You can use NetworkService to make http requests or create a custom class conformed to Networking protocol:

```swift

class BeerService: Networking

```

Use the same UI Layout for every type of drink without changing anything in the code.
