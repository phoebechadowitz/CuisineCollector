import Foundation
import UIKit
import SwiftData
@Model
class Recipe: Identifiable {
    var id: UUID = UUID()
    var name: String
    var details: String?
    var credit: String?
    var thumbnailUrl: URL?
    var cuisine: Cuisine
    var mealCourse: MealCourse
    var ingredients: [RecipeIngredient] = []
    var instructions: [Instruction] = []
    var sectionLabels: [String] = []
    var lastPreparedAt: Date?
    var notes: String
    var unsectionedIngredients: [RecipeIngredient] { ingredients.filter{ nil == $0.sectionLabel } }
    
    init(name: String, details: String? = nil, credit: String? = nil, thumbnailUrl: URL? = nil, cuisine: Cuisine, mealCourse: MealCourse, ingredients: [RecipeIngredient] = [], instructions: [Instruction] = [], sectionLabels: [String] = [], lastPreparedAt: Date? = nil, notes: String = "") {
        self.name = name
        self.details = details
        self.credit = credit
        self.thumbnailUrl = thumbnailUrl
        self.cuisine = cuisine
        self.mealCourse = mealCourse
        self.ingredients = ingredients
        self.instructions = instructions.sorted {
            $0.position < $1.position
        }
        self.sectionLabels = sectionLabels
        self.lastPreparedAt = lastPreparedAt
        self.notes = notes
    }
    
    func ingredientsForSectionLabel(label: String) -> [RecipeIngredient] {
        ingredients.filter { label == $0.sectionLabel }
            .sorted { $0.position < $1.position }
    }
    
    static func mealCourseFilter(course: MealCourse, recipes: [Recipe]) -> [Recipe] {
        recipes.filter{ course == $0.mealCourse }
    }
    
    
    
}

enum Cuisine: Codable {
    case american
    case chinese(region: String)
    case japanese
    case italian(winePairing: ItalianWine)
}

enum ItalianWine: Codable {
    case barolo
    case brunello
    case taurisi
}

enum MealCourse: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case appetizer
    case main
    case side
    case dessert
}

struct RecipeIngredient: Identifiable, Codable {
    var id: UUID = UUID()
    var ingredient: Ingredient
    var quantity: Double?
    var unit: String?
    var note: String?
    var position: Int = 999999
    var sectionLabel: String?
    
}

struct Ingredient: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
}

struct Instruction : Identifiable, Codable {
    var id: UUID = UUID()
    var position: Int = 999999
    var instructionText: String
}

extension Recipe {
    static let previewData: [Recipe] = [
        Recipe(
            name: "Gong Bao Chicken With Peanuts",
            details: "A more authentic Kung Pao",
            credit: "adapted from 'Every Grain of Rice: Simple Chinese Home Cooking', by Fuchsia Dunlop (W.W. Norton & Company, 2013)",
            thumbnailUrl: URL(string: "https://education-jrp.s3.amazonaws.com/RecipeImages/KungPaoChicken.png"),
            cuisine: .chinese(region: "Sichuan"),
            mealCourse: .main,
            ingredients: [
                
                RecipeIngredient(ingredient: Ingredient(name: "garlic"), quantity: 3, unit: "cloves", position: 2, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "potato starch or corn starch"), quantity: 0.75, unit: "tsp", position: 14, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "spring onions"), quantity: 5, note: "white parts only", position: 4, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "dried chiles"), unit: "A handful of", position: 5, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "cooking oil"), quantity: 2, unit: "Tbsp", position: 6, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "boneless chicken breasts"), quantity: 2, note: "(11 to 12 ounces total), with or without skin", position: 1, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "Chinkiang vinegar"), quantity: 1, unit: "Tbsp", note: "or use balsamic vinegar", position: 17, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Sichuan Pepper"), quantity: 1, unit: "tsp", note: "whole, toasted", position: 7, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "roasted peanuts"), quantity: 75, unit: "grams", note: "see note", position: 8, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "salt"), quantity: 0.5, unit: "tsp", position: 9, sectionLabel: "Marinade"),
                RecipeIngredient(ingredient: Ingredient(name: "light soy sauce"), quantity: 2, unit: "tsp", position: 10, sectionLabel: "Marinade"),
                RecipeIngredient(ingredient: Ingredient(name: "ginger"), unit: "An equivalent amount of", position: 3, sectionLabel: "Chicken"),
                RecipeIngredient(ingredient: Ingredient(name: "Shaoxing wine"), quantity: 1, unit: "tsp", note: "or use dry sherry or dry vermouth", position: 11, sectionLabel: "Marinade"),
                RecipeIngredient(ingredient: Ingredient(name: "potato starch or corn starch"), quantity: 1.5, unit: "tsp", position: 12, sectionLabel: "Marinade"),
                RecipeIngredient(ingredient: Ingredient(name: "sugar"), quantity: 1, unit: "Tbsp", position: 13, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "dark soy sauce"), quantity: 1, unit: "tsp", position: 15, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "light soy sauce"), quantity: 1, unit: "tsp", position: 16, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "sesame oil"), quantity: 1, unit: "tsp", position: 18, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "chicken stock"), quantity: 1, unit: "Tbsp", note: "or water", position: 19, sectionLabel: "Sauce")
            ],
            instructions: [
                Instruction(position: 1, instructionText: "Cut chicken as evenly as possible into half-inch strips, then cut strips into small cubes. Place in a small bowl. Add marinade ingredients and 1 tablespoon water to bowl. Mix well and set aside."),
                Instruction(position: 3, instructionText: "In a small bowl, combine the sauce ingredients."),
                Instruction(position: 5, instructionText: "Quickly add chicken and stir-fry over a high flame, stirring constantly. As soon as chicken cubes have separated, add ginger, garlic and spring onions and continue to stir-fry until they are fragrant and meat is just cooked through (test one of the larger pieces to make sure)."),
                Instruction(position: 2, instructionText: "Peel and thinly slice garlic and ginger. Chop spring onions into chunks as long as their diameter (to match the chicken cubes). Snip chiles in half or into sections, discarding their seeds."),
                Instruction(position: 6, instructionText: "Give sauce a stir and add to wok, continuing to stir and toss. As soon as the sauce has become thick and shiny, add the peanuts, stir them in and serve."),
                Instruction(position: 4, instructionText: "Heat a seasoned wok over a high flame. Add oil, chiles and Sichuan pepper and stir-fry briefly until chiles are darkening but not burned. (Remove wok from heat if necessary to prevent overheating.)")
            ],
            sectionLabels: ["Chicken", "Marinade", "Sauce"]
        ),
        Recipe(
            name: "Green Beans with Miso Butter",
            details: "A great all purpose side dish. Those unfamiliar with miso will wonder what makes the dish so good. Is it Japanese?  Well, Japanese-ish-fusion-America-something.",
            credit: "Adapted from the May 2012 issue of Bon Appetit magazine from a recipe by Patrick Fleming from Boke Bowl in Portland, Oregon",
            thumbnailUrl: URL(string: "https://education-jrp.s3.amazonaws.com/RecipeImages/MisoGreenBeans.jpg"),
            cuisine: .japanese,
            mealCourse: .side,
            ingredients: [
                RecipeIngredient(ingredient: Ingredient(name: "green beans"), quantity: 0.5, unit: "pound", note: "trimmed", position: 1),
                RecipeIngredient(ingredient: Ingredient(name: "unsalted butter"), unit: "2 Tbsp plus 2 tsp", note: "room temperature", position: 2),
                RecipeIngredient(ingredient: Ingredient(name: "miso"), quantity: 2, unit: "tsp", position: 3),
                RecipeIngredient(ingredient: Ingredient(name: "vegetable oil"), quantity: 2, unit: "Tbsp", position: 4),
                RecipeIngredient(ingredient: Ingredient(name: "kosher salt and freshly ground black pepper"), position: 5),
                RecipeIngredient(ingredient: Ingredient(name: "shallot"), quantity: 2, unit: "tsp", note: "minced", position: 6),
                RecipeIngredient(ingredient: Ingredient(name: "garlic"), quantity: 1, unit: "clove", note: "minced", position: 7),
                RecipeIngredient(ingredient: Ingredient(name: "sake"), quantity: 0.25, unit: "cup", position: 8),
                RecipeIngredient(ingredient: Ingredient(name: "vegetable broth"), quantity: 0.25, unit: "cup", note: "or water", position: 9),
                RecipeIngredient(ingredient: Ingredient(name: "sesame seeds"), note: "optional", position: 10)
            ],
            instructions: [
                Instruction(position: 1, instructionText: "Whisk butter with miso in a small bowl"),
                Instruction(position: 2, instructionText: "Put green beans in a bowl and microwave for 4-5 minutes until just getting tender. Drain the beans and pat them dry."),
                Instruction(position: 3, instructionText: "Heat vegetable oil in a large skillet over medium-high heat. Add the beans to the skillet and season with salt and pepper. Toss."),
                Instruction(position: 4, instructionText: "Stir in shallot and garlic and cook for 1 minute."),
                Instruction(position: 5, instructionText: "Add sake and cook until evaporated, 1-2 minutes."),
                Instruction(position: 6, instructionText: "Add vegetable broth or water; cook until the sauce thickens and reduces by half, 1 minute or so."),
                Instruction(position: 7, instructionText: "Lower heat to medium; add miso butter mixture and stir until a creamy sauce forms. Garnish with sesame seeds, if desired."),
            ]
        ),
        Recipe(
            name: "Dry-fried Green Beans",
            details: "Sichuan favorite",
            thumbnailUrl: URL(string: "https://education-jrp.s3.amazonaws.com/RecipeImages/SichuanGreenBeans.jpg"),
            cuisine: .chinese(region: "Sichuan"),
            mealCourse: .side,
            ingredients: [
                RecipeIngredient(ingredient: Ingredient(name: "Soy Sauce"), quantity: 3, unit: "Tbsp", position: 1, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Soybean Paste"), quantity: 1, unit: "Tbsp", position: 2, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Shaoxing wine"), quantity: 2, unit: "Tbsp", note: "Or dry sherry", position: 3, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Sugar"), quantity: 2, unit: "tsp", position: 4, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Cornstarch"), quantity: 1, unit: "tsp", position: 5, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Red Pepper Flakes"), quantity: 0.5, unit: "tsp", position: 6, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "White Pepper"), quantity: 0.5, unit: "tsp", note: "ground", position: 7, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Water"), quantity: 4, unit: "Tbsp", note: "ground", position: 8, sectionLabel: "Sauce"),
                RecipeIngredient(ingredient: Ingredient(name: "Green Beans"), quantity: 1, unit: "pound", position: 9),
                RecipeIngredient(ingredient: Ingredient(name: "Vegetable Oil"), quantity: 2, unit: "Tbsp", position: 10),
                RecipeIngredient(ingredient: Ingredient(name: "Ground Pork"), quantity: 0.25, unit: "pound", note: "optional", position: 11),
                RecipeIngredient(ingredient: Ingredient(name: "Scallions"), quantity: 3, note: "white and light green parts sliced thin", position: 12),
                RecipeIngredient(ingredient: Ingredient(name: "Toasted Sesame Oil"), quantity: 1, unit: "tsp", position: 13),
                RecipeIngredient(ingredient: Ingredient(name: "Sichuan peppercorns"), quantity: 1, unit: "tsp", note: "ground, optional", position: 1, sectionLabel: "Aromatics"),
                RecipeIngredient(ingredient: Ingredient(name: "garlic"), quantity: 3, unit: "medium cloves", note: "minced, about 1 Tbsp.", position: 2, sectionLabel: "Aromatics"),
                RecipeIngredient(ingredient: Ingredient(name: "ginger"), quantity: 1, unit: "Tbsp", note: "minced (not grated)", position: 3, sectionLabel: "Aromatics"),
                RecipeIngredient(ingredient: Ingredient(name: "fermented mustard greens"), quantity: 3, unit: "Tbsp", note: "This ingredient is uncommon but vital.", position: 4, sectionLabel: "Aromatics")
            ],
            instructions: [
                Instruction(position: 1, instructionText: "1. Prepare the sauce by mixing in small bowl: soy sauce, soybean paste, sugar, cornstartch, white pepper, pepper flakes, and water. Set this aside."),
                Instruction(position: 2, instructionText: "2. Heat oil in a wok or 12-inch nonstick skillet over high heat. Add the green beans and cook, stirring often, until beans are slightly tender and are shriveled and blackened in spots. This should take 4-8 minutes. Remove the beans from the pan."),
                Instruction(position: 3, instructionText: "3. If you are including the ground pork, reduce the heat to medium-high and add the pork to the pan. Cook the pork for 2 minutes, breaking it up into small pieces."),
                Instruction(position: 4, instructionText: "4. At medium-high heat add the aromatics (garlic, ginger, mustard greens, and optional peppercorns) to the pan (keeping the pork in the pan if using.) Stir until the garlic and ginger are fragant, around 30 seconds."),
                Instruction(position: 5, instructionText: "5. Give the sauce (still in the small bowl) another stir and then add it to the pan. Add the green beans. Stir to combine and cook until the suace thickens, 10-15 seconds. Remove pan from heat and stir in scallions and sesame oil.")
            ],
            sectionLabels: ["Sauce", "Aromatics"]
        ),
        Recipe(
            name: "Rigatoni with Beef and Onion Ragu",
            details: "Also known as a Neopolitan ragu or sometimes 'pasta all Genovese', though it is from Campania and not Liguria, hence the pairing with the Taurisi.",
            credit: "Adapted from Cooks Illustrated magazine, Nov/Dec 2013 issue",
            thumbnailUrl: URL(string: "https://education-jrp.s3.amazonaws.com/RecipeImages/NeopolitanRagu.jpg"),
            cuisine: .italian(winePairing: .taurisi),
            mealCourse: .main,
            ingredients: [
                RecipeIngredient(ingredient: Ingredient(name: "Boneless beef chuck-eye roast"), quantity: 1, unit: "1- to 1 1/4-pound", note: "cut into 4 pieces and trimmed of large pieces of fat", position: 1),
                RecipeIngredient(ingredient: Ingredient(name: "Pancetta"), quantity: 2, unit: "oz",  note: "cubed into 1/2-inch pieces", position: 2),
                RecipeIngredient(ingredient: Ingredient(name: "Salami"), quantity: 2, unit: "oz", note: "cut into 1/2-inch pieces", position: 3),
                RecipeIngredient(ingredient: Ingredient(name: "Carrot"), quantity: 1, unit: "small", note: "sliced into 1/2-inch pieces", position: 4),
                RecipeIngredient(ingredient: Ingredient(name: "Celery Rib"), quantity: 1, note: "sliced into 1/2-inch pieces", position: 5),
                RecipeIngredient(ingredient: Ingredient(name: "Onions"), quantity: 2.5, unit: "lbs", note: "halved and cut into 1-inch pieces", position: 6),
                RecipeIngredient(ingredient: Ingredient(name: "Tomato Paste"), quantity: 2, unit: "Tbsp", position: 7),
                RecipeIngredient(ingredient: Ingredient(name: "White Wine"), quantity: 1, unit: "Cup", note: "dry", position: 8),
                RecipeIngredient(ingredient: Ingredient(name: "Marjarom"), quantity: 2, unit: "Tbsp", note: "fresh -- you may substitute Oregano", position: 9),
                RecipeIngredient(ingredient: Ingredient(name: "Rigatoni"), quantity: 1, unit: "lb", position: 10),
                RecipeIngredient(ingredient: Ingredient(name: "Pecorino Romano cheese"), quantity: 1, unit: "oz", note: "grated", position: 11)
            ],
            instructions: [
                Instruction(position: 1, instructionText: "1. Sprinkle beef with 1 teaspoon salt and 1/2 teaspoon pepper and set aside. Place oven rack on lower-middle position and heat oven to 300 degrees."),
                Instruction(position: 2, instructionText: "2. Grind pancetta and salami in food processor until a paste forms, about 30 seconds. Add carrot and celery process again until a paste forms, scraping down sides of bowl as needed. Transfer the resulting to Dutch oven and set aside. Pulse onions in processor in 2 batches, until finely diced."),
                Instruction(position: 3, instructionText: "3. Cook pancetta mixture over medium heat, stirring frequently, until fat is rendered and fond begins to form on bottom of pot, about 5 minutes. Add tomato paste and cook, stirring constantly, until browned. Stir in 2 cups water, scraping up any browned bits. Stir in onions and bring to boil. Stir in 1/2 cup wine and 1 tablespoon marjoram. Add beef and push into onions to ensure that it is submerged. Transfer to oven and cook, uncovered, until beef is fully tender, 2 to 2 1/2 hours."),
                Instruction(position: 4, instructionText: "4. Transfer beef to carving board. Place pot over medium heat and cook, stirring frequently, until mixture is almost completely dry. Stir in remaining 1/2 cup wine and cook for 2 minutes, stirring occasionally. Using 2 forks, shred beef into bite-size pieces. Stir beef and remaining 1 tablespoon marjoram into sauce and season with salt and pepper to taste. Remove from heat, cover, and keep warm."),
                Instruction(position: 5, instructionText: "5. Bring 4 quarts water to boil in large pot. Add rigatoni and 2 tablespoons salt and cook, stirring often, until just al dente. Drain rigatoni and add to warm sauce. Add Pecorino and stir vigorously over low heat until sauce is slightly thickened and rigatoni is fully tender, 1 to 2 minutes. Serve, passing extra Pecorino separately.")
            ]
        )
    ]
}

extension Recipe {
    struct FormData: Identifiable {
        var id: UUID = UUID()
        var name: String = ""
        var details: String = ""
        var credit: String = ""
        var mealCourse: MealCourse = .main
        var thumbnailUrl: String = ""
        var lastPreparedAt: Date = Date()
        var notes: String = ""
        var previouslyPrepared: Bool = false
    }
    
    var dataForForm: FormData {
        FormData(
            id: id,
            name: name,
            details: details ?? "",
            credit: credit ?? "",
            mealCourse: mealCourse,
            thumbnailUrl: thumbnailUrl?.absoluteString ?? "",
            lastPreparedAt: lastPreparedAt ?? Date(),
            notes: notes
        )
    }
    
    static func create(from formData: FormData, context: ModelContext) {
        let recipe = Recipe(name: formData.name, cuisine: .american, mealCourse: formData.mealCourse, notes: formData.notes)
        Recipe.update(recipe, from: formData)
        context.insert(recipe)
    }
    static func update(_ recipe: Recipe, from formData: FormData) {
        recipe.name = formData.name
        recipe.details = formData.details.isEmpty ? nil : formData.details
        recipe.credit = formData.credit.isEmpty ? nil : formData.credit
        recipe.mealCourse = formData.mealCourse
        recipe.thumbnailUrl = URL(string: formData.thumbnailUrl)
        if formData.previouslyPrepared {
            recipe.lastPreparedAt = formData.lastPreparedAt
        }
        else {
            recipe.lastPreparedAt = nil
        }
        recipe.notes = formData.notes
    }
}

