require 'rails_helper'

RSpec.describe UserSessionsController, :type => :controller do

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    # it "returns http success" do
    #   get :create
    #   expect(response).to have_http_status(:success)
    # end
    context "with correct credentials" do
      let!(:user) { User.create(first_name: "Jabba", last_name: "Thehut", email: "jabba@thehut.com", password: "jabba12345", password_confirmation: "jabba12345") }

      it "redirects to the todo list path" do
        post :create, email: "jabba@thehut.com", password: "jabba12345"
        expect(response).to be_redirect
        expect(response).to redirect_to(todo_lists_path)
      end

      it "finds the user" do
        expect(User).to receive(:find_by).with({email: "jabba@thehut.com"}).and_return(user)
        post :create, email: "jabba@thehut.com", password: "jabba12345"
      end

      it "authenticates the user" do
        #deprecated:
        #User.stub(:find_by).and_return(user)
        allow(User).to receive(:find_by).and_return(user)
        # expect the found user object to receive the authenticate method
        expect(user).to receive(:authenticate)
        post :create, email: "jabba@thehut.com", password: "jabba12345"
      end

      it "sets the user_id in the session" do
        #allows rails app to know the user is logged in
        post :create, email: "jabba@thehut.com", password: "jabba12345"
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets the flash success message" do
        post :create, email: "jabba@thehut.com", password: "jabba12345"
        expect(flash[:success]).to eq("Thanks for logging in!")
      end
    end


    shared_examples_for "denied login" do
      it "renders the new template" do
        post :create, email: email, password: password
        expect(response).to render_template('new')
      end

      it "sets the flash error message" do
        post :create
        expect(flash[:error]).to eq("There was a problem logging in. Please check our email and password.")
      end
    end


    context "with blank credentials" do
      let(:email) { "" }
      let(:password) { "" }
      it_behaves_like "denied login"
    end

    context "with an incorrect password" do
      let!(:user) { User.create(first_name: "Jabba", last_name: "Thehut", email: "jabba@thehut.com", password: "jabba12345", password_confirmation: "jabba12345") }
      let(:email) { user.email }
      let(:password) { "hello" }
      it_behaves_like "denied login"
    end

    context "with no email in existence" do
      let(:email) { "none@found.com" }
      let(:password) { "password" }
      it_behaves_like "denied login"
    end

      

  end

end
