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
