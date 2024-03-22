import SwiftData
import SwiftUI

struct RecipeForm: View {
    @Binding var data: Recipe.FormData
    var body: some View {
        Form {
            
                
                TextFieldWithLabel(label: "Name", text: $data.name)
                TextFieldWithLabel(label: "Details", text: $data.details)
                TextFieldWithLabel(label: "Credit", text: $data.credit)
                Picker("Meal Course", selection: $data.mealCourse) {
                    ForEach(MealCourse.allCases) { course in
                        Text(course.rawValue)
                    }
                }
                .bold()
                .font(.caption)
                .pickerStyle(.menu)
                TextFieldWithLabel(label: "Thumbnail URL", text: $data.thumbnailUrl)
                Toggle("Previously Prepared", isOn: $data.previouslyPrepared)
                    .bold()
                    .font(.caption)
    
                if data.previouslyPrepared {
                    DatePicker("Last Prepared", selection: $data.lastPreparedAt)
                        .bold()
                        .font(.caption)
                }
            VStack(alignment: .leading) {
                Text("Notes")
                    .bold()
                    .font(.caption)
                TextEditor(text: $data.notes)
                    .frame(height: 200)
            }
            }
            .padding(.leading)
        }
    }

#Preview {
    let preview = PreviewContainer([Recipe.self])
    let data = Binding.constant(Recipe.previewData[0].dataForForm)
    return RecipeForm(data: data)
        .modelContainer(preview.container)
}
