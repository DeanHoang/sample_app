module ApplicationHelper
	# Returns the full title on a per-page basis. # Documentation comment
	def full_title(page_title = '') # Method def, optional arg
	base_title = "Ruby on Rails Tutorial Sample App" # Variable assignment
	if page_title.empty? # Boolean test
	base_title # Implicit return
	else
	page_title + " | " + base_title # String concatenation
	end
	end
		def login_user user
		session[:user_id] = user.id
	end
	def current_user
		@current_user ||= User.find_by id: session[:user_id]
	end
	
	def login?
	return if current_user
		flash[:danger] = "You need login"
		redirect_to login_path
end
end
