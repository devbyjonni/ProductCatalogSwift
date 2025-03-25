import Foundation

class ProductCatalogController {
    // Public list of products
    private var products: [Product] = []

    // Command constants
    private enum Command: String {
        case addProduct = "P"
        case searchProduct = "S"
        case quit = "Q"
    }

    // Main program loop
    func run() {
        while true {
            clearScreen()
            print("🟡 To enter a new product - follow the steps | To quit - enter: \"Q\"")

            guard let category = getUserInput(prompt: "Enter a Category: ") else {
                displayProducts()
                return
            }

            guard let name = getUserInput(prompt: "Enter a Product Name: ") else {
                displayProducts()
                return
            }

            guard let price = readValidPrice(prompt: "Enter a Price: ") else {
                displayProducts()
                return
            }

            products.append(Product(category: category, name: name, price: price))
            printSuccess("✅ The product was successfully added!")
        }
    }

    // Read user input or return nil if user quits
    private func getUserInput(prompt: String) -> String? {
        while true {
            print(prompt, terminator: "")
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty else {
                printError("❌ Input cannot be empty.")
                continue
            }

            if input.uppercased() == Command.quit.rawValue {
                return nil
            }

            return input
        }
    }

    // Read and validate a price or return nil if user quits
    private func readValidPrice(prompt: String) -> Decimal? {
        while true {
            print(prompt, terminator: "")
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                printError("❌ Invalid input.")
                continue
            }

            if input.uppercased() == Command.quit.rawValue {
                return nil
            }

            if let price = Decimal(string: input), price > 0 {
                return price
            } else {
                printError("❌ Invalid price. Please enter a positive number.")
            }
        }
    }

    // Display all products sorted by price
    private func displayProducts() {
        clearScreen()
        print("🟡 Category\tProduct\tPrice")

        let sorted = products.sorted(by: { $0.price < $1.price })

        for product in sorted {
            print("\(product.category)\t\(product.name)\t\(product.price)")
        }

        let total = sorted.reduce(Decimal(0)) { $0 + $1.price }
        print("\nTotal amount: \(total)")

        printCommandMenu()
        handleUserChoice()
    }

    // Handle menu choices
    private func handleUserChoice() {
        while true {
            print("\nEnter a command: ", terminator: "")
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() else {
                continue
            }

            switch input {
            case Command.addProduct.rawValue:
                run()
                return
            case Command.searchProduct.rawValue:
                searchProduct()
                return
            case Command.quit.rawValue:
                exit(0)
            default:
                printError("❌ Invalid choice. Please try again.")
            }
        }
    }

    // Search for a product by name
    private func searchProduct() {
        print("Enter a Product Name: ", terminator: "")
        guard let name = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            printError("❌ Name cannot be empty.")
            return
        }

        if name.uppercased() == Command.quit.rawValue {
            return
        }

        let matches = products.filter { $0.name.lowercased() == name.lowercased() }

        clearScreen()
        print("🟡 Category\tProduct\tPrice")

        if matches.isEmpty {
            printError("\nNo products found matching your search.")
        } else {
            for product in matches {
                print("🟣 \(product.category)\t\(product.name)\t\(product.price)")
            }
        }

        printCommandMenu()
        handleUserChoice()
    }

    // Display command menu
    private func printCommandMenu() {
        print("""
        \nTo enter a new product - enter: "\(Command.addProduct.rawValue)" \
        | To search for a product - enter: "\(Command.searchProduct.rawValue)" \
        | To quit - enter: "\(Command.quit.rawValue)"
        """)
    }

    // Print success message
    private func printSuccess(_ message: String) {
        print(message)
    }

    // Print error message
    private func printError(_ message: String) {
        print(message)
    }

    // Clear the terminal screen
    private func clearScreen() {
        print("\u{001B}[2J\u{001B}[H")
    }
}
