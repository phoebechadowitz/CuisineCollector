import SwiftData
import SwiftUI

struct RecipeList: View {
    @Environment(\.modelContext) private var modelContext
    @State var isPresentingRecipeForm: Bool = false
    @State private var newRecipeFormData = Recipe.FormData()
    var recipes: [Recipe]
    
    var body: some View {
        List(recipes) { recipe in
            NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                RecipeRow(recipe: recipe)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") { isPresentingRecipeForm.toggle() }
            }
        }
        .sheet(isPresented: $isPresentingRecipeForm) {
            NavigationStack {
                RecipeForm(data: $newRecipeFormData)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") { isPresentingRecipeForm.toggle() }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                Recipe.create(from: newRecipeFormData, context: modelContext)
                                newRecipeFormData = Recipe.FormData()
                                isPresentingRecipeForm.toggle()
                            }
                        }
                        
                    }
                    .navigationTitle("Add Recipe")
            }
        }
    }
}
    #Preview {
        let preview = PreviewContainer([Recipe.self])
        return NavigationView {
            RecipeList(recipes: Recipe.previewData)
                .modelContainer(preview.container)
        }
    }
    
