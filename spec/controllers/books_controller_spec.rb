require File.expand_path '../../spec_helper.rb', __FILE__
require 'factory_girl'

describe BooksController do
  context "Logged in" do
    before do
      @user = FactoryGirl.create(:active_user)
      session[:user_id] = @user.id
    end

    context "with permission to create book" do
      before { PrincipalBooksPermission.create(@user, [:add]) }

      context "and own a book" do
        before do
          @book = FactoryGirl.create(:free_book)
          @user.own_books << @book
          get :show, id: @book.id
        end

        describe "GET change_visibility" do
          it "should change visibility" do
            get :change_visibility, id: @book.id
            assigns(:book).should eq @book
          end
        end
      end

    end

  end
end
