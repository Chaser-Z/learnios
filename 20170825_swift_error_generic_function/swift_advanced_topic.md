# Swift Apprentice 4 - Advanced Topics

# Error Handling

## The ErrorType protocol

```swift
enum RollingError: Error {
    case Doubles
    case OutOfFunding
}
```

## Throwing errors

**Roll function**

```swift
var hasFunding = true
func roll(firstDice: Int, secondDice: Int) throws {
    let error: RollingError
    if firstDice == secondDice && hasFunding { // 1
        error = .Doubles
        hasFunding = false
        throw error
    } else if firstDice == secondDice && !hasFunding { // 2
        hasFunding = true
        print("Huzzah! You raise another round of funding!")
    } else if !hasFunding { // 3
        error = .OutOfFunding
        throw error
    } else { // 4
        print("You moved \(firstDice + secondDice) spaces")
    }
}
```

**The throws keyword**

**Move function**

```swift
func move(firstDice: Int, secondDice: Int) -> String {
    do {
        try roll(firstDice: firstDice, secondDice: secondDice)
        return "Successful roll."
    } catch RollingError.Doubles {
        return "You rolled doubles and have lost your funding"
    } catch RollingError.OutOfFunding {
        return "You need to do another round of funding."
    } catch {
        return "Unknown error"
    }
}
```

## Advanced error handling

**Failable initializers**

```swift
enum Direction {
    case Left
    case Right
    case Forward
}

class PugBot {
    let name: String
    let correctPath: [Direction]
    var currentStepInPath = 0
    
    init?(name: String, correctPath: [Direction]) {
        self.correctPath = correctPath
        self.name = name

        guard correctPath.count > 0 else {
            return nil
        }

        switch name {
        case "Delia", "Olive", "Frank", "Otis", "Doug":
            break
        default:
            return nil
        }
    }
}
```

**Chain error-throwing functions**

```swift
enum PugBotError: Error {
    case DidNotTurnLeft(directionMoved: Direction)
    case DidNotTurnRight(directionMoved: Direction)
    case DidNotGoForward(directionMoved: Direction)
    case EndOfPath
}

class PugBot {
    let name: String
    let correctPath: [Direction]
    var currentStepInPath = 0
    
    init?(name: String, correctPath: [Direction]) {
        self.correctPath = correctPath
        self.name = name
        
        guard correctPath.count > 0 else {
            return nil
        }
        
        switch name {
        case "Delia", "Olive", "Frank", "Otis", "Doug":
            break
        default:
            return nil
        }
    }
    
    func turnLeft() throws {
        guard (currentStepInPath < correctPath.count) else {
            throw PugBotError.EndOfPath
        }
        
        let direction = correctPath[currentStepInPath]
        if direction != .Left {
            throw PugBotError.DidNotTurnLeft(directionMoved: direction)
        }
        
        currentStepInPath += 1
    }
    
    func turnRight() throws {
        guard (currentStepInPath < correctPath.count) else {
            throw PugBotError.EndOfPath
        }
        
        let direction = correctPath[currentStepInPath]
        if direction != .Right {
            throw PugBotError.DidNotTurnRight(directionMoved: direction)
        }
        
        currentStepInPath += 1
    }
    
    func moveForward() throws {
        guard (currentStepInPath < correctPath.count) else {
            throw PugBotError.EndOfPath
        }
        
        let direction = correctPath[currentStepInPath]
        if direction != .Forward {
            throw PugBotError.DidNotGoForward(directionMoved: direction)
        }
        
        currentStepInPath += 1
    }
    
    func goHome() throws {
        try moveForward()
        try turnLeft()
        try moveForward()
        try turnRight()
    }
}
```

**Wrapping and handling multiple errors**

```swift
func movePugBotSafely(move: () throws -> ()) -> String {
    do {
        try move()
        return "Completed move successfully."
    } catch PugBotError.DidNotTurnLeft(let directionMoved) {
        return "The PugBot was supposed to turn left, but turned \(directionMoved) instead."
    } catch PugBotError.DidNotTurnRight(let directionMoved) {
        return "The PugBot was supposed to turn right, but turned \(directionMoved) instead."
    } catch PugBotError.DidNotGoForward(let directionMoved) {
        return "The PugBot was supposed to move forward, but turned \(directionMoved) instead."
    } catch PugBotError.EndOfPath() {
        return "The PugBot tried to move past the end of the path."
    } catch {
        return "An unknown error occurred"
    }
}
```

## Key points

* You can create an enum that conforms to the **Error** protocol that works with Swift's error-handling paradigm.* Any function that can throw an error or calls a function that can throw an error has to be marked with **throws**.* When calling an error-throwing function, you must embed it in a **do block**. Within that block, you **try** the function, and if it fails, you **catch** it.* If you have a struct that might fail when being instantiated, you can use a **failable initializer** to ensure that the structure can return nil without crashing the app.
* You can **chain** a complex series of commands together knowing that if any link in the chain fails, the rest of the commands won't execute.

# Generics

## Introducing generics

```swift
struct Cat { }
struct Dog { }

struct KeeperForCats { }
struct KeeperForDogs { }
```

```swift
struct Keeper<T> { }
var aCatKeeper = Keeper<Cat>()
```

## Anatomy of generic types

```swift
struct Cat {
    var name: String
}

struct Dog {
    var name: String
}

struct Keeper<T> {
    var name: String
    var morningAnimal: T
    var afternoonAnimal: T
}

let jason = Keeper(name: "Jason",
    morningAnimal: Cat(name: "Whiskers"),
    afternoonAnimal: Cat(name: "Sleepy"))
```

## Dictionaries

```swift
struct Dictionary<Key : Hashable, Value> // etc..
```

## Optionals

```swift
enum Optional<T> {
    case None
    case Some(T)
}
```

```swift
var birthdate: NSDate? = nil
if birthdate == nil {
    // no birthdate
}
```

## Generic functions

```swift
func swapped<T, U>(_ x: T, _ y: U) -> (U, T) {
    return (y, x)
}
swapped(33, "Jay")  // returns ("Jay", 33)
```

## Key points

* **Generics** express systematic variation at the level of types, via a type parameter that ranges over possible concrete type values.* **Generics** are like functions for the compiler. They are evaluated at **compile time** and result in new types which are specializations of the generic type.* A generic type is **not a real type** on its own, but more like a recipe, program, or template for defining new types.* Generics are everywhere in Swift, in **optionals**, **arrays**, **dictionaries**, other collection structures, and so on.

# Functional Programming

## Function: map

```swift
let animals = ["cat", "dog", "sheep", "dolphin", "tiger"]

func capitalize(_ s: String) -> String {
    return s.uppercased()
}

var uppercaseAnimals: [String] = []
for animal in animals {
    let uppercaseAnimal = capitalize(animal)
    uppercaseAnimals.append(uppercaseAnimal)
}
uppercaseAnimals // ["CAT", "DOG", "SHEEP", "DOLPHIN", "TIGER"]

func characterForCharacterName(_ c: String) -> Character {
    let curlyBracedCharacterName = "\\N{\(c)}"
    let charStr = curlyBracedCharacterName.applyingTransform(
        StringTransform.toUnicodeName,
        reverse: true)
    return charStr!.characters.first!
}

var animalEmojis: [Character] = []
for uppercaseAnimal in uppercaseAnimals {
    let emoji = characterForCharacterName(uppercaseAnimal)
    animalEmojis.append(emoji)
}
animalEmojis // ["🐈", "🐕", "🐑", "🐬", "🐅"]
```

 | captilization | rendering
--- | --- | ---
inputs | animals | uppercaseAnimals
ouputs | uppercaseAnimals | animalEmojis
transform | capitalize | characterForCharacterName

```swift
let inputs: [InputType] = [/* some list of InputType */]
var outputs: [OutputType] = []
for inputItem in inputs {
    let outputItem = transform(inputItem)
    outputs.append(outputItem)
}
outputs // [/* some list of OutputType values */]
```

```swift
func map<InputType, OutputType>(_ inputs: [InputType],
    transform: (InputType) -> (OutputType)) -> [OutputType] {
    var outputs: [OutputType] = []
    for inputItem in inputs {
        let outputItem = transform(inputItem)
        outputs.append(outputItem)
    }
    return outputs
}

let uppercaseAnimals2 = map(animals, transform: capitalize)
let animalEmojis2 = map(uppercaseAnimals, transform: characterForCharacterName)
```

**Swift's version of map**

```swift
let uppercaseAnimals3 = animals.map(capitalize)
let animalEmojis3 = uppercaseAnimals.map(characterForCharacterName)
```

## Function: flatMap

```swift
var values = [[1,3,5,7], [9]]
let flattenResult = values.flatMap{ $0 }
flattenResult
// [1, 3, 5, 7, 9]
```

```swift
let numbers = [1, 2, 3, 4]
let mapped = numbers.map { Array(repeating: $0, count: $0) }
// [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
// [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
```

## Two more functions: filter and reduce

**Filter**

```swift
let threeCharacterAnimals = animals.filter() {
    $0.characters.count == 3
}
threeCharacterAnimals // => ["cat", "dog"]
```

**Reduce**

```swift
func sum(_ items: [Int]) -> Int {
    return items.reduce(0, +)
}
let total = sum([1, 2, 3])
total // => (((0 + 1) + 2) + 3) == 6
```

```swift
func concatenate(_ items: [String]) -> String {
    return items.reduce("", +)
}
let phrase = concatenate(["Hello"," ","World"])
phrase // => ((("" + "Hello") + " ") + "World") == "Hello World"
```

## Key points

* **Functional programming** is a programming style, like object-oriented or protocol- oriented programming.* Many Swift language features exist to support a functional programming style, and originated in functional programming languages.* Most fundamentally, a functional programming style boils down to three practices: **preferring immutable values**, **preferring pure functions**, and making use of **higher-order functions**.


