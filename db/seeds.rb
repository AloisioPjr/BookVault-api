puts "Seeding admin user..."

admin_email = "admin@bookvault.dev"
admin_password = "password123"

admin = User.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.password_confirmation = admin_password
admin.admin = true
admin.save!

puts " Admin user created:"
puts "Email: #{admin_email}"
puts "Password: #{admin_password}"

puts "Seeding 30 books...."

books = [
  { title: "To Kill a Mockingbird", author: "Harper Lee", isbn: "9780061120084", genre: "Fiction", copies_available: 4 },
  { title: "1984", author: "George Orwell", isbn: "9780451524935", genre: "Dystopian", copies_available: 5 },
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", isbn: "9780743273565", genre: "Classic", copies_available: 3 },
  { title: "Pride and Prejudice", author: "Jane Austen", isbn: "9780141439518", genre: "Romance", copies_available: 2 },
  { title: "The Hobbit", author: "J.R.R. Tolkien", isbn: "9780547928227", genre: "Fantasy", copies_available: 6 },
  { title: "Moby-Dick", author: "Herman Melville", isbn: "9781503280786", genre: "Adventure", copies_available: 3 },
  { title: "War and Peace", author: "Leo Tolstoy", isbn: "9781853260629", genre: "Historical", copies_available: 2 },
  { title: "The Catcher in the Rye", author: "J.D. Salinger", isbn: "9780316769488", genre: "Fiction", copies_available: 4 },
  { title: "Brave New World", author: "Aldous Huxley", isbn: "9780060850524", genre: "Science Fiction", copies_available: 3 },
  { title: "The Lord of the Rings", author: "J.R.R. Tolkien", isbn: "9780544003415", genre: "Fantasy", copies_available: 5 },
  { title: "Jane Eyre", author: "Charlotte Brontë", isbn: "9780141441146", genre: "Gothic", copies_available: 4 },
  { title: "Animal Farm", author: "George Orwell", isbn: "9780451526342", genre: "Satire", copies_available: 5 },
  { title: "Crime and Punishment", author: "Fyodor Dostoevsky", isbn: "9780143058144", genre: "Philosophical", copies_available: 3 },
  { title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", isbn: "9780374528379", genre: "Philosophy", copies_available: 2 },
  { title: "Wuthering Heights", author: "Emily Brontë", isbn: "9780141439556", genre: "Romance", copies_available: 3 },
  { title: "Fahrenheit 451", author: "Ray Bradbury", isbn: "9781451673319", genre: "Dystopian", copies_available: 5 },
  { title: "The Alchemist", author: "Paulo Coelho", isbn: "9780061122415", genre: "Adventure", copies_available: 6 },
  { title: "Frankenstein", author: "Mary Shelley", isbn: "9780141439471", genre: "Horror", copies_available: 4 },
  { title: "The Road", author: "Cormac McCarthy", isbn: "9780307387899", genre: "Post-apocalyptic", copies_available: 3 },
  { title: "Slaughterhouse-Five", author: "Kurt Vonnegut", isbn: "9780385333849", genre: "Satire", copies_available: 2 },
  { title: "Don Quixote", author: "Miguel de Cervantes", isbn: "9780060934347", genre: "Classic", copies_available: 4 },
  { title: "The Picture of Dorian Gray", author: "Oscar Wilde", isbn: "9780141439570", genre: "Philosophical", copies_available: 3 },
  { title: "Dracula", author: "Bram Stoker", isbn: "9780141439846", genre: "Horror", copies_available: 5 },
  { title: "Les Misérables", author: "Victor Hugo", isbn: "9780451419439", genre: "Historical", copies_available: 2 },
  { title: "The Count of Monte Cristo", author: "Alexandre Dumas", isbn: "9780140449266", genre: "Adventure", copies_available: 3 },
  { title: "The Kite Runner", author: "Khaled Hosseini", isbn: "9781594631931", genre: "Drama", copies_available: 4 },
  { title: "A Tale of Two Cities", author: "Charles Dickens", isbn: "9780141439600", genre: "Historical", copies_available: 2 },
  { title: "Little Women", author: "Louisa May Alcott", isbn: "9780147514011", genre: "Family", copies_available: 3 },
  { title: "Rebecca", author: "Daphne du Maurier", isbn: "9780380730407", genre: "Mystery", copies_available: 4 },
  { title: "The Book Thief", author: "Markus Zusak", isbn: "9780375842207", genre: "Historical Fiction", copies_available: 3 }
]

books.each do |attrs|
  Book.find_or_create_by!(isbn: attrs[:isbn]) do |book|
    book.title = attrs[:title]
    book.author = attrs[:author]
    book.genre = attrs[:genre]
    book.copies_available = attrs[:copies_available]
  end
end
puts "30 books seeded"
