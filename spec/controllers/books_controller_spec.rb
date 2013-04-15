require File.expand_path '../../spec_helper.rb', __FILE__
require 'factory_girl'

describe BooksController do
  context "Logged in" do
    before do
      DatabaseCleaner.clean
      @user = FactoryGirl.create(:active_user)
      session[:user_id] = @user.id
    end

    context "with permission to create book" do
      before { PrincipalBooksPermission.create(@user, [:add]) }

      context "and owner a book" do
        before do
          @book = FactoryGirl.create(:free_book)
          @user.own_books << @book
        end

        describe "GET change_visibility" do
          before { get :change_visibility, id: @book.id }

          it "should assign book" do
            assigns(:book).should eq @book
          end

          it "should redirect to the show page" do
            response.should redirect_to(book_path @book)
          end
        end

        describe "GET change_visibility to false" do
          before do
            @book.visibility = true
            @book.save
            get :change_visibility, id: @book.id, visible: false
          end

          it "should change visibility to false" do
            @book.reload
            @book.visibility.should be_false
          end
        end

        describe "GET change_visibility to true" do
          before do
            @book.visibility = false
            @book.save
            get :change_visibility, id: @book.id, visible: true
          end

          it "should change visibility to false" do
            @book.reload
            @book.visibility.should eq true
          end
        end

        describe "my" do
          before { get :my }

          it "should assing books to my books" do
            assigns(:books).should eq [@book]
          end
        end
      end

      context "not owner a book" do
        before { @book = FactoryGirl.create(:free_book) }

        describe "GET change_visibility" do
          before { get :change_visibility, id: @book.id }

          it "should assign book" do
            assigns(:book).should eq @book
          end

          it "deny permission" do
            response.status.should eq 403
          end
        end
      end

    end
  end
end
