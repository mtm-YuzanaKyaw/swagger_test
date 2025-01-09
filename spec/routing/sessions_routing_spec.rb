require "rails_helper"

RSpec.describe Users::SessionsController, type: :routing do
  describe "routing" do
    it "users/sessions#create" do
      expect(post: "/login").to route_to("users/sessions#create")
    end

    it "users/sessions#destroy" do
      expect(delete: "/logout").to route_to("users/sessions#destroy")
    end
  end
end
