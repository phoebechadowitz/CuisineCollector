import SwiftUI

@main
struct hw3_pc244App: App {
    var body: some Scene {
        WindowGroup {
            RecipeContainer()
                .modelContainer(for: Recipe.self)
        }
    }
}
