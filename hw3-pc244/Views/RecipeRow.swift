import SwiftUI
import SwiftData
struct RecipeRow: View {
    @Environment(\.modelContext) private var modelContext
    let recipe: Recipe
    var body: some View {
        HStack {
            AsyncImage(url: recipe.thumbnailUrl) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(6)
            } placeholder: {
                if recipe.thumbnailUrl != nil {
                    ProgressView()
                } else {
                    Image(systemName: "fork.knife")
                }
            }
            VStack(alignment: .leading) {
                Text(recipe.mealCourse.rawValue.uppercased())
                    .font(.caption)
                Text(recipe.name)
                    .fontWeight(.bold)
                    .font(.subheadline)
                
            }
            Spacer()
            Image(systemName: recipe.lastPreparedAt == nil ? "circle" : "checkmark.circle.fill")
                .foregroundColor(recipe.lastPreparedAt == nil ? .gray : .green)
        }
        
    }
}

#Preview {
  let preview = PreviewContainer([Recipe.self])
  let recipe = Recipe.previewData[0]
  return
    RecipeRow(recipe: recipe).modelContainer(preview.container)
    .padding()
}
