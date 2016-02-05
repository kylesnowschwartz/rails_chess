require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:game) { Game.create! }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http redirect" do
      get :create
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, { id: game.id }
      expect(response).to have_http_status(:success)
    end
  end

end
