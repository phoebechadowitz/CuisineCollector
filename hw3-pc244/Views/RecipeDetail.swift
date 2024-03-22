import SwiftUI
import SwiftData

struct RecipeDetail: View {
    let recipe: Recipe
    @State var scaleFactor: Double = 1
    @State private var editRecipeFormData: Recipe.FormData = Recipe.FormData()
    @State private var isPresentingRecipeForm: Bool = false
    
    var body: some View {
        ScrollView {
            AsyncImage(url: recipe.thumbnailUrl) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(6)
            } placeholder: {
                if recipe.thumbnailUrl != nil {
                    ProgressView()
                } else {
                    Image(systemName: "food")
                }
            }
            Text(recipe.name)
                .fontWeight(.bold)
            Button("Previously Prepared", systemImage: recipe.lastPreparedAt == nil ? "circle" : "checkmark.circle.fill") {
                if recipe.lastPreparedAt == nil {
                    recipe.lastPreparedAt = Date.now
                }
                else {
                    recipe.lastPreparedAt = nil
                }
            }
            Text(cuisineString(recipe.cuisine))
            Spacer()
            HStack{
                Text("Scale the recipe")
                Picker("Scale the recipe", selection: $scaleFactor) {
                    Text("0.5").tag(0.5)
                    Text("1").tag(1.0)
                    Text("2").tag(2.0)
                }
            }
            .pickerStyle(.menu)
            RecipeIngredientList(recipe: recipe, scaleFactor: scaleFactor)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    editRecipeFormData = recipe.dataForForm
                    if recipe.lastPreparedAt != nil {
                        editRecipeFormData.previouslyPrepared = true;
                    }
                    isPresentingRecipeForm.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresentingRecipeForm) {
            NavigationStack {
                RecipeForm(data: $editRecipeFormData)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                isPresentingRecipeForm.toggle()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing)
                        {
                            Button("Save") {
                                Recipe.update(recipe, from: editRecipeFormData)
                                isPresentingRecipeForm.toggle()
                            }
                        }
                    }
            }
        }
    }
}

func cuisineString(_ cuisine: Cuisine) -> String {
    switch cuisine {
    case .american: "American"
    case .chinese(let region): "Chinese - \(region)"
    case .japanese: "Japanese"
    case .italian(let winePairing): "Italian, pair with \(winePairing)"
    }
}

#Preview {
    let preview = PreviewContainer([Recipe.self])
    let recipe = Recipe.previewData[0]
    return NavigationStack {
        RecipeDetail(recipe: recipe)
            .modelContainer(preview.container)
    }
}

