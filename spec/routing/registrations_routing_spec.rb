require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :routing do
  describe "routing" do
    it "users/registrations#create" do
      expect(post: "/signup").to route_to("users/registrations#create")
    end
  end
end
