module RackSessionsFix
  extend ActiveSupport::Concern
  class FakeRackSession < Hash
    def enabled?
      fase
    end
    def destroy; end
  end

  included do
    before_action :set_fake_sessions

    private
    def set_fake_sessions
      request.env["rack.session"] ||= FakeRackSession.new
    end
  end
end
