require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count

      # Get a user from the fixtures
      user = users(:grace)

      perform_login(user)
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(User.count).must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      new_user = User.new(uid: 111111, username: "mona", email: "mona@yahoo.com", provider: "github")
      # binding.pry
      #
      expect {
        perform_login(new_user)
      }.must_change "User.count", 1

      new_user = User.find_by(uid: 111111)
      must_respond_with :redirect
      must_redirect_to root_path
      expect(session[:user_id]).must_equal new_user.id
    end

    it "redirects to the root route if given invalid user data" do
      new_user = User.new(uid: 11111, email: "mona@yahoo.com", provider: "github")

      expect {
        perform_login(new_user)
      }.wont_change "User.count"

      must_respond_with :redirect
      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end

    it "can log out a user" do
      expect {
        delete logout_path
      }.wont_change "User.count"

      must_respond_with :redirect
      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end
end
