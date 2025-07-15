require "rails_helper"

RSpec.describe Api::V1::LoansController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/loans").to route_to("api/v1/loans#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/loans/1").to route_to("api/v1/loans#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/loans").to route_to("api/v1/loans#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/loans/1").to route_to("api/v1/loans#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/loans/1").to route_to("api/v1/loans#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/loans/1").to route_to("api/v1/loans#destroy", id: "1")
    end

    it "routes to #return" do
      expect(patch: "/api/v1/loans/1/return").to route_to("api/v1/loans#return", id: "1")
    end
  end
end
# bundle exec rspec spec/routing/loans_routing_spec.rb