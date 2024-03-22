import SwiftUI

struct RecipeIngredientList: View {
    @State var recipe: Recipe
    let scaleFactor: Double
    var body: some View {
        VStack(alignment: .leading){
            ForEach(recipe.unsectionedIngredients) { ingredient in
                Text(ingredientDisplay(ingredient, scale: scaleFactor))
                    .padding(.horizontal)
            }
            Spacer()
            
            ForEach(recipe.sectionLabels, id: \.self) { sectionLabel in
                Text(sectionLabel)
                    .bold()
                    .padding(.horizontal)
                ForEach(recipe.ingredientsForSectionLabel(label: sectionLabel)) { ingredient in
                    Text(ingredientDisplay(ingredient, scale: scaleFactor))
                        .padding(.horizontal)
                }
                Spacer()
            }
            
            ForEach(recipe.instructions) { instruction in
                Text(instruction.instructionText)
                    .padding(.horizontal)
                Spacer()
            }
            Text("Notes")
                .bold()
                .padding(.horizontal)
            TextEditor(text: $recipe.notes)
                .frame(height: 200)
                .padding(.horizontal)
        }
    }
}

func ingredientDisplay(_ recipeIngredient: RecipeIngredient, scale: Double) -> String {
    var  returnString = ""
    if let quantity = recipeIngredient.quantity {
        returnString.append(String(quantity * scale) + " ")
    }
    if let unit = recipeIngredient.unit {
        returnString.append(unit + " ")
    }
    returnString.append(recipeIngredient.ingredient.name)
    return returnString
}


#Preview {
  let preview = PreviewContainer([Recipe.self])
  let recipe = Recipe.previewData[0]
  return NavigationStack {
    RecipeDetail(recipe: recipe)
      .modelContainer(preview.container)
  }
}
