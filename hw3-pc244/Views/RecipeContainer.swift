import SwiftUI
import SwiftData

struct RecipeContainer: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Recipe.name) var recipes: [Recipe]
    var body: some View {
        NavigationStack {
            RecipeList(recipes: recipes)
        }
        .navigationTitle("Recipes - pc244")
        .onAppear {
            if recipes.isEmpty {
                for recipe in Recipe.previewData {
                    modelContext.insert(recipe)
                }
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer([Recipe.self])
    preview.add(items: Recipe.previewData)
    return NavigationStack {
        RecipeContainer()
            .modelContainer(preview.container)
    }
}
