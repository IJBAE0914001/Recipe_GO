import Foundation

extension Recipe {
    static let preview = Recipe(
        id: "1",
        title: "Spaghetti Carbonara",
        thumbnail: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg",
        instructions: "Bring a large pot of salted water to a boil. Add the pasta and cook until al dente.\n\nMeanwhile, heat the olive oil in a large skillet over medium heat. Add the bacon and cook until crisp, about 5 minutes. Add the garlic and cook for 1 minute more.\n\nIn a small bowl, whisk together the eggs, cheese, and black pepper.\n\nDrain the pasta, reserving 1/2 cup of the cooking water. Add the pasta to the skillet with the bacon and toss to coat. Remove from the heat.\n\nPour the egg mixture over the pasta and toss quickly to coat, adding the reserved cooking water as needed to create a creamy sauce. Serve immediately.",
        ingredients: Ingredient.preview
    )
}
