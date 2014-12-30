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
        expect(user).to receive(:authenticate)
        post :create, email: "jabba@thehut.com", password: "jabba12345"
      end
    end

  end

end
